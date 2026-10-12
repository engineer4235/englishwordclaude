import 'package:drift/drift.dart';

import '../db/app_database.dart';

/// Favori kelimeler (FR-35).
class FavoritesRepository {
  FavoritesRepository(this._db);

  final AppDatabase _db;

  Future<Set<int>> ids() async => {
    for (final r in await _db.select(_db.favorites).get()) r.wordId,
  };

  /// Favori durumunu tersine çevirir. Yeni durum favori ise `true` döner.
  Future<bool> toggle(int wordId) async {
    final deleted = await (_db.delete(
      _db.favorites,
    )..where((t) => t.wordId.equals(wordId))).go();
    if (deleted > 0) return false;
    await _db
        .into(_db.favorites)
        .insert(FavoritesCompanion.insert(wordId: Value(wordId)));
    return true;
  }
}
