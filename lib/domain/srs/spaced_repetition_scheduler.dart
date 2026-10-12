import 'dart:math' as math;

import 'card_state.dart';
import 'review_state.dart';

/// Tekrar zamanlaması arayüzü (FR-60). İleride FSRS bu arayüzü uygulayabilir.
abstract interface class SpacedRepetitionScheduler {
  /// [quality] 0–5 arası cevap kalitesidir (FR-61).
  ReviewState schedule(ReviewState current, int quality, DateTime now);
}

/// SM-2 algoritması (SRS 5.4).
class Sm2Scheduler implements SpacedRepetitionScheduler {
  const Sm2Scheduler({this.masteredIntervalDays = 21});

  /// Bu aralığa ulaşan kart "Öğrenildi" sayılır (FR-63).
  final int masteredIntervalDays;

  static const double minEaseFactor = 1.3;

  @override
  ReviewState schedule(ReviewState current, int quality, DateTime now) {
    if (quality < 0 || quality > 5) {
      throw ArgumentError.value(quality, 'quality', '0 ile 5 arasında olmalı');
    }
    final miss = 5 - quality;
    final ease = math.max(
      minEaseFactor,
      current.easeFactor + 0.1 - miss * (0.08 + miss * 0.02),
    );

    if (quality < 3) {
      return ReviewState(
        state: CardState.learning,
        easeFactor: ease,
        intervalDays: 1,
        repetitions: 0,
        lapses: current.lapses + 1,
        dueAt: now.add(const Duration(days: 1)),
      );
    }

    final interval = switch (current.repetitions) {
      0 => 1,
      1 => 6,
      _ => (current.intervalDays * current.easeFactor).round(),
    };
    final repetitions = current.repetitions + 1;
    final CardState state;
    if (interval >= masteredIntervalDays) {
      state = CardState.mastered;
    } else if (repetitions == 1) {
      state = CardState.learning;
    } else {
      state = CardState.review;
    }

    return ReviewState(
      state: state,
      easeFactor: ease,
      intervalDays: interval,
      repetitions: repetitions,
      lapses: current.lapses,
      dueAt: now.add(Duration(days: interval)),
    );
  }
}
