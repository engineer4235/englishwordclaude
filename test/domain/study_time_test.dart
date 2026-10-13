import 'package:english_word_learning/domain/daily/study_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('oturum sürerken yalnız tam dakikalar kaydedilir (NFR-05)', () {
    final s = splitStudyTime(
      const Duration(minutes: 2, seconds: 15),
      finished: false,
    );
    expect(s.save, const Duration(minutes: 2));
    expect(s.keep, const Duration(seconds: 15));

    final short = splitStudyTime(const Duration(seconds: 40), finished: false);
    expect(short.save, Duration.zero);
    expect(short.keep, const Duration(seconds: 40));
  });

  test('oturum bitince kalanın tamamı kaydedilir', () {
    final s = splitStudyTime(const Duration(seconds: 40), finished: true);
    expect(s.save, const Duration(seconds: 40));
    expect(s.keep, Duration.zero);
  });

  test('parça parça kayıt toplamı tek seferde kayıtla aynı dakikayı verir', () {
    int minutes(Duration d) => (d.inSeconds + 59) ~/ 60;
    const answers = [
      Duration(seconds: 25),
      Duration(seconds: 50),
      Duration(seconds: 40),
      Duration(seconds: 70),
    ];
    var unsaved = Duration.zero;
    var saved = 0;
    for (final a in answers) {
      unsaved += a;
      final s = splitStudyTime(unsaved, finished: false);
      if (s.save > Duration.zero) saved += minutes(s.save);
      unsaved = s.keep;
    }
    final last = splitStudyTime(unsaved, finished: true);
    if (last.save > Duration.zero) saved += minutes(last.save);
    final total = answers.fold(Duration.zero, (a, b) => a + b);
    expect(saved, minutes(total));
  });

  test('sıfır ya da negatif süre kaydedilmez', () {
    final s = splitStudyTime(Duration.zero, finished: true);
    expect(s.save, Duration.zero);
    expect(s.keep, Duration.zero);
  });
}
