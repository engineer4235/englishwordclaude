import 'dart:math' as math;

import 'package:drift/drift.dart';

import '../../domain/models/stats.dart';
import '../../domain/srs/card_state.dart';
import '../db/app_database.dart';
import 'study_repository.dart';

/// İstatistikler (FR-80, FR-81, FR-83, FR-85).
class StatsRepository {
  StatsRepository(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  Future<LearningStats> stats() async {
    final byState = {for (final s in CardState.values) s: 0};
    for (final card in await _db.select(_db.reviewCards).get()) {
      final state = CardState.fromDb(card.state);
      byState[state] = byState[state]! + 1;
    }

    final now = _clock();
    final days = [
      for (var i = LearningStats.historyDays - 1; i >= 0; i--)
        DateTime(now.year, now.month, now.day - i),
    ];
    final first = StudyRepository.dayKey(days.first);
    final rows = {
      for (final r in await (_db.select(
        _db.dailyStats,
      )..where((t) => t.day.isBiggerOrEqualValue(first))).get())
        r.day: r,
    };

    final accuracy = <String, AccuracyStat>{};
    final logs =
        await (_db.select(_db.reviewLogs)..where(
              (t) => t.createdAt.isBiggerOrEqualValue(days[days.length - 30]),
            ))
            .get();
    for (final log in logs) {
      accuracy[log.exerciseType] =
          (accuracy[log.exerciseType] ?? const AccuracyStat()).add(
            isCorrect: log.quality >= 3,
          );
    }

    final today = days.last;
    final upcoming = List.filled(7, 0);
    final dueCards =
        await (_db.select(_db.reviewCards)..where(
              (t) => t.dueAt.isSmallerThanValue(
                DateTime(today.year, today.month, today.day + 7),
              ),
            ))
            .get();
    for (final card in dueCards) {
      final due = card.dueAt;
      if (due == null) continue;
      final index = math.max(
        0,
        DateTime.utc(
          due.year,
          due.month,
          due.day,
        ).difference(DateTime.utc(today.year, today.month, today.day)).inDays,
      );
      if (index < 7) upcoming[index]++;
    }

    final history = [
      for (final day in days)
        if (rows[StudyRepository.dayKey(day)] case final r?)
          DayActivity(
            day: day,
            newWords: r.newWords,
            reviews: r.reviews,
            minutes: r.minutes,
          )
        else
          DayActivity(day: day),
    ];

    return LearningStats(
      byState: byState,
      accuracyByType: accuracy,
      upcoming: upcoming,
      history: history,
    );
  }
}
