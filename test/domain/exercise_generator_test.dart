import 'dart:math';

import 'package:english_word_learning/domain/exercise/exercise.dart';
import 'package:english_word_learning/domain/exercise/exercise_generator.dart';
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
      newOnes.where((e) => e is! MatchingExercise).map((e) => e.type).toSet(),
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

  test('seviye sınavı 40 seçmeli sorudur', () {
    final exam = ExerciseGenerator(Random(5))
        .exam(all, count: levelExamQuestionCount, pool: all);
    expect(exam, hasLength(40));
    expect(exam, everyElement(isA<ChoiceExercise>()));
  });
}
