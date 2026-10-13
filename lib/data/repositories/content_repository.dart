import 'package:drift/drift.dart';

import '../../domain/models/learning_unit.dart';
import '../../domain/models/level.dart';
import '../../domain/models/word.dart';
import '../db/app_database.dart';

/// Seviye, ünite ve kelime içeriğine erişim.
abstract interface class ContentRepository {
  Future<List<Level>> getLevels();

  Future<List<LearningUnit>> getUnits(int levelId);

  Future<List<Word>> getWords(int unitId);

  Future<List<Word>> getWordsByIds(List<int> ids);

  /// Tüm kelimeler (arama için, FR-90).
  Future<List<Word>> getAllWords();
}

class DriftContentRepository implements ContentRepository {
  DriftContentRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Level>> getLevels() async {
    final query = _db.select(_db.levels)
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    final rows = await query.get();
    return [
      for (final r in rows)
        Level(id: r.id, code: r.code, sortOrder: r.sortOrder, title: r.title),
    ];
  }

  @override
  Future<List<LearningUnit>> getUnits(int levelId) async {
    final query = _db.select(_db.units)
      ..where((t) => t.levelId.equals(levelId))
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    final rows = await query.get();
    return [
      for (final r in rows)
        LearningUnit(
          id: r.id,
          levelId: r.levelId,
          sortOrder: r.sortOrder,
          title: r.titleTr,
          theme: r.theme,
        ),
    ];
  }

  @override
  Future<List<Word>> getWords(int unitId) => _words(
    _db.select(_db.words)
      ..where((t) => t.unitId.equals(unitId))
      ..orderBy([(t) => OrderingTerm.asc(t.id)]),
  );

  @override
  Future<List<Word>> getWordsByIds(List<int> ids) async {
    final words = await _words(
      _db.select(_db.words)..where((t) => t.id.isIn(ids)),
    );
    final order = {for (var i = 0; i < ids.length; i++) ids[i]: i};
    return words..sort((a, b) => order[a.id]!.compareTo(order[b.id]!));
  }

  @override
  Future<List<Word>> getAllWords() =>
      _words(_db.select(_db.words)..orderBy([(t) => OrderingTerm.asc(t.id)]));

  Future<List<Word>> _words(
    SimpleSelectStatement<$WordsTable, WordRow> query,
  ) async {
    final rows = await query.get();
    final ids = [for (final r in rows) r.id];
    final exampleRows =
        await (_db.select(_db.examples)
              ..where((t) => t.wordId.isIn(ids))
              ..orderBy([(t) => OrderingTerm.asc(t.id)]))
            .get();
    final examples = <int, List<Example>>{};
    for (final e in exampleRows) {
      examples
          .putIfAbsent(e.wordId, () => [])
          .add(Example(en: e.sentenceEn, tr: e.sentenceTr));
    }
    return [
      for (final r in rows)
        Word(
          id: r.id,
          unitId: r.unitId,
          lemma: r.lemma,
          partOfSpeech: r.pos,
          meaningTr: r.meaningTr,
          ipa: r.ipa,
          examples: examples[r.id] ?? const [],
        ),
    ];
  }
}
