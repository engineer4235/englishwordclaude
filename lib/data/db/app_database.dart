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
    WordNotes,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Testlerde bellek içi bir [executor] verilebilir.
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'english_word_learning'));

  @override
  int get schemaVersion => 5;

  /// Tek satırlık kullanıcı profilini döner, yoksa oluşturur. Kimlik her
  /// zaman 1 olduğundan eş zamanlı çağrılar ikinci satır oluşturmaz.
  Future<UserProfileRow> ensureProfile() async {
    await into(userProfile).insert(
      const UserProfileCompanion(id: Value(1)),
      mode: InsertMode.insertOrIgnore,
    );
    return (select(userProfile)..where((t) => t.id.equals(1))).getSingle();
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(favorites);
      }
      if (from < 3) {
        for (final column in [
          userProfile.onboardingDone,
          userProfile.themeMode,
          userProfile.speechRate,
          userProfile.soundEffects,
          userProfile.haptics,
          userProfile.reminderEnabled,
          userProfile.streakWarningEnabled,
        ]) {
          await m.addColumn(userProfile, column);
        }
      }
      if (from < 4) {
        for (final column in [
          userProfile.quietHoursEnabled,
          userProfile.quietStart,
          userProfile.quietEnd,
        ]) {
          await m.addColumn(userProfile, column);
        }
      }
      if (from < 5) {
        await m.createTable(wordNotes);
        await m.addColumn(userProfile, userProfile.streakFreezes);
        await m.addColumn(dailyStats, dailyStats.frozen);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
