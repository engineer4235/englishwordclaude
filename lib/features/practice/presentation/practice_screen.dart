import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/tts/tts_service.dart';
import '../../../data/providers.dart';
import '../../../domain/exercise/exercise.dart';
import '../../../domain/exercise/exercise_generator.dart';
import '../../../domain/models/word.dart';
import '../../../domain/srs/answer_quality.dart';
import '../../../l10n/app_localizations.dart';
import 'exercise_views.dart';

enum PracticeMode { lesson, unitExam, levelExam, review }

/// Bir tekrar oturumundaki en fazla kelime.
const reviewSessionSize = 20;

/// Alıştırma, ünite sınavı ve seviye sınavı oturumu.
class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({
    super.key,
    required this.mode,
    this.unitId,
    this.levelId,
  });

  final PracticeMode mode;
  final int? unitId;
  final int? levelId;

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
  String _title = '';
  String _levelCode = '';
  int _xp = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final levels = await ref.read(levelOverviewProvider.future);
      final generator = ref.read(exerciseGeneratorProvider);
      if (widget.mode == PracticeMode.review) {
        final ids = await ref
            .read(reviewRepositoryProvider)
            .dueWordIds(limit: reviewSessionSize);
        final words = await ref
            .read(contentRepositoryProvider)
            .getWordsByIds(ids);
        final levelOfUnit = {
          for (final l in levels)
            for (final u in l.units) u.id: l.level.id,
        };
        final pool = <Word>[];
        for (final levelId in {for (final w in words) levelOfUnit[w.unitId]}) {
          if (levelId != null) {
            pool.addAll(await ref.read(levelWordsProvider(levelId).future));
          }
        }
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
        PracticeMode.lesson => generator.lesson(
          words,
          await ref.read(reviewRepositoryProvider).statesFor([
            for (final w in words) w.id,
          ]),
          pool: pool,
        ),
        PracticeMode.unitExam => generator.exam(words, pool: pool),
        PracticeMode.levelExam || PracticeMode.review => generator.exam(
          words,
          count: levelExamQuestionCount,
          pool: pool,
        ),
      };
      if (!mounted) return;
      setState(() => _exercises = exercises);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
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
        widget.mode == PracticeMode.levelExam;
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
        break;
      case PracticeMode.unitExam:
        passed = await progress.recordUnitExam(
          widget.unitId!,
          result.scorePercent,
        );
      case PracticeMode.levelExam:
        passed = await progress.recordLevelExam(
          widget.levelId!,
          result.scorePercent,
        );
    }
    if (!mounted) return;
    ref.invalidate(levelOverviewProvider);
    ref.invalidate(levelExamEligibilityProvider);
    ref.invalidate(homeSummaryProvider);
    setState(() {
      _result = result;
      _passed = passed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final exercises = _exercises;
    final title = switch (widget.mode) {
      PracticeMode.lesson => _title,
      PracticeMode.unitExam => '${l10n.unitExam}: $_title',
      PracticeMode.levelExam => '$_levelCode ${l10n.levelExam}',
      PracticeMode.review => l10n.reviewTitle,
    };

    Widget body;
    if (_error != null) {
      body = Center(child: Text(l10n.loadError));
    } else if (exercises == null) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_result != null) {
      body = _ResultView(
        mode: widget.mode,
        result: _result!,
        passed: _passed,
        levelCode: _levelCode,
        xp: _xp,
      );
    } else if (exercises.isEmpty) {
      body = Center(child: Text(l10n.noWords));
    } else {
      final exercise = exercises[_index];
      final tts = ref.watch(ttsServiceProvider);
      void onOutcome(ExerciseOutcome o) => _onOutcome(exercise, o);
      body = Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_index + (_answered ? 1 : 0)) / exercises.length,
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

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.mode,
    required this.result,
    required this.passed,
    required this.levelCode,
    required this.xp,
  });

  final PracticeMode mode;
  final int xp;
  final SessionResult result;
  final bool? passed;
  final String levelCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final celebrate = mode == PracticeMode.levelExam && passed == true;
    final message = switch (mode) {
      PracticeMode.lesson => l10n.resultLesson,
      PracticeMode.review => l10n.resultReview,
      PracticeMode.unitExam =>
        passed == true ? l10n.resultUnitPassed : l10n.resultUnitFailed,
      PracticeMode.levelExam =>
        passed == true
            ? l10n.resultLevelPassed(levelCode)
            : l10n.resultLevelFailed,
    };
    final icon = celebrate
        ? Icons.emoji_events
        : passed == false
        ? Icons.refresh
        : Icons.check_circle_outline;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Icon(icon, size: celebrate ? 96 : 72, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          l10n.scorePercent(result.scorePercent),
          key: const Key('score'),
          textAlign: TextAlign.center,
          style: theme.textTheme.displaySmall,
        ),
        Text(
          l10n.correctCount(result.correct, result.total),
          textAlign: TextAlign.center,
        ),
        if (xp > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Center(
              child: Chip(
                avatar: const Icon(Icons.bolt),
                label: Text(l10n.xpGained(xp)),
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        if (celebrate) ...[
          const SizedBox(height: 12),
          Center(
            child: Chip(
              avatar: const Icon(Icons.military_tech),
              label: Text(l10n.levelBadge(levelCode)),
            ),
          ),
        ],
        if (result.wrongWords.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(l10n.wrongWordsTitle, style: theme.textTheme.titleSmall),
          for (final word in {
            for (final w in result.wrongWords) w.id: w,
          }.values)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(word.lemma),
              subtitle: Text(word.meaningTr),
            ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => context.go(
            mode == PracticeMode.review ? AppRoutes.home : AppRoutes.levelMap,
          ),
          child: Text(
            mode == PracticeMode.review ? l10n.backToHome : l10n.backToMap,
          ),
        ),
      ],
    );
  }
}
