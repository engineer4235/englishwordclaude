import 'dart:io';
import 'dart:math';

import 'package:english_word_learning/data/providers.dart';
import 'package:english_word_learning/domain/models/level.dart';
import 'package:english_word_learning/domain/placement/placement_exam.dart';
import 'package:english_word_learning/domain/placement/placement_pool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final pool = PlacementPool.parse(File(placementPoolAsset).readAsStringSync());
  const codes = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  test('her seviyede en az 30 soru vardır (CNT-6)', () {
    expect(pool.levels.keys, codes);
    for (final code in codes) {
      expect(
        pool.wordsOf(code).length,
        greaterThanOrEqualTo(PlacementPool.minPerLevel),
        reason: code,
      );
    }
  });

  test('kelimeler tekrarlanmaz, anlamlar seviye içinde ayırt edilir', () {
    final all = pool.levels.values.expand((w) => w).toList();
    expect(all.map((w) => w.lemma).toSet(), hasLength(all.length));
    expect(all.map((w) => w.id).toSet(), hasLength(all.length));
    expect(all.every((w) => w.id < 0), isTrue);
    for (final code in codes) {
      final words = pool.wordsOf(code);
      expect(
        words.map((w) => w.meaningTr.toLowerCase()).toSet(),
        hasLength(words.length),
        reason: code,
      );
      for (final w in words) {
        expect(w.lemma.trim(), isNotEmpty);
        expect(w.meaningTr.trim(), isNotEmpty);
        expect(['noun', 'verb', 'adj'], contains(w.partOfSpeech));
      }
    }
  });

  test('çeldiriciler aynı seviye ve aynı türdendir (FR-48)', () {
    for (final code in codes) {
      final byPos = <String, int>{};
      for (final w in pool.wordsOf(code)) {
        byPos[w.partOfSpeech] = (byPos[w.partOfSpeech] ?? 0) + 1;
      }
      for (final count in byPos.values) {
        expect(count, greaterThanOrEqualTo(4), reason: code);
      }
    }

    final levels = [
      for (var i = 0; i < codes.length; i++)
        PlacementLevel(
          Level(id: i + 1, code: codes[i], sortOrder: i, title: codes[i]),
          pool.wordsOf(codes[i]),
        ),
    ];
    for (var seed = 0; seed < 20; seed++) {
      final random = Random(seed);
      final exam = PlacementExam(levels, random: random);
      while (true) {
        final q = exam.next();
        if (q == null) break;
        final level = levels[exam.currentIndex].words;
        for (final option in q.options) {
          final word = level.firstWhere((w) => w.meaningTr == option);
          expect(word.partOfSpeech, q.target.partOfSpeech);
        }
        exam.answer(correct: random.nextBool());
      }
    }
  });
}
