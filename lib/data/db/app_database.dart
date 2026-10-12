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
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Testlerde bellek içi bir [executor] verilebilir.
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'english_word_learning'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
