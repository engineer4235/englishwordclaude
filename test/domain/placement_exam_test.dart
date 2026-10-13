import 'dart:math';

import 'package:english_word_learning/domain/models/level.dart';
import 'package:english_word_learning/domain/models/word.dart';
import 'package:english_word_learning/domain/placement/placement_exam.dart';
import 'package:flutter_test/flutter_test.dart';

List<PlacementLevel> _levels(List<int> wordCounts) {
  var id = 0;
  return [
    for (var i = 0; i < wordCounts.length; i++)
      PlacementLevel(
        Level(id: i + 1, code: 'L$i', sortOrder: i, title: 'Seviye $i'),
        [
          for (var w = 0; w < wordCounts[i]; w++)
            Word(
              id: ++id,
              unitId: i + 1,
              lemma: 'word$id',
              partOfSpeech: 'noun',
              meaningTr: 'anlam$id',
            ),
        ],
      ),
  ];
}

/// Seviyesi [known] ve altındaki soruları bilen öğrenci.
int _run(PlacementExam exam, int known) {
  final byWord = <int, int>{
    for (var i = 0; i < exam.levels.length; i++)
      for (final w in exam.levels[i].words) w.id: i,
  };
  while (true) {
    final q = exam.next();
    if (q == null) break;
    exam.answer(correct: byWord[q.target.id]! <= known);
  }
  return exam.recommendedIndex;
}

void main() {
  test('sorular Türkçe anlam seçme türündedir (FR-11)', () {
    final exam = PlacementExam(_levels([10, 10]), random: Random(1));
    final q = exam.next()!;
    expect(q.prompt, q.target.lemma);
    expect(q.correctAnswer, q.target.meaningTr);
    expect(q.options, hasLength(4));
    expect(exam.next(), same(q), reason: 'cevaplanmadan soru değişmez');
  });

  test('doğruda zorlaşır, yanlışta kolaylaşır (FR-10)', () {
    final exam = PlacementExam(_levels([10, 10, 10]), random: Random(2));
    exam.next();
    exam.answer(correct: true);
    expect(exam.currentIndex, 1);
    exam.next();
    exam.answer(correct: true);
    expect(exam.currentIndex, 2);
    exam.next();
    exam.answer(correct: false);
    expect(exam.currentIndex, 1);
  });

  test('en fazla 30 soru sorulur ve sınav biter', () {
    final exam = PlacementExam(
      _levels([40, 40, 40, 40, 40, 40]),
      random: Random(3),
    );
    _run(exam, 2);
    expect(exam.finished, isTrue);
    expect(exam.answered, lessThanOrEqualTo(PlacementExam.maxQuestions));
  });

  test('bilgi seviyesine göre seviye önerir (FR-12)', () {
    for (final known in [-1, 0, 2, 5]) {
      final exam = PlacementExam(
        _levels([40, 40, 40, 40, 40, 40]),
        random: Random(known + 10),
      );
      final expected = known < 0 ? 0 : min(known + 1, 5);
      expect(_run(exam, known), expected, reason: 'bilinen: $known');
    }
  });

  test('kelimesi olmayan seviyeler atlanır', () {
    final exam = PlacementExam(_levels([8, 0, 0]), random: Random(4));
    expect(exam.levels, hasLength(1));
    _run(exam, 5);
    expect(exam.finished, isTrue);
    expect(exam.recommended!.code, 'L0');
  });

  test('hiç kelime yoksa sınav baştan biter', () {
    final exam = PlacementExam(_levels([0, 0]));
    expect(exam.finished, isTrue);
    expect(exam.next(), isNull);
    expect(exam.recommended, isNull);
  });
}
