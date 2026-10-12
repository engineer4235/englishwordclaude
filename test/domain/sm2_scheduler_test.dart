import 'package:english_word_learning/domain/srs/card_state.dart';
import 'package:english_word_learning/domain/srs/review_state.dart';
import 'package:english_word_learning/domain/srs/spaced_repetition_scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const scheduler = Sm2Scheduler();
  final now = DateTime(2026, 10, 13, 9);

  test('ilk doğru cevap: 1 gün sonra, durum Öğreniliyor', () {
    final s = scheduler.schedule(ReviewState.initial, 5, now);
    expect(s.intervalDays, 1);
    expect(s.repetitions, 1);
    expect(s.state, CardState.learning);
    expect(s.dueAt, now.add(const Duration(days: 1)));
  });

  test('ikinci doğru cevap: 6 gün sonra, durum Tekrarda', () {
    var s = scheduler.schedule(ReviewState.initial, 5, now);
    s = scheduler.schedule(s, 5, now);
    expect(s.intervalDays, 6);
    expect(s.state, CardState.review);
  });

  test('üçüncü doğru cevapta aralık ease factor ile çarpılır', () {
    var s = scheduler.schedule(ReviewState.initial, 4, now);
    s = scheduler.schedule(s, 4, now);
    final ef = s.easeFactor;
    s = scheduler.schedule(s, 4, now);
    expect(s.intervalDays, (6 * ef).round());
  });

  test('aralık 21 günü geçince durum Öğrenildi olur', () {
    var s = ReviewState.initial;
    for (var i = 0; i < 4; i++) {
      s = scheduler.schedule(s, 5, now);
    }
    expect(s.intervalDays, greaterThanOrEqualTo(21));
    expect(s.state, CardState.mastered);
  });

  test(
    'yanlış cevap: 1 gün sonra, tekrar sayısı sıfırlanır, durum Öğreniliyor',
    () {
      var s = scheduler.schedule(ReviewState.initial, 5, now);
      s = scheduler.schedule(s, 5, now);
      s = scheduler.schedule(s, 1, now);
      expect(s.intervalDays, 1);
      expect(s.repetitions, 0);
      expect(s.lapses, 1);
      expect(s.state, CardState.learning);
      expect(s.dueAt, now.add(const Duration(days: 1)));
    },
  );

  test('ease factor 1.3 altına düşmez', () {
    var s = ReviewState.initial;
    for (var i = 0; i < 10; i++) {
      s = scheduler.schedule(s, 0, now);
    }
    expect(s.easeFactor, 1.3);
  });

  test('kalite 0–5 dışındaysa hata verir', () {
    expect(
      () => scheduler.schedule(ReviewState.initial, 6, now),
      throwsArgumentError,
    );
  });
}
