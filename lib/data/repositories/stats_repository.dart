import 'package:drift/drift.dart';

import '../../domain/models/stats.dart';
import '../../domain/srs/card_state.dart';
import '../db/app_database.dart';
import 'study_repository.dart';

/// İstatistikler (FR-80, FR-81).
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
      for (var i = 29; i >= 0; i--) DateTime(now.year, now.month, now.day - i),
    ];
    final first = StudyRepository.dayKey(days.first);
    final rows = {
      for (final r in await (_db.select(
        _db.dailyStats,
      )..where((t) => t.day.isBiggerOrEqualValue(first))).get())
        r.day: r,
    };

    return LearningStats(
      byState: byState,
      last30Days: [
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
      ],
    );
  }
}
