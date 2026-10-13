import 'dart:math';

import '../models/word.dart';
import '../srs/card_state.dart';
import 'exercise.dart';

/// Seviye atlama sınavındaki soru sayısı (FR-24).
const levelExamQuestionCount = 40;

/// Cümledeki kelimeyi boşlukla değiştirir. Kelime cümlede yoksa `null`.
String? blankOut(String sentence, String lemma) {
  final pattern = RegExp('\\b${RegExp.escape(lemma)}\\b', caseSensitive: false);
  if (!pattern.hasMatch(sentence)) return null;
  return sentence.replaceFirst(pattern, '_____');
}

/// Kelimelerden alıştırma ve sınav soruları üretir.
class ExerciseGenerator {
  ExerciseGenerator([Random? random]) : _random = random ?? Random();

  final Random _random;

  static const optionCount = 4;
  static const matchingSize = 5;

  /// Yeni kelimenin aynı oturumda kaç kez daha sorulacağı (FR-62).
  static const inSessionRepeats = 2;

  /// Ders alıştırmaları. Tür, kelimenin durumuna göre zorlaşır (FR-50):
  /// yeni kelimede tanıma, ileri aşamada yazma ve boşluk doldurma.
  List<Exercise> lesson(
    List<Word> words,
    Map<int, CardState> states, {
    List<Word> pool = const [],
  }) {
    final all = _merge(words, pool);
    final exercises = <Exercise>[];
    for (final word in words) {
      final types = switch (states[word.id] ?? CardState.newCard) {
        CardState.newCard => const [
          ExerciseType.mcEnTr,
          ExerciseType.listenChoose,
        ],
        CardState.learning => const [
          ExerciseType.mcTrEn,
          ExerciseType.listenChoose,
          ExerciseType.fillBlank,
        ],
        _ => const [ExerciseType.typing, ExerciseType.fillBlank],
      };
      exercises.add(_build(types[_random.nextInt(types.length)], word, all));
    }
    exercises.shuffle(_random);
    if (words.length >= matchingSize) {
      final picked = [...words]..shuffle(_random);
      exercises.add(
        MatchingExercise(words: picked.take(matchingSize).toList()),
      );
    }

    // Yeni kelimeler oturumun ilerleyen bölümlerinde, araya başka sorular
    // girerek iki kez daha sorulur (FR-62).
    final fresh = [
      for (final w in words)
        if ((states[w.id] ?? CardState.newCard) == CardState.newCard) w,
    ];
    const repeatTypes = [ExerciseType.mcTrEn, ExerciseType.fillBlank];
    for (var round = 0; round < inSessionRepeats; round++) {
      final repeats = [
        for (final w in fresh)
          _build(
            repeatTypes[round % repeatTypes.length],
            w,
            all,
            isRepeat: true,
          ),
      ]..shuffle(_random);
      exercises.addAll(repeats);
    }
    return exercises;
  }

  /// Sınav soruları: yalnız seçmeli türler. [count] verilmezse her kelime
  /// bir kez sorulur.
  List<Exercise> exam(
    List<Word> words, {
    int? count,
    List<Word> pool = const [],
  }) {
    if (words.isEmpty) return const [];
    final all = _merge(words, pool);
    const types = [
      ExerciseType.mcEnTr,
      ExerciseType.mcTrEn,
      ExerciseType.listenChoose,
      ExerciseType.fillBlank,
    ];
    final total = count ?? words.length;
    final order = <Word>[];
    while (order.length < total) {
      order.addAll([...words]..shuffle(_random));
    }
    return [
      for (final word in order.take(total))
        _build(types[_random.nextInt(types.length)], word, all),
    ];
  }

  /// "Kelimenin Türkçe anlamını seç" sorusu (seviye tespit sınavı, FR-11).
  ChoiceExercise meaningChoice(Word target, List<Word> pool) =>
      _build(ExerciseType.mcEnTr, target, _merge([target], pool))
          as ChoiceExercise;

  List<Word> _merge(List<Word> words, List<Word> pool) {
    final seen = <int>{};
    return [
      for (final w in [...words, ...pool])
        if (seen.add(w.id)) w,
    ];
  }

  Exercise _build(
    ExerciseType type,
    Word target,
    List<Word> pool, {
    bool isRepeat = false,
  }) {
    switch (type) {
      case ExerciseType.typing:
        return TypingExercise(target: target, isRepeat: isRepeat);
      case ExerciseType.fillBlank:
        for (final example in target.examples) {
          final blanked = blankOut(example.en, target.lemma);
          if (blanked != null) {
            return _choice(
              type,
              target,
              pool,
              prompt: blanked,
              hint: example.tr,
              answerOf: (w) => w.lemma,
              isRepeat: isRepeat,
            );
          }
        }
        return _build(ExerciseType.mcEnTr, target, pool, isRepeat: isRepeat);
      case ExerciseType.mcEnTr:
        return _choice(
          type,
          target,
          pool,
          prompt: target.lemma,
          answerOf: (w) => w.meaningTr,
          isRepeat: isRepeat,
        );
      case ExerciseType.mcTrEn:
        return _choice(
          type,
          target,
          pool,
          prompt: target.meaningTr,
          answerOf: (w) => w.lemma,
          isRepeat: isRepeat,
        );
      case ExerciseType.listenChoose:
        return _choice(
          type,
          target,
          pool,
          prompt: target.lemma,
          answerOf: (w) => w.lemma,
          isRepeat: isRepeat,
        );
      case ExerciseType.matching:
        throw ArgumentError('Eşleştirme tek kelimeyle kurulamaz');
    }
  }

  /// Çeldiriciler önce aynı sözcük türünden seçilir (FR-48). Havuz aynı
  /// seviyenin kelimelerinden oluşur.
  ChoiceExercise _choice(
    ExerciseType type,
    Word target,
    List<Word> pool, {
    required String prompt,
    required String Function(Word) answerOf,
    String? hint,
    bool isRepeat = false,
  }) {
    final correct = answerOf(target);
    final others = pool.where((w) => w.id != target.id).toList()
      ..shuffle(_random);
    final ordered = [
      ...others.where((w) => w.partOfSpeech == target.partOfSpeech),
      ...others.where((w) => w.partOfSpeech != target.partOfSpeech),
    ];
    final distractors = <String>[];
    for (final w in ordered) {
      final text = answerOf(w);
      if (text.toLowerCase() != correct.toLowerCase() &&
          !distractors.contains(text)) {
        distractors.add(text);
      }
      if (distractors.length == optionCount - 1) break;
    }
    final options = [correct, ...distractors]..shuffle(_random);
    return ChoiceExercise(
      type: type,
      target: target,
      prompt: prompt,
      options: options,
      correctIndex: options.indexOf(correct),
      hint: hint,
      isRepeat: isRepeat,
    );
  }
}
