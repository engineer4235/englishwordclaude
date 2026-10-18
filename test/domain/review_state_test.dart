import 'package:english_word_learning/domain/srs/card_state.dart';
import 'package:english_word_learning/domain/srs/review_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 10, 18, 12);

  group('ReviewState.isDue', () {
    test('hiç planlanmamış kart hemen tekrar edilir', () {
      expect(ReviewState.initial.isDue(now), isTrue);
    });

    test('vakti gelen ya da geçen kart tekrar edilir', () {
      expect(ReviewState(dueAt: now).isDue(now), isTrue);
      expect(
        ReviewState(dueAt: now.subtract(const Duration(days: 1))).isDue(now),
        isTrue,
      );
    });

    test('vakti gelmeyen kart beklenir', () {
      expect(
        ReviewState(dueAt: now.add(const Duration(minutes: 1))).isDue(now),
        isFalse,
      );
    });
  });

  test('başlangıç durumu SM-2 varsayılanlarıdır', () {
    const s = ReviewState.initial;
    expect(s.state, CardState.newCard);
    expect(s.easeFactor, 2.5);
    expect(s.intervalDays, 0);
    expect(s.repetitions, 0);
    expect(s.lapses, 0);
    expect(s.dueAt, isNull);
  });

  test('toString hata ayıklama için alanları içerir', () {
    final text = ReviewState(
      state: CardState.review,
      easeFactor: 2.36,
      intervalDays: 6,
      repetitions: 2,
      lapses: 1,
      dueAt: now,
    ).toString();
    expect(text, contains('review'));
    expect(text, contains('ef: 2.36'));
    expect(text, contains('interval: 6'));
    expect(text, contains('lapses: 1'));
  });

  group('CardState veritabanı değeri', () {
    test('her durum kendi değerine gidip geri gelir', () {
      for (final state in CardState.values) {
        expect(CardState.fromDb(state.dbValue), state);
      }
    });

    test('bilinmeyen değer yeni kart sayılır', () {
      expect(CardState.fromDb('???'), CardState.newCard);
    });
  });
}
