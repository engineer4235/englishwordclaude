import 'package:drift/drift.dart';

import '../db/app_database.dart';

/// Kelimelere eklenen kişisel notlar (FR-36).
class NotesRepository {
  NotesRepository(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  /// Bir notun en fazla uzunluğu.
  static const maxLength = 300;

  Future<String?> get(int wordId) async => (await (_db.select(
    _db.wordNotes,
  )..where((t) => t.wordId.equals(wordId))).getSingleOrNull())?.note;

  /// Notu kaydeder. Boş not, mevcut notu siler.
  Future<void> save(int wordId, String note) async {
    final text = note.trim();
    if (text.isEmpty) {
      await (_db.delete(
        _db.wordNotes,
      )..where((t) => t.wordId.equals(wordId))).go();
      return;
    }
    await _db
        .into(_db.wordNotes)
        .insertOnConflictUpdate(
          WordNotesCompanion.insert(
            wordId: Value(wordId),
            note: text.length > maxLength ? text.substring(0, maxLength) : text,
            updatedAt: Value(_clock()),
          ),
        );
  }
}
