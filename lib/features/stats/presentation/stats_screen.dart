import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../domain/models/progress.dart';
import '../../../domain/models/stats.dart';
import '../../../domain/srs/card_state.dart';
import '../../../l10n/app_localizations.dart';

/// İstatistikler: öğrenilen kelimeler, günlük aktivite ve seviye ilerlemesi
/// (FR-80, FR-81, FR-82).
class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  int _days = 7;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final stats = ref.watch(statsProvider);
    final levels = ref.watch(levelOverviewProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navStats)),
      body: switch ((stats, levels)) {
        (AsyncData(value: final s), AsyncData(value: final l)) =>
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(statsProvider);
              ref.invalidate(levelOverviewProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _LearnedCard(stats: s),
                const SizedBox(height: 12),
                _ActivityCard(
                  days: _days == 7 ? s.last7Days : s.last30Days,
                  selected: _days,
                  onSelect: (d) => setState(() => _days = d),
                ),
                const SizedBox(height: 12),
                _LevelsCard(levels: l),
              ],
            ),
          ),
        (AsyncError(), _) ||
        (_, AsyncError()) => Center(child: Text(l10n.loadError)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _LearnedCard extends StatelessWidget {
  const _LearnedCard({required this.stats});

  final LearningStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final labels = {
      CardState.newCard: l10n.stateNew,
      CardState.learning: l10n.stateLearning,
      CardState.review: l10n.stateReview,
      CardState.mastered: l10n.stateMastered,
    };
    final total = math.max(stats.studied, 1);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.statsLearned, style: theme.textTheme.titleMedium),
            Text(
              '${stats.learned}',
              key: const ValueKey('stats-learned'),
              style: theme.textTheme.displaySmall,
            ),
            Text(l10n.statsStudied(stats.studied)),
            const SizedBox(height: 12),
            for (final state in [
              CardState.learning,
              CardState.review,
              CardState.mastered,
            ])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(width: 110, child: Text(labels[state]!)),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (stats.byState[state] ?? 0) / total,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '${stats.byState[state] ?? 0}',
                        key: ValueKey('stats-state-${state.dbValue}'),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.days,
    required this.selected,
    required this.onSelect,
  });

  final List<DayActivity> days;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final maxTotal = days.fold(1, (m, d) => math.max(m, d.total));
    final newWords = days.fold(0, (s, d) => s + d.newWords);
    final reviews = days.fold(0, (s, d) => s + d.reviews);
    final minutes = days.fold(0, (s, d) => s + d.minutes);
    const chartHeight = 120.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.statsActivity,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                SegmentedButton<int>(
                  key: const ValueKey('stats-range'),
                  segments: [
                    ButtonSegment(value: 7, label: Text(l10n.stats7Days)),
                    ButtonSegment(value: 30, label: Text(l10n.stats30Days)),
                  ],
                  selected: {selected},
                  onSelectionChanged: (s) => onSelect(s.first),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Semantics(
              label: l10n.statsActivitySummary(newWords, reviews, minutes),
              child: SizedBox(
                height: chartHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final d in days)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: chartHeight * d.reviews / maxTotal,
                                color: scheme.tertiary,
                              ),
                              Container(
                                height: chartHeight * d.newWords / maxTotal,
                                color: scheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              children: [
                _Legend(color: scheme.primary, label: l10n.statsNewWords),
                _Legend(color: scheme.tertiary, label: l10n.statsReviews),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              newWords + reviews == 0
                  ? l10n.statsNoActivity
                  : l10n.statsActivitySummary(newWords, reviews, minutes),
              key: const ValueKey('stats-summary'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}

class _LevelsCard extends StatelessWidget {
  const _LevelsCard({required this.levels});

  final List<LevelOverview> levels;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.statsLevels, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final level in levels)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(width: 40, child: Text(level.level.code)),
                    Expanded(
                      child: LinearProgressIndicator(value: level.progress),
                    ),
                    SizedBox(
                      width: 56,
                      child: Text(
                        '%${(level.progress * 100).round()}',
                        key: ValueKey('stats-level-${level.level.code}'),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
