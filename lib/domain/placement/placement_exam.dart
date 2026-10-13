import 'dart:math';

import '../exercise/exercise.dart';
import '../exercise/exercise_generator.dart';
import '../models/level.dart';
import '../models/word.dart';

/// Seviye tespit sınavındaki bir seviye ve soru havuzu.
class PlacementLevel {
  const PlacementLevel(this.level, this.words);

  final Level level;
  final List<Word> words;
}

/// Uyarlanabilir seviye tespit sınavı (FR-10, FR-11).
///
/// Doğru cevapta bir üst seviyeye, yanlışta bir alt seviyeye geçilir.
/// En fazla [maxQuestions] soru sorulur; bir seviyede [perLevelCap] soruya
/// ulaşılınca sınav biter. Önerilen seviye, en az [minAsked] soruda
/// [passRatio] başarı gösterilen en yüksek seviyenin bir üstüdür.
class PlacementExam {
  PlacementExam(
    List<PlacementLevel> levels, {
    ExerciseGenerator? generator,
    Random? random,
  }) : levels = [
         for (final l in levels)
           if (l.words.isNotEmpty) l,
       ],
       _generator = generator ?? ExerciseGenerator(random),
       _random = random ?? Random() {
    _asked = List.filled(this.levels.length, 0);
    _correct = List.filled(this.levels.length, 0);
    _finished = this.levels.isEmpty;
  }

  static const maxQuestions = 30;
  static const perLevelCap = 6;
  static const minAsked = 3;
  static const passRatio = 0.75;

  /// Kelimesi olan seviyeler, kolaydan zora.
  final List<PlacementLevel> levels;
  final ExerciseGenerator _generator;
  final Random _random;

  late final List<int> _asked;
  late final List<int> _correct;
  final _used = <int>{};
  late bool _finished;
  int _current = 0;
  int _total = 0;
  ChoiceExercise? _pending;

  bool get finished => _finished;

  int get answered => _total;

  /// Şu an sorulan seviyenin sırası ([levels] içinde).
  int get currentIndex => _current;

  /// Sıradaki soru; sınav bittiyse `null`.
  ChoiceExercise? next() {
    if (_finished) return null;
    if (_pending != null) return _pending;
    final level = levels[_current];
    final unused = level.words.where((w) => !_used.contains(w.id)).toList();
    if (unused.isEmpty) {
      _finished = true;
      return null;
    }
    final target = unused[_random.nextInt(unused.length)];
    _used.add(target.id);
    final pool = level.words.length >= ExerciseGenerator.optionCount
        ? level.words
        : [for (final l in levels) ...l.words];
    return _pending = _generator.meaningChoice(target, pool);
  }

  /// Son sorunun cevabını kaydeder ve sıradaki seviyeyi seçer.
  void answer({required bool correct}) {
    if (_pending == null) {
      throw StateError('Cevaplanacak soru yok');
    }
    _pending = null;
    _asked[_current]++;
    if (correct) _correct[_current]++;
    _total++;

    _current = correct
        ? min(_current + 1, levels.length - 1)
        : max(_current - 1, 0);

    final hasWords = levels[_current].words.any((w) => !_used.contains(w.id));
    if (_total >= maxQuestions ||
        _asked[_current] >= perLevelCap ||
        !hasWords) {
      _finished = true;
    }
  }

  bool _passed(int i) =>
      _asked[i] >= minAsked && _correct[i] / _asked[i] >= passRatio;

  /// Önerilen başlangıç seviyesinin sırası (FR-12).
  int get recommendedIndex {
    for (var i = levels.length - 1; i >= 0; i--) {
      if (_passed(i)) return min(i + 1, levels.length - 1);
    }
    return 0;
  }

  Level? get recommended =>
      levels.isEmpty ? null : levels[recommendedIndex].level;
}
