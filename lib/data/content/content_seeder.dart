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

        for (final word
            in (unit['words'] as List).cast<Map<String, dynamic>>()) {
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
}
