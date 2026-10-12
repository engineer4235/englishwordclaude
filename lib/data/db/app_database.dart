import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// Uygulamanın yerel SQLite veritabanı (EWL-21).
@DriftDatabase(
  tables: [
    Levels,
    Units,
    Words,
    Examples,
    WordRelations,
    ReviewCards,
    ReviewLogs,
    UnitProgress,
    LevelProgress,
    DailyStats,
    UserProfile,
    Badges,
    Favorites,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Testlerde bellek içi bir [executor] verilebilir.
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'english_word_learning'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(favorites);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
