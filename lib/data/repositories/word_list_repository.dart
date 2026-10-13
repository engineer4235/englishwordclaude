import 'package:drift/drift.dart';

import '../../domain/models/word_list.dart';
import '../db/app_database.dart';

/// Kişisel kelime listeleri (FR-91).
class WordListRepository {
  WordListRepository(this._db);

  final AppDatabase _db;

  /// Liste adının en fazla uzunluğu.
  static const maxNameLength = 40;

  /// Listeler, kelime sayılarıyla, oluşturulma sırasına göre.
  Future<List<WordList>> lists() async {
    final count = _db.wordListItems.wordId.count();
    final query =
        _db.select(_db.wordLists).join([
            leftOuterJoin(
              _db.wordListItems,
              _db.wordListItems.listId.equalsExp(_db.wordLists.id),
            ),
          ])
          ..addColumns([count])
          ..groupBy([_db.wordLists.id])
          ..orderBy([OrderingTerm.asc(_db.wordLists.createdAt)]);
    return [
      for (final row in await query.get())
        WordList(
          id: row.readTable(_db.wordLists).id,
          name: row.readTable(_db.wordLists).name,
          wordCount: row.read(count) ?? 0,
        ),
    ];
  }

  /// Yeni liste oluşturur ve kimliğini döner. Boş ad kabul edilmez.
  Future<int> create(String name) {
    var text = name.trim();
    if (text.isEmpty) throw ArgumentError.value(name, 'name', 'boş olamaz');
    if (text.length > maxNameLength) text = text.substring(0, maxNameLength);
    return _db
        .into(_db.wordLists)
        .insert(WordListsCompanion.insert(name: text));
  }

  Future<void> rename(int listId, String name) async {
    final text = name.trim();
    if (text.isEmpty) return;
    await (_db.update(_db.wordLists)..where((t) => t.id.equals(listId))).write(
      WordListsCompanion(
        name: Value(
          text.length > maxNameLength ? text.substring(0, maxNameLength) : text,
        ),
      ),
    );
  }

  /// Listeyi ve içindeki kayıtları siler; kelimeler etkilenmez.
  Future<void> remove(int listId) => _db.transaction(() async {
    await (_db.delete(
      _db.wordListItems,
    )..where((t) => t.listId.equals(listId))).go();
    await (_db.delete(_db.wordLists)..where((t) => t.id.equals(listId))).go();
  });

  Future<void> addWord(int listId, int wordId) => _db
      .into(_db.wordListItems)
      .insert(
        WordListItemsCompanion.insert(listId: listId, wordId: wordId),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> removeWord(int listId, int wordId) => (_db.delete(
    _db.wordListItems,
  )..where((t) => t.listId.equals(listId) & t.wordId.equals(wordId))).go();

  /// Kelimenin bulunduğu listelerin kimlikleri.
  Future<Set<int>> listsOf(int wordId) async => {
    for (final r in await (_db.select(
      _db.wordListItems,
    )..where((t) => t.wordId.equals(wordId))).get())
      r.listId,
  };

  /// Listedeki kelimeler, eklenme sırasıyla.
  Future<List<int>> wordIds(int listId) async => [
    for (final r
        in await (_db.select(_db.wordListItems)
              ..where((t) => t.listId.equals(listId))
              ..orderBy([
                (t) => OrderingTerm.asc(t.addedAt),
                // Aynı saniyede eklenenler için ekleme sırası.
                (t) => OrderingTerm.asc(const CustomExpression<int>('rowid')),
              ]))
            .get())
      r.wordId,
  ];

  Future<String?> name(int listId) async => (await (_db.select(
    _db.wordLists,
  )..where((t) => t.id.equals(listId))).getSingleOrNull())?.name;
}
