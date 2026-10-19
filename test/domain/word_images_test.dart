import 'dart:convert';
import 'dart:io';

import 'package:english_word_learning/domain/content/word_images.dart';
import 'package:english_word_learning/domain/models/word.dart';
import 'package:flutter_test/flutter_test.dart';

/// EWL-45 (FR-32): Kelime görselleri.
void main() {
  Word word(String lemma, [String pos = 'noun']) =>
      Word(id: 1, unitId: 1, lemma: lemma, partOfSpeech: pos, meaningTr: '');

  test('somut isimlerin görseli var, diğerlerinin yok', () {
    expect(wordImage(word('dog')), '🐶');
    expect(wordImage(word('Apple')), '🍎', reason: 'büyük harf fark etmez');
    expect(wordImage(word('watch', 'verb')), isNull, reason: 'yalnız isimler');
    expect(wordImage(word('decision')), isNull, reason: 'soyut kelime');
    expect(wordImage(word('T-shirt')), '👕', reason: 'büyük harfli kelime');
  });

  test('görseli olan her kelime içerik paketinde isim olarak var', () {
    final data = jsonDecode(
      File('assets/content/seed_content.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final nouns = {
      for (final unit in data['units'] as List)
        for (final w in unit['words'] as List)
          if (w['pos'] == 'noun') (w['lemma'] as String).toLowerCase(),
    };
    for (final lemma in wordImages.keys) {
      expect(nouns, contains(lemma));
    }
    // Somut kelimelerin kayda değer bir kısmı görselli olmalı.
    expect(wordImages.length, greaterThanOrEqualTo(150));
  });

  test('görseller tek emoji: birleşik (ZWJ) dizi yok', () {
    for (final MapEntry(:key, :value) in wordImages.entries) {
      expect(value.contains('‍'), isFalse, reason: key);
      expect(value.runes.length, lessThanOrEqualTo(2), reason: key);
    }
  });
}
