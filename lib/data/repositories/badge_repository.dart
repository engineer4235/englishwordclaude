import 'package:drift/drift.dart';

import '../../domain/models/badge.dart';
import '../db/app_database.dart';

/// Kazanılan rozetler (FR-73).
class BadgeRepository {
  BadgeRepository(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  /// Rozet kodu → kazanılma zamanı.
  Future<Map<String, DateTime>> earned() async => {
    for (final r in await _db.select(_db.badges).get()) r.code: r.earnedAt,
  };

  /// Koşulları yeni sağlanan rozetleri kaydeder ve döner.
  Future<List<String>> check() async {
    final cards = await _db.select(_db.reviewCards).get();
    final learned = cards
        .where((c) => c.state == 'review' || c.state == 'mastered')
        .length;
    final profile = await _db.ensureProfile();
    final completed = await (_db.select(_db.levelProgress).join([
      innerJoin(_db.levels, _db.levels.id.equalsExp(_db.levelProgress.levelId)),
    ])..where(_db.levelProgress.status.equals('completed'))).get();

    final qualifying = qualifyingBadges(
      studiedWords: cards.length,
      learnedWords: learned,
      longestStreak: profile.longestStreak,
      completedLevels: {
        for (final row in completed) row.readTable(_db.levels).code,
      },
    );
    final have = await earned();
    final fresh = [
      for (final code in qualifying)
        if (!have.containsKey(code)) code,
    ];
    for (final code in fresh) {
      await _db
          .into(_db.badges)
          .insert(
            BadgesCompanion.insert(code: code, earnedAt: Value(_clock())),
            mode: InsertMode.insertOrIgnore,
          );
    }
    return fresh;
  }
}
