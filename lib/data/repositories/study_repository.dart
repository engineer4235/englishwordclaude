import 'package:drift/drift.dart';

import '../../domain/models/home_summary.dart';
import '../../domain/srs/card_state.dart';
import '../db/app_database.dart';
import 'review_repository.dart';

/// Cevapları kaydeder; XP, günlük hedef ve seriyi günceller
/// (FR-64, FR-65, FR-70, FR-71).
class StudyRepository {
  StudyRepository(AppDatabase db, {DateTime Function()? clock})
    : _db = db,
      _clock = clock ?? DateTime.now,
      _reviews = ReviewRepository(db, clock: clock);

  final AppDatabase _db;
  final DateTime Function() _clock;
  final ReviewRepository _reviews;

  static const xpReview = 10;
  static const xpNewWord = 15;
  static const xpExam = 20;

  /// Bu sayının üzerinde tekrar birikirse yeni kelime kotası yarıya iner.
  static const reviewOverloadThreshold = 100;

  static String dayKey(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  static DateTime _yesterday(DateTime d) =>
      DateTime(d.year, d.month, d.day - 1);

  Future<UserProfileRow> profile() async {
    final row = await _db.select(_db.userProfile).getSingleOrNull();
    if (row != null) return row;
    await _db.into(_db.userProfile).insert(const UserProfileCompanion());
    return _db.select(_db.userProfile).getSingle();
  }

  Future<DailyStatRow?> _day(DateTime d) => (_db.select(
    _db.dailyStats,
  )..where((t) => t.day.equals(dayKey(d)))).getSingleOrNull();

  /// Cevabı aralıklı tekrara yazar ve kazanılan XP'yi döner.
  Future<int> recordAnswer({
    required int wordId,
    required int quality,
    required bool correct,
    required String exerciseType,
    required int responseMs,
    bool exam = false,
  }) {
    return _db.transaction(() async {
      final before = await _reviews.getState(wordId);
      final isNew = before.state == CardState.newCard;
      await _reviews.recordAnswer(
        wordId: wordId,
        quality: quality,
        exerciseType: exerciseType,
        responseMs: responseMs,
      );
      final xp = !correct
          ? 0
          : exam
          ? xpExam
          : isNew
          ? xpNewWord
          : xpReview;
      await _addToday(isNew: isNew, correct: correct, xp: xp);
      return xp;
    });
  }

  Future<void> _addToday({
    required bool isNew,
    required bool correct,
    required int xp,
  }) async {
    final now = _clock();
    final today = await _day(now);
    final newWords = (today?.newWords ?? 0) + (isNew ? 1 : 0);
    final user = await profile();
    final reachedGoal =
        !(today?.goalMet ?? false) && newWords >= user.dailyTarget;

    await _db
        .into(_db.dailyStats)
        .insertOnConflictUpdate(
          DailyStatsCompanion.insert(
            day: dayKey(now),
            newWords: Value(newWords),
            reviews: Value((today?.reviews ?? 0) + (isNew ? 0 : 1)),
            correct: Value((today?.correct ?? 0) + (correct ? 1 : 0)),
            xp: Value((today?.xp ?? 0) + xp),
            minutes: Value(today?.minutes ?? 0),
            goalMet: Value((today?.goalMet ?? false) || reachedGoal),
          ),
        );

    var streak = user.streak;
    if (reachedGoal) {
      final yesterday = await _day(_yesterday(now));
      streak = (yesterday?.goalMet ?? false) ? user.streak + 1 : 1;
    }
    await (_db.update(
      _db.userProfile,
    )..where((t) => t.id.equals(user.id))).write(
      UserProfileCompanion(
        totalXp: Value(user.totalXp + xp),
        streak: Value(streak),
        longestStreak: Value(
          streak > user.longestStreak ? streak : user.longestStreak,
        ),
      ),
    );
  }

  Future<HomeSummary> summary() async {
    final now = _clock();
    final user = await profile();
    final today = await _day(now);
    final yesterday = await _day(_yesterday(now));
    final due = await _reviews.countDue();
    final todayNew = today?.newWords ?? 0;
    final remaining = user.dailyTarget - todayNew;
    final overload = due > reviewOverloadThreshold;
    final quota = remaining <= 0
        ? 0
        : overload
        ? remaining ~/ 2
        : remaining;
    final streakAlive =
        (today?.goalMet ?? false) || (yesterday?.goalMet ?? false);

    return HomeSummary(
      dueCount: due,
      todayNewWords: todayNew,
      dailyTarget: user.dailyTarget,
      todayXp: today?.xp ?? 0,
      totalXp: user.totalXp,
      streak: streakAlive ? user.streak : 0,
      longestStreak: user.longestStreak,
      goalMet: today?.goalMet ?? false,
      reviewOverload: overload,
      newWordQuota: quota,
    );
  }
}
