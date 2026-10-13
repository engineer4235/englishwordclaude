import 'package:english_word_learning/domain/daily/word_of_day.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  final words = seedWords();

  test('aynı gün aynı kelime, ertesi gün farklı kelime (FR-75)', () {
    final morning = pickWordOfDay(words, DateTime(2026, 10, 13, 8));
    final evening = pickWordOfDay(words, DateTime(2026, 10, 13, 23));
    final tomorrow = pickWordOfDay(words, DateTime(2026, 10, 14, 8));
    expect(morning, isNotNull);
    expect(evening!.id, morning!.id);
    expect(tomorrow!.id, isNot(morning.id));
  });

  test('sıralama girdiye bağlı değildir', () {
    final day = DateTime(2026, 1, 1);
    expect(
      pickWordOfDay(words.reversed.toList(), day)!.id,
      pickWordOfDay(words, day)!.id,
    );
  });

  test('bir hafta boyunca kelimeler tekrarlanmaz', () {
    final ids = {
      for (var i = 0; i < 7; i++)
        pickWordOfDay(words, DateTime(2026, 3, 1 + i))!.id,
    };
    expect(ids, hasLength(7));
  });

  test('aday yoksa null döner', () {
    expect(pickWordOfDay(const [], DateTime(2026)), isNull);
  });
}
