import '../models/word.dart';

/// Alıştırma türleri (FR-40..FR-47).
enum ExerciseType {
  mcEnTr('mc_en_tr'),
  mcTrEn('mc_tr_en'),
  listenChoose('listen'),
  typing('typing'),
  fillBlank('fill_blank'),
  matching('matching');

  const ExerciseType(this.id);

  /// Günlüğe yazılan kimlik.
  final String id;
}

sealed class Exercise {
  const Exercise(this.type);

  final ExerciseType type;
}

/// Dört seçenekli soru: EN→TR, TR→EN, dinle-seç, boşluk doldurma.
class ChoiceExercise extends Exercise {
  const ChoiceExercise({
    required ExerciseType type,
    required this.target,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    this.hint,
  }) : super(type);

  final Word target;

  /// Gösterilen soru metni. Dinle-seç türünde gösterilmez, seslendirilir.
  final String prompt;
  final List<String> options;
  final int correctIndex;

  /// Boşluk doldurmada cümlenin Türkçesi.
  final String? hint;

  String get correctAnswer => options[correctIndex];
}

/// Türkçe anlamı verilen kelimeyi yazma (FR-43).
class TypingExercise extends Exercise {
  const TypingExercise({required this.target}) : super(ExerciseType.typing);

  final Word target;
}

/// Beş kelimeyi anlamlarıyla eşleştirme (FR-45).
class MatchingExercise extends Exercise {
  const MatchingExercise({required this.words}) : super(ExerciseType.matching);

  final List<Word> words;
}

/// Bir kelime için verilen cevap.
class WordAnswer {
  const WordAnswer(
    this.word, {
    required this.correct,
    this.almostCorrect = false,
  });

  final Word word;
  final bool correct;
  final bool almostCorrect;
}

/// Bir alıştırmanın sonucu.
class ExerciseOutcome {
  const ExerciseOutcome(this.answers, this.elapsed);

  final List<WordAnswer> answers;
  final Duration elapsed;

  bool get allCorrect => answers.every((a) => a.correct);
}

/// Oturum sonucu.
class SessionResult {
  const SessionResult({
    required this.correct,
    required this.total,
    required this.wrongWords,
  });

  final int correct;
  final int total;
  final List<Word> wrongWords;

  int get scorePercent => total == 0 ? 0 : (correct * 100 / total).round();
}
