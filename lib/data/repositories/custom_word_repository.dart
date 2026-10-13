import 'package:drift/drift.dart';

import '../db/app_database.dart';
import 'word_list_repository.dart';

/// Aynı kelime zaten varsa fırlatılır.
class DuplicateWordException implements Exception {
  const DuplicateWordException(this.lemma);

  final String lemma;

  @override
  String toString() => 'DuplicateWordException($lemma)';
}

/// Kullanıcının kendi eklediği kelimeler (FR-92).
///
/// Bu kelimeler haritada görünmeyen "ÖZ" seviyesindeki tek bir üniteye
/// kaydedilir; böylece aralıklı tekrar, favoriler, notlar ve listeler
/// içerik kelimeleriyle aynı şekilde çalışır, ama seviye ilerlemesi,
/// sınavlar ve seviye tespiti etkilenmez.
class CustomWordRepository {
  CustomWordRepository(this._db);

  final AppDatabase _db;

  /// Kendi kelimelerin gizli seviye kodu.
  static const levelCode = 'ÖZ';

  /// Kendi kelimelerin otomatik eklendiği liste.
  static const defaultListName = 'Kendi kelimelerim';

  static const _title = 'Kendi kelimelerim';
  static const maxLemmaLength = 40;
  static const maxMeaningLength = 80;

  /// Gizli ünitenin kimliği; yoksa `null`.
  Future<int?> unitId() async {
    final level = await (_db.select(
      _db.levels,
    )..where((t) => t.code.equals(levelCode))).getSingleOrNull();
    if (level == null) return null;
    final unit = await (_db.select(
      _db.units,
    )..where((t) => t.levelId.equals(level.id))).getSingleOrNull();
    return unit?.id;
  }

  Future<int> _ensureUnit() async {
    final existing = await unitId();
    if (existing != null) return existing;
    final levelId = await _db
        .into(_db.levels)
        .insert(
          LevelsCompanion.insert(
            code: levelCode,
            sortOrder: 999,
            title: _title,
          ),
        );
    return _db
        .into(_db.units)
        .insert(
          UnitsCompanion.insert(
            levelId: levelId,
            sortOrder: 1,
            titleTr: _title,
            theme: 'custom',
          ),
        );
  }

  /// Kelimeyi ekler, "Kendi kelimelerim" listesine koyar ve kimliğini döner.
  /// Aynı kelime (büyük/küçük harf farkı gözetmeden) varsa
  /// [DuplicateWordException] fırlatılır.
  Future<int> add({
    required String lemma,
    required String meaningTr,
    String? exampleEn,
    String? exampleTr,
  }) {
    final en = _clip(lemma, maxLemmaLength);
    final tr = _clip(meaningTr, maxMeaningLength);
    if (en.isEmpty || tr.isEmpty) {
      throw ArgumentError('Kelime ve anlam boş olamaz');
    }
    return _db.transaction(() async {
      final existing = await (_db.select(
        _db.words,
      )..where((t) => t.lemma.lower().equals(en.toLowerCase()))).get();
      if (existing.isNotEmpty) throw DuplicateWordException(en);

      final unitId = await _ensureUnit();
      final wordId = await _db
          .into(_db.words)
          .insert(
            WordsCompanion.insert(
              unitId: unitId,
              lemma: en,
              pos: 'other',
              meaningTr: tr,
            ),
          );
      final exEn = exampleEn?.trim() ?? '';
      if (exEn.isNotEmpty) {
        await _db
            .into(_db.examples)
            .insert(
              ExamplesCompanion.insert(
                wordId: wordId,
                sentenceEn: exEn,
                sentenceTr: exampleTr?.trim() ?? '',
              ),
            );
      }

      final lists = WordListRepository(_db);
      final defaultList = (await lists.lists())
          .where((l) => l.name == defaultListName)
          .firstOrNull;
      await lists.addWord(
        defaultList?.id ?? await lists.create(defaultListName),
        wordId,
      );
      return wordId;
    });
  }

  /// Kendi eklenen kelimeyi ve ona bağlı tüm kayıtları siler. İçerik
  /// kelimeleri silinmez; silindiyse `true` döner.
  Future<bool> delete(int wordId) => _db.transaction(() async {
    final unit = await unitId();
    final word = await (_db.select(
      _db.words,
    )..where((t) => t.id.equals(wordId))).getSingleOrNull();
    if (unit == null || word == null || word.unitId != unit) return false;
    await (_db.delete(
      _db.reviewLogs,
    )..where((t) => t.wordId.equals(wordId))).go();
    await (_db.delete(
      _db.reviewCards,
    )..where((t) => t.wordId.equals(wordId))).go();
    await (_db.delete(
      _db.favorites,
    )..where((t) => t.wordId.equals(wordId))).go();
    await (_db.delete(
      _db.wordNotes,
    )..where((t) => t.wordId.equals(wordId))).go();
    await (_db.delete(
      _db.wordListItems,
    )..where((t) => t.wordId.equals(wordId))).go();
    await (_db.delete(
      _db.examples,
    )..where((t) => t.wordId.equals(wordId))).go();
    await (_db.delete(_db.wordRelations)..where(
          (t) => t.wordId.equals(wordId) | t.relatedWordId.equals(wordId),
        ))
        .go();
    await (_db.delete(_db.words)..where((t) => t.id.equals(wordId))).go();
    return true;
  });

  static String _clip(String s, int max) {
    final t = s.trim();
    return t.length > max ? t.substring(0, max) : t;
  }
}
