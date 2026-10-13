import 'package:drift/drift.dart';

import '../../domain/models/home_summary.dart';
import '../../domain/srs/card_state.dart';
import '../db/app_database.dart';
import 'review_repository.dart';

/// Cevapları kaydeder; XP, günlük hedef, seri ve seri korumasını günceller
/// (FR-64, FR-65, FR-70, FR-71, FR-72).
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

  /// Biriktirilebilecek en fazla seri koruması (FR-72).
  static const maxStreakFreezes = 2;

  /// Serinin her bu kadar gününde bir seri koruması kazanılır.
  static const freezeEarnEvery = 7;

  static String dayKey(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  static DateTime _yesterday(DateTime d) =>
      DateTime(d.year, d.month, d.day - 1);

  Future<UserProfileRow> profile() async {
    return _db.ensureProfile();
  }

  Future<DailyStatRow?> _day(DateTime d) => (_db.select(
    _db.dailyStats,
  )..where((t) => t.day.equals(dayKey(d)))).getSingleOrNull();

  /// Hedefi tamamlanmış ya da seri korumasıyla kurtarılmış gün.
  static bool _protected(DailyStatRow? r) =>
      (r?.goalMet ?? false) || (r?.frozen ?? false);

  /// Dünden geriye, korunan ilk güne kadar kaçırılan günler. [limit]'ten
  /// fazla gün kaçırılmışsa liste [limit]+1 elemanla döner: seri kurtarılamaz.
  Future<List<DateTime>> _missedDays(DateTime now, int limit) async {
    final missed = <DateTime>[];
    var day = _yesterday(now);
    while (missed.length <= limit) {
      if (_protected(await _day(day))) return missed;
      missed.add(day);
      day = _yesterday(day);
    }
    return missed;
  }

  /// Kaçırılan günleri seri korumasıyla işaretler.
  Future<void> _freeze(List<DateTime> days) async {
    for (final d in days) {
      final updated =
          await (_db.update(_db.dailyStats)
                ..where((t) => t.day.equals(dayKey(d))))
              .write(const DailyStatsCompanion(frozen: Value(true)));
      if (updated == 0) {
        await _db
            .into(_db.dailyStats)
            .insert(
              DailyStatsCompanion.insert(
                day: dayKey(d),
                frozen: const Value(true),
              ),
            );
      }
    }
  }

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
    var freezes = user.streakFreezes;
    if (reachedGoal) {
      final missed = await _missedDays(now, freezes);
      if (missed.isEmpty) {
        streak = user.streak + 1;
      } else if (user.streak > 0 && missed.length <= freezes) {
        // Kaçırılan günler seri korumasıyla kurtarılır (FR-72).
        await _freeze(missed);
        freezes -= missed.length;
        streak = user.streak + 1;
      } else {
        streak = 1;
      }
      if (streak % freezeEarnEvery == 0 && freezes < maxStreakFreezes) {
        freezes++;
      }
    }
    await (_db.update(
      _db.userProfile,
    )..where((t) => t.id.equals(user.id))).write(
      UserProfileCompanion(
        totalXp: Value(user.totalXp + xp),
        streak: Value(streak),
        streakFreezes: Value(freezes),
        longestStreak: Value(
          streak > user.longestStreak ? streak : user.longestStreak,
        ),
      ),
    );
  }

  /// Oturumda geçen süreyi bugünün kaydına ekler (FR-81).
  Future<void> addStudyTime(Duration duration) async {
    if (duration <= Duration.zero) return;
    final now = _clock();
    final today = await _day(now);
    final minutes = (duration.inSeconds + 59) ~/ 60;
    await _db
        .into(_db.dailyStats)
        .insertOnConflictUpdate(
          DailyStatsCompanion.insert(
            day: dayKey(now),
            minutes: Value((today?.minutes ?? 0) + minutes),
          ),
        );
  }

  Future<HomeSummary> summary() async {
    final now = _clock();
    final user = await profile();
    final today = await _day(now);
    final due = await _reviews.countDue();
    final todayNew = today?.newWords ?? 0;
    final remaining = user.dailyTarget - todayNew;
    final overload = due > reviewOverloadThreshold;
    final quota = remaining <= 0
        ? 0
        : overload
        ? remaining ~/ 2
        : remaining;
    // Seri, kaçırılan günler seri korumasıyla kapatılabildiği sürece sürer.
    final streakAlive =
        _protected(today) ||
        (user.streak > 0 &&
            (await _missedDays(now, user.streakFreezes)).length <=
                user.streakFreezes);

    return HomeSummary(
      dueCount: due,
      todayNewWords: todayNew,
      dailyTarget: user.dailyTarget,
      todayXp: today?.xp ?? 0,
      totalXp: user.totalXp,
      streak: streakAlive ? user.streak : 0,
      longestStreak: user.longestStreak,
      streakFreezes: user.streakFreezes,
      goalMet: today?.goalMet ?? false,
      reviewOverload: overload,
      newWordQuota: quota,
    );
  }
}
