import 'dart:math';

import 'package:english_word_learning/domain/exercise/exercise.dart';
import 'package:english_word_learning/domain/exercise/exercise_generator.dart';
import 'package:english_word_learning/domain/models/word.dart';
import 'package:english_word_learning/domain/srs/card_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  final all = seedWords();
  final family = seedWords(unitTitle: 'Aile');
  final mother = family.firstWhere((w) => w.lemma == 'mother');

  test('boşluk doldurma kelime sınırına bakar', () {
    expect(blankOut('Wait one minute.', 'one'), 'Wait _____ minute.');
    expect(blankOut('Someone is here.', 'one'), isNull);
    expect(blankOut('My Mother is here.', 'mother'), 'My _____ is here.');
  });

  test('seçmeli soruda 4 farklı seçenek ve doğru cevap var', () {
    final generator = ExerciseGenerator(Random(1));
    for (final ex in generator.exam(family, pool: all).cast<ChoiceExercise>()) {
      expect(ex.options, hasLength(4));
      expect(ex.options.toSet(), hasLength(4));
      expect(ex.options[ex.correctIndex], ex.correctAnswer);
    }
  });

  test('çeldiriciler aynı sözcük türünden seçilir (FR-48)', () {
    final generator = ExerciseGenerator(Random(2));
    final nounMeanings = {
      for (final w in all.where((w) => w.partOfSpeech == 'noun')) w.meaningTr,
    };
    for (var i = 0; i < 20; i++) {
      final ex = generator
          .exam([mother], pool: all)
          .cast<ChoiceExercise>()
          .single;
      if (ex.type != ExerciseType.mcEnTr) continue;
      expect(nounMeanings.containsAll(ex.options), isTrue);
    }
  });

  test('boşluk doldurmada cümlede boşluk ve ipucu var', () {
    final generator = ExerciseGenerator(Random(3));
    final fills =
        [for (var i = 0; i < 30; i++) ...generator.exam(family, pool: all)]
            .whereType<ChoiceExercise>()
            .where((e) => e.type == ExerciseType.fillBlank);
    expect(fills, isNotEmpty);
    for (final ex in fills) {
      expect(ex.prompt, contains('_____'));
      expect(ex.correctAnswer, ex.target.lemma);
      expect(ex.hint, isNotNull);
    }
  });

  test('alıştırma türü kelime durumuna göre zorlaşır (FR-50)', () {
    final generator = ExerciseGenerator(Random(4));
    final newOnes = generator.lesson(family, const {}, pool: all);
    expect(newOnes.whereType<MatchingExercise>().single.words, hasLength(5));
    expect(
      newOnes
          .where((e) => e is! MatchingExercise && !e.isRepeat)
          .map((e) => e.type)
          .toSet(),
      everyElement(isIn([ExerciseType.mcEnTr, ExerciseType.listenChoose])),
    );

    final reviewed = generator.lesson(family, {
      for (final w in family) w.id: CardState.review,
    }, pool: all);
    expect(
      reviewed.where((e) => e is! MatchingExercise).map((e) => e.type).toSet(),
      everyElement(isIn([ExerciseType.typing, ExerciseType.fillBlank])),
    );
  });

  test('öğrenme aşamasında harf karıştırma sorulur (FR-47)', () {
    final generator = ExerciseGenerator(Random(11));
    final learning = {for (final w in family) w.id: CardState.learning};
    final scrambles = [
      for (var i = 0; i < 20; i++)
        ...generator.lesson(family, learning, pool: all),
    ].whereType<ScrambleExercise>().toList();
    expect(scrambles, isNotEmpty);
    for (final ex in scrambles) {
      expect(ex.letters.join(), isNot(ex.target.lemma.toLowerCase()));
      expect(
        [...ex.letters]..sort(),
        ex.target.lemma.toLowerCase().split('')..sort(),
      );
    }
  });

  test('seviye sınavı 40 seçmeli sorudur', () {
    final exam = ExerciseGenerator(Random(5))
        .exam(all, count: levelExamQuestionCount, pool: all);
    expect(exam, hasLength(40));
    expect(exam, everyElement(isA<ChoiceExercise>()));
  });

  test('yeni kelimeler oturum içinde iki kez daha sorulur (FR-62)', () {
    final generator = ExerciseGenerator(Random(9));
    final family = all.take(8).toList();
    final lesson = generator.lesson(family, const {}, pool: all);
    final repeats = lesson.where((e) => e.isRepeat).toList();
    expect(repeats, hasLength(family.length * 2));

    Word target(Exercise e) => switch (e) {
      ChoiceExercise() => e.target,
      TypingExercise() => e.target,
      ScrambleExercise() => e.target,
      MatchingExercise() => throw StateError('eşleştirme'),
    };
    for (final word in family) {
      final positions = [
        for (var i = 0; i < lesson.length; i++)
          if (lesson[i] is! MatchingExercise && target(lesson[i]).id == word.id)
            i,
      ];
      expect(positions, hasLength(3), reason: word.lemma);
      expect(lesson[positions.first].isRepeat, isFalse);
      expect(positions[1] - positions[0], greaterThan(1));
    }

    final reviewed = generator.lesson(family, {
      for (final w in family) w.id: CardState.review,
    }, pool: all);
    expect(reviewed.where((e) => e.isRepeat), isEmpty);
  });

  group('pickLessonWords', () {
    final words = [
      for (var i = 1; i <= 20; i++)
        Word(
          id: i,
          unitId: 1,
          lemma: 'w$i',
          partOfSpeech: 'noun',
          meaningTr: 'k$i',
        ),
    ];

    test('ilk derste sıradaki 8 yeni kelime gelir', () {
      final picked = pickLessonWords(words, const {});
      expect(picked.map((w) => w.id), [1, 2, 3, 4, 5, 6, 7, 8]);
    });

    test('sonraki derste yeni kelimeler ve pekiştirme birlikte', () {
      final states = {for (var i = 1; i <= 8; i++) i: CardState.learning};
      final picked = pickLessonWords(words, states, Random(1));
      expect(picked.take(8).map((w) => w.id), [9, 10, 11, 12, 13, 14, 15, 16]);
      expect(picked, hasLength(wordsPerLesson));
      expect(picked.skip(8).every((w) => w.id <= 8), isTrue);
    });

    test('bütün kelimeler görüldüyse ünite tekrar edilir', () {
      final states = {for (final w in words) w.id: CardState.review};
      final picked = pickLessonWords(words, states, Random(2));
      expect(picked, hasLength(wordsPerLesson));
      expect(picked.toSet(), hasLength(wordsPerLesson));
    });

    test('ders uzunluğu makul kalır', () {
      final lesson = ExerciseGenerator(Random(3))
          .lesson(pickLessonWords(words, const {}), const {}, pool: words);
      expect(lesson.length, lessThanOrEqualTo(30));
    });
  });
}
