import 'dart:convert';

import 'package:drift/drift.dart';

import '../db/app_database.dart';

/// Uygulamayla gelen içerik paketini (JSON) veritabanına yükler.
///
/// İlk seviye ve ilk ünitesi açık olarak başlar (FR-22).
class ContentSeeder {
  ContentSeeder(this._db);

  final AppDatabase _db;

  /// Uygulanmış içerik paketinin anahtarının `app_meta` tablosundaki adı.
  static const contentKeyName = 'content_key';

  /// İçerik paketinin kimliği: `version` alanı ve metin uzunluğu. JSON
  /// çözülmeden, dosyanın başından okunur (NFR-01).
  static String contentKey(String json) {
    final head = json.length > 400 ? json.substring(0, 400) : json;
    final version = RegExp(r'"version"\s*:\s*(\d+)').firstMatch(head);
    return '${version?.group(1) ?? '0'}:${json.length}';
  }

  /// Açılışta çağrılır. İçerik paketi son uygulanandan farklıysa (ilk kurulum
  /// ya da güncelleme) içeriği yükler, eksik üniteleri ve kelime ilişkilerini
  /// ekler; aynıysa veritabanına dokunmadan döner. Böylece sonraki açılışlarda
  /// 300 KB'lık JSON hiç çözülmez (NFR-01). Çalışma yapıldıysa `true` döner.
  Future<bool> sync(String json) async {
    final key = contentKey(json);
    if (await _db.metaValue(contentKeyName) == key) return false;
    final data = _decode(json);
    if (!await _seed(data)) {
      await _addMissingUnits(data);
      await _addMissingWords(data);
    }
    await _syncRelations(data);
    await _db.setMetaValue(contentKeyName, key);
    return true;
  }

  static Map<String, dynamic> _decode(String json) =>
      jsonDecode(json) as Map<String, dynamic>;

  /// Veritabanında seviye yoksa [json] içeriğini yükler. Yükleme yapıldıysa
  /// `true` döner.
  Future<bool> seedIfEmpty(String json) => _seed(_decode(json));

  Future<bool> _seed(Map<String, dynamic> data) async {
    final existing = await (_db.select(_db.levels)..limit(1)).get();
    if (existing.isNotEmpty) return false;

    final levels = (data['levels'] as List).cast<Map<String, dynamic>>();
    final units = (data['units'] as List).cast<Map<String, dynamic>>();

    // Boş veritabanında kimlikler sırayla verilir; binlerce satır tek bir
    // toplu işlemde yazılır (tek tek eklemeye göre çok daha hızlı, NFR-01).
    final levelIds = <String, int>{
      for (final (i, level) in levels.indexed) level['code'] as String: i + 1,
    };
    await _db.batch((b) {
      b.insertAll(_db.levels, [
        for (final (i, level) in levels.indexed)
          LevelsCompanion.insert(
            id: Value(i + 1),
            code: level['code'] as String,
            sortOrder: i + 1,
            title: level['title'] as String,
          ),
      ]);

      final unitOrder = <String, int>{};
      var unitId = 0;
      var wordId = 0;
      int? firstUnitId;
      for (final unit in units) {
        final levelCode = unit['level'] as String;
        final levelId = levelIds[levelCode];
        if (levelId == null) {
          throw FormatException('Bilinmeyen seviye: $levelCode');
        }
        final order = (unitOrder[levelCode] ?? 0) + 1;
        unitOrder[levelCode] = order;
        unitId++;
        b.insert(
          _db.units,
          UnitsCompanion.insert(
            id: Value(unitId),
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
        wordId = _addWords(b, unitId, unit, wordId);
      }

      b.insert(
        _db.levelProgress,
        LevelProgressCompanion.insert(
          levelId: Value(levelIds[levels.first['code']]!),
          status: const Value('open'),
        ),
      );
      if (firstUnitId != null) {
        b.insert(
          _db.unitProgress,
          UnitProgressCompanion.insert(
            unitId: Value(firstUnitId),
            status: const Value('open'),
          ),
        );
      }
    });
    return true;
  }

  /// [unit] kelimelerini ve örnek cümlelerini [b] toplu işlemine ekler;
  /// kelime kimlikleri [lastWordId]'den sonra sırayla verilir. Son verilen
  /// kimliği döner.
  int _addWords(
    Batch b,
    int unitId,
    Map<String, dynamic> unit,
    int lastWordId,
  ) {
    var wordId = lastWordId;
    for (final word in (unit['words'] as List).cast<Map<String, dynamic>>()) {
      wordId++;
      b.insert(
        _db.words,
        WordsCompanion.insert(
          id: Value(wordId),
          unitId: unitId,
          lemma: word['lemma'] as String,
          pos: word['pos'] as String,
          meaningTr: word['tr'] as String,
          ipa: Value(word['ipa'] as String?),
        ),
      );
      b.insertAll(_db.examples, [
        for (final ex in (word['examples'] as List).cast<List<dynamic>>())
          ExamplesCompanion.insert(
            wordId: wordId,
            sentenceEn: ex[0] as String,
            sentenceTr: ex[1] as String,
          ),
      ]);
    }
    return wordId;
  }

  /// İçerik paketinde olup veritabanında olmayan üniteleri (seviye kodu ve
  /// başlığa göre) ekler; uygulama güncellemesinde yeni içerik böyle gelir.
  /// Seviyenin son ünitesi tamamlandıysa ilk yeni ünite açılır. Eklenen
  /// ünite sayısını döner.
  Future<int> addMissingUnits(String json) => _addMissingUnits(_decode(json));

  Future<int> _addMissingUnits(Map<String, dynamic> data) async {
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
        final maxWordId = await _db
            .customSelect('SELECT COALESCE(MAX(id), 0) AS m FROM words')
            .getSingle();
        await _db.batch(
          (b) => _addWords(b, unitId, unit, maxWordId.read<int>('m')),
        );
        added++;

        // Seviyenin önceki son ünitesi tamamlandıysa ya da seviye açık ama
        // henüz hiç ünitesi yoksa ilk yeni ünite açılır.
        final bool open;
        if (last == null) {
          final level = await (_db.select(
            _db.levelProgress,
          )..where((t) => t.levelId.equals(levelId))).getSingleOrNull();
          open = level != null && level.status != 'locked';
        } else {
          final progress = await (_db.select(
            _db.unitProgress,
          )..where((t) => t.unitId.equals(last.id))).getSingleOrNull();
          open = progress?.status == 'completed';
        }
        if (open) {
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
    });
    return added;
  }

  /// İçerik paketinde olup veritabanındaki ünitelerde olmayan kelimeleri
  /// (seviye kodu ve ünite başlığına göre) ekler; güncellemeyle mevcut
  /// ünitelere gelen kelimeler böyle eklenir. Kullanıcının kendi eklediği
  /// aynı yazımlı kelime varsa içerikteki atlanır. Eklenen kelime sayısını
  /// döner.
  Future<int> addMissingWords(String json) => _addMissingWords(_decode(json));

  Future<int> _addMissingWords(Map<String, dynamic> data) async {
    final units = (data['units'] as List).cast<Map<String, dynamic>>();
    final levelCodes = {
      for (final l in await _db.select(_db.levels).get()) l.id: l.code,
    };
    final unitIds = {
      for (final u in await _db.select(_db.units).get())
        '${levelCodes[u.levelId]}|${u.titleTr}': u.id,
    };
    final existing = {
      for (final w in await _db.select(_db.words).get()) w.lemma.toLowerCase(),
    };
    final maxWordId = await _db
        .customSelect('SELECT COALESCE(MAX(id), 0) AS m FROM words')
        .getSingle();
    var wordId = maxWordId.read<int>('m');
    var added = 0;
    await _db.batch((b) {
      for (final unit in units) {
        final unitId = unitIds['${unit['level']}|${unit['title']}'];
        if (unitId == null) continue;
        final missing = [
          for (final w in (unit['words'] as List).cast<Map<String, dynamic>>())
            if (!existing.contains((w['lemma'] as String).toLowerCase())) w,
        ];
        if (missing.isEmpty) continue;
        wordId = _addWords(b, unitId, {'words': missing}, wordId);
        added += missing.length;
      }
    });
    return added;
  }

  /// İçerik paketindeki kelime ilişkilerini (eş anlam, zıt anlam, kelime
  /// ailesi) ekler (FR-33). İlişkiler iki yönlü kaydedilir; zaten var olanlar
  /// atlanır. Her açılışta çalışabilir. Bulunan ilişki sayısını döner.
  Future<int> syncRelations(String json) => _syncRelations(_decode(json));

  Future<int> _syncRelations(Map<String, dynamic> data) async {
    final relations = (data['relations'] as List? ?? const [])
        .cast<List<dynamic>>();
    if (relations.isEmpty) return 0;
    var found = 0;
    final ids = <String, int>{};
    for (final w in await _db.select(_db.words).get()) {
      ids.putIfAbsent(w.lemma.toLowerCase(), () => w.id);
    }
    final rows = <WordRelationsCompanion>[];
    for (final r in relations) {
      final a = ids[(r[0] as String).toLowerCase()];
      final b = ids[(r[1] as String).toLowerCase()];
      final type = r[2] as String;
      if (a == null || b == null || a == b) continue;
      found++;
      for (final (from, to) in [(a, b), (b, a)]) {
        rows.add(
          WordRelationsCompanion.insert(
            wordId: from,
            relatedWordId: to,
            type: type,
          ),
        );
      }
    }
    await _db.batch(
      (b) =>
          b.insertAll(_db.wordRelations, rows, mode: InsertMode.insertOrIgnore),
    );
    return found;
  }
}
