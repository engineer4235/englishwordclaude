import 'dart:math';

import 'package:english_word_learning/domain/exercise/scramble.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('yalnız 3–12 harfli tek sözcükler karıştırılır (FR-47)', () {
    expect(canScramble('mother'), isTrue);
    expect(canScramble('go'), isFalse);
    expect(canScramble('ice cream'), isFalse);
    expect(canScramble("o'clock"), isFalse);
    expect(canScramble('extraordinarily'), isFalse);
  });

  test('karışık harfler aynı harflerdir ama kelimenin kendisi değildir', () {
    final random = Random(7);
    for (var i = 0; i < 50; i++) {
      final letters = scrambleLetters('Father', random);
      expect(letters.join(), isNot('father'));
      expect([...letters]..sort(), 'father'.split('')..sort());
    }
  });

  test('tek harften oluşan kelime olduğu gibi döner', () {
    expect(scrambleLetters('zzz', Random(1)), ['z', 'z', 'z']);
  });
}
