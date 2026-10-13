import 'dart:convert';

import 'package:drift/drift.dart';

import '../db/app_database.dart';

/// Uygulamayla gelen içerik paketini (JSON) veritabanına yükler.
///
/// İlk seviye ve ilk ünitesi açık olarak başlar (FR-22).
class ContentSeeder {
  ContentSeeder(this._db);

  final AppDatabase _db;

  /// Veritabanında seviye yoksa [json] içeriğini yükler. Yükleme yapıldıysa
  /// `true` döner.
  Future<bool> seedIfEmpty(String json) async {
    final existing = await (_db.select(_db.levels)..limit(1)).get();
    if (existing.isNotEmpty) return false;

    final data = jsonDecode(json) as Map<String, dynamic>;
    final levels = (data['levels'] as List).cast<Map<String, dynamic>>();
    final units = (data['units'] as List).cast<Map<String, dynamic>>();

    await _db.transaction(() async {
      final levelIds = <String, int>{};
      var levelOrder = 0;
      for (final level in levels) {
        final code = level['code'] as String;
        levelIds[code] = await _db
            .into(_db.levels)
            .insert(
              LevelsCompanion.insert(
                code: code,
                sortOrder: ++levelOrder,
                title: level['title'] as String,
              ),
            );
      }

      final unitOrder = <String, int>{};
      int? firstUnitId;
      for (final unit in units) {
        final levelCode = unit['level'] as String;
        final levelId = levelIds[levelCode];
        if (levelId == null) {
          throw FormatException('Bilinmeyen seviye: $levelCode');
        }
        final order = (unitOrder[levelCode] ?? 0) + 1;
        unitOrder[levelCode] = order;
        final unitId = await _db
            .into(_db.units)
            .insert(
              UnitsCompanion.insert(
                levelId: levelId,
                sortOrder: order,
                titleTr: unit['title'] as String,
                theme: unit['theme'] as String,
                icon: Value(unit['icon'] as String?),
              ),
            );
        if (levelCode == levels.first['code'] && order == 1) {
          firstUnitId = unitId;
        }

        await _insertWords(unitId, unit);
      }

      final firstLevelId = levelIds[levels.first['code']]!;
      await _db
          .into(_db.levelProgress)
          .insert(
            LevelProgressCompanion.insert(
              levelId: Value(firstLevelId),
              status: const Value('open'),
            ),
          );
      if (firstUnitId != null) {
        await _db
            .into(_db.unitProgress)
            .insert(
              UnitProgressCompanion.insert(
                unitId: Value(firstUnitId),
                status: const Value('open'),
              ),
            );
      }
    });
    return true;
  }

  Future<void> _insertWords(int unitId, Map<String, dynamic> unit) async {
    for (final word in (unit['words'] as List).cast<Map<String, dynamic>>()) {
      final wordId = await _db
          .into(_db.words)
          .insert(
            WordsCompanion.insert(
              unitId: unitId,
              lemma: word['lemma'] as String,
              pos: word['pos'] as String,
              meaningTr: word['tr'] as String,
              ipa: Value(word['ipa'] as String?),
            ),
          );
      for (final ex in (word['examples'] as List).cast<List<dynamic>>()) {
        await _db
            .into(_db.examples)
            .insert(
              ExamplesCompanion.insert(
                wordId: wordId,
                sentenceEn: ex[0] as String,
                sentenceTr: ex[1] as String,
              ),
            );
      }
    }
  }

  /// İçerik paketinde olup veritabanında olmayan üniteleri (seviye kodu ve
  /// başlığa göre) ekler; uygulama güncellemesinde yeni içerik böyle gelir.
  /// Seviyenin son ünitesi tamamlandıysa ilk yeni ünite açılır. Eklenen
  /// ünite sayısını döner.
  Future<int> addMissingUnits(String json) async {
    final data = jsonDecode(json) as Map<String, dynamic>;
    final units = (data['units'] as List).cast<Map<String, dynamic>>();
    var added = 0;
    await _db.transaction(() async {
      final levels = {
        for (final l in await _db.select(_db.levels).get()) l.code: l.id,
      };
      for (final unit in units) {
        final levelId = levels[unit['level'] as String];
        if (levelId == null) continue;
        final title = unit['title'] as String;
        final existing = await (_db.select(
          _db.units,
        )..where((t) => t.levelId.equals(levelId))).get();
        if (existing.any((u) => u.titleTr == title)) continue;

        existing.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        final last = existing.isEmpty ? null : existing.last;
        final unitId = await _db
            .into(_db.units)
            .insert(
              UnitsCompanion.insert(
                levelId: levelId,
                sortOrder: (last?.sortOrder ?? 0) + 1,
                titleTr: title,
                theme: unit['theme'] as String,
                icon: Value(unit['icon'] as String?),
              ),
            );
        await _insertWords(unitId, unit);
        added++;

        if (last != null) {
          final progress = await (_db.select(
            _db.unitProgress,
          )..where((t) => t.unitId.equals(last.id))).getSingleOrNull();
          if (progress?.status == 'completed') {
            await _db
                .into(_db.unitProgress)
                .insertOnConflictUpdate(
                  UnitProgressCompanion.insert(
                    unitId: Value(unitId),
                    status: const Value('open'),
                  ),
                );
          }
        }
      }
    });
    return added;
  }

  /// İçerik paketindeki kelime ilişkilerini (eş anlam, zıt anlam, kelime
  /// ailesi) ekler (FR-33). İlişkiler iki yönlü kaydedilir; zaten var olanlar
  /// atlanır. Her açılışta çalışabilir. Bulunan ilişki sayısını döner.
  Future<int> syncRelations(String json) async {
    final data = jsonDecode(json) as Map<String, dynamic>;
    final relations = (data['relations'] as List? ?? const [])
        .cast<List<dynamic>>();
    if (relations.isEmpty) return 0;
    var found = 0;
    await _db.transaction(() async {
      final ids = <String, int>{};
      for (final w in await _db.select(_db.words).get()) {
        ids.putIfAbsent(w.lemma.toLowerCase(), () => w.id);
      }
      for (final r in relations) {
        final a = ids[(r[0] as String).toLowerCase()];
        final b = ids[(r[1] as String).toLowerCase()];
        final type = r[2] as String;
        if (a == null || b == null || a == b) continue;
        found++;
        for (final (from, to) in [(a, b), (b, a)]) {
          await _db
              .into(_db.wordRelations)
              .insert(
                WordRelationsCompanion.insert(
                  wordId: from,
                  relatedWordId: to,
                  type: type,
                ),
                mode: InsertMode.insertOrIgnore,
              );
        }
      }
    });
    return found;
  }
}
