import 'package:english_word_learning/domain/srs/card_state.dart';
import 'package:english_word_learning/domain/srs/difficulty.dart';
import 'package:english_word_learning/domain/srs/review_state.dart';
import 'package:english_word_learning/domain/srs/spaced_repetition_scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 10, 13);
  const sm2 = Sm2Scheduler();

  test('yeni ve sorunsuz kartlar zor sayılmaz (FR-66)', () {
    expect(isDifficult(ReviewState.initial), isFalse);
    final good = sm2.schedule(ReviewState.initial, 5, now);
    expect(isDifficult(good), isFalse);
  });

  test('yanlış cevap kolaylığı düşürür ve kartı zor yapar', () {
    final missed = sm2.schedule(ReviewState.initial, 1, now);
    expect(missed.easeFactor, lessThan(2.0));
    expect(isDifficult(missed), isTrue);
  });

  test('iki kez unutulan kart zordur, ustalaşılan kart değildir', () {
    const lapsed = ReviewState(state: CardState.review, lapses: 2);
    expect(isDifficult(lapsed), isTrue);
    const mastered = ReviewState(
      state: CardState.mastered,
      lapses: 3,
      easeFactor: 1.3,
    );
    expect(isDifficult(mastered), isFalse);
  });
}
