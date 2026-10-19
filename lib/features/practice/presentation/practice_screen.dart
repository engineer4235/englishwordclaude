import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/feedback/answer_feedback.dart';
import '../../../core/tts/tts_service.dart';
import '../../../data/providers.dart';
import '../../../domain/daily/study_time.dart';
import '../../../domain/exercise/exercise.dart';
import '../../../domain/exercise/exercise_generator.dart';
import '../../../domain/models/word.dart';
import '../../../domain/srs/answer_quality.dart';
import '../../../l10n/app_localizations.dart';
import 'exercise_views.dart';
import 'result_view.dart';

enum PracticeMode {
  lesson,
  unitExam,
  levelExam,
  review,

  /// Kilitli üniteye hızlı geçiş sınavı (FR-27).
  quickPass,

  /// Favori kelimelerle alıştırma (FR-93).
  favorites,

  /// Zorlanılan kelimelerle alıştırma (FR-66, FR-93).
  difficult,

  /// Kişisel listeyle alıştırma (FR-93).
  wordList;

  /// Belirli bir kelime kümesiyle yapılan, sınav olmayan oturumlar.
  bool get isWordSet =>
      this == review ||
      this == favorites ||
      this == difficult ||
      this == wordList;
}

/// Bir tekrar oturumundaki en fazla kelime.
const reviewSessionSize = 20;

/// Alıştırma, ünite sınavı ve seviye sınavı oturumu.
class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({
    super.key,
    required this.mode,
    this.unitId,
    this.levelId,
    this.listId,
  });

  final PracticeMode mode;
  final int? unitId;
  final int? levelId;

  /// [PracticeMode.wordList] için liste kimliği.
  final int? listId;

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  List<Exercise>? _exercises;
  Object? _error;
  int _index = 0;
  int _correct = 0;
  final _wrongWords = <Word>[];
  bool _answered = false;
  SessionResult? _result;
  bool? _passed;
  List<String> _newBadges = const [];
  String _title = '';
  String _levelCode = '';
  int _xp = 0;

  /// Henüz veritabanına yazılmamış çalışma süresi (NFR-05).
  Duration _unsavedStudyTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final levels = await ref.read(levelOverviewProvider.future);
      final generator = ref.read(exerciseGeneratorProvider);
      if (widget.mode.isWordSet) {
        if (widget.mode == PracticeMode.wordList) {
          _title =
              await ref.read(wordListRepositoryProvider).name(widget.listId!) ??
              '';
        }
        final ids = (switch (widget.mode) {
          PracticeMode.favorites =>
            (await ref.read(favoritesRepositoryProvider).ids()).toList()
              ..shuffle(),
          PracticeMode.difficult =>
            (await ref.read(reviewRepositoryProvider).difficultWordIds())
                .toList()
              ..shuffle(),
          PracticeMode.wordList =>
            (await ref.read(wordListRepositoryProvider).wordIds(widget.listId!))
              ..shuffle(),
          _ =>
            await ref
                .read(reviewRepositoryProvider)
                .dueWordIds(limit: reviewSessionSize),
        }).take(reviewSessionSize).toList();
        final words = await ref
            .read(contentRepositoryProvider)
            .getWordsByIds(ids);
        final levelOfUnit = {
          for (final l in levels)
            for (final u in l.units) u.id: l.level.id,
        };
        final pool = <Word>[];
        // Kendi eklenen kelimelerin seviyesi yoktur; seçenek havuzu için ilk
        // seviyenin kelimeleri kullanılır.
        for (final levelId in {
          for (final w in words) levelOfUnit[w.unitId] ?? levels.first.level.id,
        }) {
          pool.addAll(await ref.read(levelWordsProvider(levelId).future));
        }
        pool.addAll(words.where((w) => levelOfUnit[w.unitId] == null));
        final exercises = generator.lesson(
          words,
          await ref.read(reviewRepositoryProvider).statesFor(ids),
          pool: pool,
        );
        if (!mounted) return;
        setState(() => _exercises = exercises);
        return;
      }
      final int levelId;
      final List<Word> words;
      if (widget.mode == PracticeMode.levelExam) {
        levelId = widget.levelId!;
        words = await ref.read(levelWordsProvider(levelId).future);
      } else {
        final unit = levels
            .expand((l) => l.units)
            .firstWhere((u) => u.id == widget.unitId);
        levelId = unit.levelId;
        _title = unit.title;
        words = await ref.read(contentRepositoryProvider).getWords(unit.id);
      }
      _levelCode = levels.firstWhere((l) => l.level.id == levelId).level.code;
      final pool = await ref.read(levelWordsProvider(levelId).future);
      final exercises = switch (widget.mode) {
        PracticeMode.lesson => await () async {
          final states = await ref.read(reviewRepositoryProvider).statesFor([
            for (final w in words) w.id,
          ]);
          return generator.lesson(
            pickLessonWords(words, states),
            states,
            pool: pool,
          );
        }(),
        PracticeMode.unitExam ||
        PracticeMode.quickPass => generator.exam(words, pool: pool),
        _ => generator.exam(words, count: levelExamQuestionCount, pool: pool),
      };
      if (!mounted) return;
      setState(() => _exercises = exercises);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  /// Biriken çalışma süresinin tam dakikalarını, oturum bitince tamamını
  /// kaydeder (NFR-05).
  Future<void> _saveStudyTime({required bool finished}) async {
    final split = splitStudyTime(_unsavedStudyTime, finished: finished);
    _unsavedStudyTime = split.keep;
    await ref.read(studyRepositoryProvider).addStudyTime(split.save);
  }

  /// Her cevap anında kaydedilir (NFR-05).
  Future<void> _onOutcome(Exercise exercise, ExerciseOutcome outcome) async {
    setState(() {
      _answered = true;
      if (outcome.allCorrect) {
        _correct++;
      } else {
        _wrongWords.addAll(
          outcome.answers.where((a) => !a.correct).map((a) => a.word),
        );
      }
    });
    final study = ref.read(studyRepositoryProvider);
    final exam =
        widget.mode == PracticeMode.unitExam ||
        widget.mode == PracticeMode.levelExam ||
        widget.mode == PracticeMode.quickPass;
    _unsavedStudyTime += outcome.elapsed;
    await _saveStudyTime(finished: false);
    // Oturum içi tekrarlar aralıklı tekrar takvimini değiştirmez (FR-62).
    if (exercise.isRepeat) return;
    for (final answer in outcome.answers) {
      _xp += await study.recordAnswer(
        wordId: answer.word.id,
        correct: answer.correct,
        exam: exam,
        quality: answerQuality(
          correct: answer.correct,
          almostCorrect: answer.almostCorrect,
          responseTime: outcome.elapsed,
        ),
        exerciseType: exercise.type.id,
        responseMs: outcome.elapsed.inMilliseconds,
      );
    }
  }

  Future<void> _next() async {
    final exercises = _exercises!;
    if (_index < exercises.length - 1) {
      setState(() {
        _index++;
        _answered = false;
      });
      return;
    }
    final result = SessionResult(
      correct: _correct,
      total: exercises.length,
      wrongWords: _wrongWords,
    );
    final progress = ref.read(progressRepositoryProvider);
    bool? passed;
    switch (widget.mode) {
      case PracticeMode.lesson:
      case PracticeMode.review:
      case PracticeMode.favorites:
      case PracticeMode.difficult:
      case PracticeMode.wordList:
        break;
      case PracticeMode.unitExam:
        passed = await progress.recordUnitExam(
          widget.unitId!,
          result.scorePercent,
        );
      case PracticeMode.quickPass:
        passed = await progress.recordQuickPass(
          widget.unitId!,
          result.scorePercent,
        );
      case PracticeMode.levelExam:
        passed = await progress.recordLevelExam(
          widget.levelId!,
          result.scorePercent,
        );
    }
    await _saveStudyTime(finished: true);
    final badges = await ref.read(badgeRepositoryProvider).check();
    if (!mounted) return;
    ref.invalidate(earnedBadgesProvider);
    ref.invalidate(levelOverviewProvider);
    ref.invalidate(levelExamEligibilityProvider);
    ref.invalidate(homeSummaryProvider);
    ref.invalidate(statsProvider);
    setState(() {
      _result = result;
      _passed = passed;
      _newBadges = badges;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final exercises = _exercises;
    final title = switch (widget.mode) {
      PracticeMode.lesson => _title,
      PracticeMode.unitExam => '${l10n.unitExam}: $_title',
      PracticeMode.quickPass => '${l10n.quickPassExam}: $_title',
      PracticeMode.levelExam => '$_levelCode ${l10n.levelExam}',
      PracticeMode.review => l10n.reviewTitle,
      PracticeMode.favorites => l10n.practiceFavorites,
      PracticeMode.difficult => l10n.practiceDifficult,
      PracticeMode.wordList => _title,
    };

    Widget body;
    if (_error != null) {
      body = Center(child: Text(l10n.loadError));
    } else if (exercises == null) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_result != null) {
      body = ResultView(
        mode: widget.mode,
        result: _result!,
        passed: _passed,
        levelCode: _levelCode,
        xp: _xp,
        newBadges: _newBadges,
      );
    } else if (exercises.isEmpty) {
      body = Center(child: Text(l10n.noWords));
    } else {
      final exercise = exercises[_index];
      final tts = ref.watch(ttsServiceProvider);
      void onOutcome(ExerciseOutcome o) {
        ref.read(answerFeedbackProvider).play(correct: o.allCorrect);
        _onOutcome(exercise, o);
      }

      body = Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: (_index + (_answered ? 1 : 0)) / exercises.length,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(l10n.questionPosition(_index + 1, exercises.length)),
              ],
            ),
          ),
          Expanded(
            child: switch (exercise) {
              ChoiceExercise() => ChoiceExerciseView(
                key: ValueKey(_index),
                exercise: exercise,
                tts: tts,
                onOutcome: onOutcome,
                onContinue: _next,
              ),
              TypingExercise() => TypingExerciseView(
                key: ValueKey(_index),
                exercise: exercise,
                tts: tts,
                onOutcome: onOutcome,
                onContinue: _next,
              ),
              ScrambleExercise() => ScrambleExerciseView(
                key: ValueKey(_index),
                exercise: exercise,
                tts: tts,
                onOutcome: onOutcome,
                onContinue: _next,
              ),
              MatchingExercise() => MatchingExerciseView(
                key: ValueKey(_index),
                exercise: exercise,
                onOutcome: onOutcome,
                onContinue: _next,
              ),
            },
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: body,
    );
  }
}
