import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/tts/tts_service.dart';
import '../../../data/providers.dart';
import '../../../domain/models/home_summary.dart';
import '../../../domain/models/progress.dart';
import '../../../l10n/app_localizations.dart';
import '../../lesson/presentation/word_card.dart';

/// Ana ekran: seri, XP, günlük hedef, bugünkü tekrarlar, yeni kelimeler ve
/// günün kelimesi.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(homeSummaryProvider);
    final levels = ref.watch(levelOverviewProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navHome)),
      body: switch ((summary, levels)) {
        (AsyncData(value: final s), AsyncData(value: final l)) =>
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(homeSummaryProvider);
              ref.invalidate(levelOverviewProvider);
            },
            child: _HomeBody(summary: s, nextUnit: _nextUnit(l)),
          ),
        (AsyncError(), _) ||
        (_, AsyncError()) => Center(child: Text(l10n.loadError)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  /// Açık seviyedeki ilk tamamlanmamış ünite.
  static UnitOverview? _nextUnit(List<LevelOverview> levels) {
    for (final level in levels) {
      if (level.status != ProgressStatus.open) continue;
      for (final unit in level.units) {
        if (unit.status == ProgressStatus.open) return unit;
      }
    }
    return null;
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.summary, required this.nextUnit});

  final HomeSummary summary;
  final UnitOverview? nextUnit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final unit = nextUnit;
    final hasReviews = summary.dueCount > 0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              avatar: const Icon(Icons.local_fire_department),
              label: Text(l10n.streakDays(summary.streak)),
            ),
            Chip(
              avatar: const Icon(Icons.bolt),
              label: Text(l10n.xpTotal(summary.totalXp)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    value: summary.goalProgress,
                    strokeWidth: 8,
                    semanticsLabel: l10n.dailyGoal,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.dailyGoal, style: theme.textTheme.titleMedium),
                      Text(
                        l10n.dailyGoalProgress(
                          summary.todayNewWords,
                          summary.dailyTarget,
                        ),
                      ),
                      if (summary.goalMet)
                        Text(
                          l10n.goalDone,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  hasReviews ? l10n.dueToday(summary.dueCount) : l10n.noReviews,
                  style: theme.textTheme.titleMedium,
                ),
                if (summary.reviewOverload) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.reviewOverload,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                FilledButton.icon(
                  icon: const Icon(Icons.replay),
                  label: Text(l10n.startReview),
                  onPressed: hasReviews
                      ? () => context.go(AppRoutes.review)
                      : null,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  unit == null ? l10n.allUnitsDone : l10n.nextUnit(unit.title),
                  style: theme.textTheme.titleMedium,
                ),
                if (unit != null) ...[
                  const SizedBox(height: 4),
                  Text(l10n.newWordQuota(summary.newWordQuota)),
                  if (hasReviews) Text(l10n.reviewsFirst),
                  const SizedBox(height: 12),
                  if (hasReviews)
                    OutlinedButton.icon(
                      icon: const Icon(Icons.school_outlined),
                      label: Text(l10n.learnNewWords),
                      onPressed: () => context.go(AppRoutes.unit(unit.id)),
                    )
                  else
                    FilledButton.icon(
                      icon: const Icon(Icons.school_outlined),
                      label: Text(l10n.learnNewWords),
                      onPressed: () => context.go(AppRoutes.unit(unit.id)),
                    ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const _WordOfDayCard(),
      ],
    );
  }
}

/// Günün kelimesi kartı (FR-75).
class _WordOfDayCard extends ConsumerWidget {
  const _WordOfDayCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final word = ref.watch(wordOfDayProvider).value;
    if (word == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      key: const ValueKey('word-of-day'),
      child: InkWell(
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => FractionallySizedBox(
            heightFactor: 0.85,
            child: WordCard(word: word),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.wordOfDay, style: theme.textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text(word.lemma, style: theme.textTheme.headlineSmall),
                    Text(word.meaningTr),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up),
                tooltip: l10n.listen,
                onPressed: () => ref.read(ttsServiceProvider).speak(word.lemma),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
