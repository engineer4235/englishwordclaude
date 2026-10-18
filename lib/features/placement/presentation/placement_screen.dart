import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/providers.dart';
import '../../../domain/exercise/exercise.dart';
import '../../../domain/models/level.dart';
import '../../../domain/placement/placement_exam.dart';
import '../../../l10n/app_localizations.dart';

/// Uyarlanabilir seviye tespit sınavı ve sonucu (FR-10..14).
class PlacementScreen extends ConsumerStatefulWidget {
  const PlacementScreen({super.key, this.fromOnboarding = false});

  /// Tanıtımın son adımından mı açıldı. Öyleyse sonuçta tanıtım tamamlanır.
  final bool fromOnboarding;

  @override
  ConsumerState<PlacementScreen> createState() => _PlacementScreenState();
}

class _PlacementScreenState extends ConsumerState<PlacementScreen> {
  PlacementExam? _exam;
  ChoiceExercise? _question;
  int _correct = 0;
  bool _saving = false;

  void _start(List<PlacementLevel> levels) {
    final exam = PlacementExam(levels);
    setState(() {
      _exam = exam;
      _question = exam.next();
    });
  }

  void _answer(int? index) {
    final exam = _exam!;
    final correct = index == _question!.correctIndex;
    exam.answer(correct: correct);
    setState(() {
      if (correct) _correct++;
      _question = exam.next();
    });
  }

  Future<void> _choose(Level level) async {
    setState(() => _saving = true);
    await ref.read(progressRepositoryProvider).applyPlacement(level.id);
    ref
      ..invalidate(levelOverviewProvider)
      ..invalidate(homeSummaryProvider)
      ..invalidate(earnedBadgesProvider);
    if (widget.fromOnboarding) {
      await ref.read(onboardingStatusProvider.notifier).complete();
    }
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final levels = ref.watch(placementLevelsProvider);
    final exam = _exam;
    final question = _question;

    final Widget body;
    if (exam == null) {
      body = switch (levels) {
        AsyncData(:final value) => _Intro(
          hasContent: value.any((l) => l.words.isNotEmpty),
          onStart: () => _start(value),
          onSkip: widget.fromOnboarding && value.isNotEmpty
              ? () => _choose(value.first.level)
              : null,
        ),
        AsyncError() => Center(child: Text(l10n.loadError)),
        _ => const Center(child: CircularProgressIndicator()),
      };
    } else if (question != null) {
      body = _Question(
        number: exam.answered + 1,
        question: question,
        onAnswer: _answer,
      );
    } else {
      // Önerilen seviyenin ünitesi yoksa hazır olan en yüksek seviyeden
      // başlanır.
      var start = exam.recommendedIndex;
      while (start > 0 && !exam.levels[start].available) {
        start--;
      }
      body = _Result(
        recommended: exam.recommended,
        start: exam.levels.isEmpty ? null : exam.levels[start].level,
        lower: [
          for (final l in exam.levels.take(start))
            if (l.available) l.level,
        ],
        correct: _correct,
        total: exam.answered,
        saving: _saving,
        onChoose: _choose,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.placementTitle),
        automaticallyImplyLeading: !widget.fromOnboarding,
      ),
      body: SafeArea(
        child: body is _Result
            ? Padding(padding: const EdgeInsets.all(24), child: body)
            : _FillScroll(child: body),
      ),
    );
  }
}

/// Ekranı dolduran ama büyük yazı boyutunda kaydırılabilen gövde (NFR-07).
class _FillScroll extends StatelessWidget {
  const _FillScroll({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: (constraints.maxHeight - 48).clamp(0, double.infinity),
        ),
        child: IntrinsicHeight(child: child),
      ),
    ),
  );
}

class _Intro extends StatelessWidget {
  const _Intro({
    required this.hasContent,
    required this.onStart,
    required this.onSkip,
  });

  final bool hasContent;
  final VoidCallback onStart;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 132,
            height: 132,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.quiz_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          hasContent ? l10n.placementIntro : l10n.placementNoContent,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 32),
        if (hasContent)
          FilledButton(
            key: const ValueKey('placement-start'),
            onPressed: onStart,
            child: Text(l10n.placementStart),
          ),
        if (onSkip != null) ...[
          const SizedBox(height: 12),
          OutlinedButton(
            key: const ValueKey('placement-skip'),
            onPressed: onSkip,
            child: Text(l10n.startFromA1),
          ),
        ],
      ],
    );
  }
}

class _Question extends StatelessWidget {
  const _Question({
    required this.number,
    required this.question,
    required this.onAnswer,
  });

  final int number;
  final ChoiceExercise question;
  final ValueChanged<int?> onAnswer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: number / PlacementExam.maxQuestions,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              flex: 0,
              child: Text(
                l10n.placementQuestion(number),
                style: theme.textTheme.labelLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Text(
            question.prompt,
            key: const ValueKey('prompt'),
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        for (var i = 0; i < question.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OutlinedButton(
              key: ValueKey('option-$i'),
              onPressed: () => onAnswer(i),
              child: Text(question.options[i]),
            ),
          ),
        TextButton(
          key: const ValueKey('dont-know'),
          onPressed: () => onAnswer(null),
          child: Text(l10n.placementDontKnow),
        ),
      ],
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({
    required this.recommended,
    required this.start,
    required this.lower,
    required this.correct,
    required this.total,
    required this.saving,
    required this.onChoose,
  });

  final Level? recommended;

  /// Başlanacak seviye; önerilen seviyenin ünitesi yoksa daha düşüktür.
  final Level? start;
  final List<Level> lower;
  final int correct;
  final int total;
  final bool saving;
  final ValueChanged<Level> onChoose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = AppColors.of(context);
    final level = recommended;
    if (level == null) return Center(child: Text(l10n.placementNoContent));
    final start = this.start ?? level;
    return ListView(
      children: [
        Container(
          key: const ValueKey('placement-hero'),
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge + 6),
          ),
          child: Column(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: colors.streakContainer,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.streak, width: 4),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: FittedBox(
                      child: Text(
                        level.code,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: colors.onStreakContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.placementResultTitle('${level.code} – ${level.title}'),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: scheme.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.placementResultBody(correct, total),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
        if (start.id != level.id) ...[
          const SizedBox(height: 12),
          Text(
            l10n.placementNotReady(level.code, start.code),
            key: const ValueKey('placement-not-ready'),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 32),
        FilledButton(
          key: const ValueKey('placement-accept'),
          onPressed: saving ? null : () => onChoose(start),
          child: Text(l10n.placementAccept(start.code)),
        ),
        if (lower.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(l10n.placementLower, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final l in lower)
                OutlinedButton(
                  key: ValueKey('placement-level-${l.code}'),
                  onPressed: saving ? null : () => onChoose(l),
                  child: Text(l.code),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
