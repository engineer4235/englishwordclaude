import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/section_card.dart';
import '../../../data/providers.dart';
import '../../../domain/exercise/exercise.dart';
import '../../../domain/models/progress.dart';
import '../../../domain/models/stats.dart';
import '../../../domain/srs/card_state.dart';
import '../../../l10n/app_localizations.dart';

/// İstatistikler: öğrenilen kelimeler, günlük aktivite, doğruluk, tekrar yükü,
/// ısı haritası ve seviye ilerlemesi (FR-80..FR-85).
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
                _HeatmapCard(stats: s),
                const SizedBox(height: 12),
                _AccuracyCard(stats: s),
                const SizedBox(height: 12),
                _ForecastCard(
                  upcoming: s.upcoming,
                  today: ref.watch(clockProvider)(),
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
    final scheme = theme.colorScheme;
    final colors = AppColors.of(context);
    final onHero = scheme.onPrimary;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge + 6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.statsLearned,
            style: theme.textTheme.titleMedium?.copyWith(color: onHero),
          ),
          Text(
            '${stats.learned}',
            key: const ValueKey('stats-learned'),
            style: theme.textTheme.displayMedium?.copyWith(
              color: onHero,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            l10n.statsStudied(stats.studied),
            style: theme.textTheme.bodyMedium?.copyWith(color: onHero),
          ),
          const SizedBox(height: 16),
          for (final state in [
            CardState.learning,
            CardState.review,
            CardState.mastered,
          ])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(
                      labels[state]!,
                      style: TextStyle(color: onHero),
                    ),
                  ),
                  Expanded(
                    child: RoundedBar(
                      value: (stats.byState[state] ?? 0) / total,
                      color: colors.streak,
                      track: onHero.withValues(alpha: 0.2),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${stats.byState[state] ?? 0}',
                      key: ValueKey('stats-state-${state.dbValue}'),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: onHero,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
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

    return SectionCard(
      icon: Icons.bar_chart_rounded,
      title: l10n.statsActivity,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SegmentedButton<int>(
            key: const ValueKey('stats-range'),
            segments: [
              ButtonSegment(value: 7, label: Text(l10n.stats7Days)),
              ButtonSegment(value: 30, label: Text(l10n.stats30Days)),
            ],
            selected: {selected},
            onSelectionChanged: (s) => onSelect(s.first),
          ),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: days.length > 7 ? 1 : 6,
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: chartHeight * d.newWords / maxTotal,
                              color: scheme.primary,
                            ),
                            Container(
                              height: chartHeight * d.reviews / maxTotal,
                              color: scheme.tertiary,
                            ),
                          ],
                        ),
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
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}

/// Son 12 haftanın çalışma ısı haritası (FR-84). Her sütun bir hafta, her
/// kare bir gündür; renk koyulaştıkça o gün daha çok kelime çalışılmıştır.
class _HeatmapCard extends StatelessWidget {
  const _HeatmapCard({required this.stats});

  final LearningStats stats;

  static double _intensity(int total) => switch (total) {
    0 => 0,
    < 5 => 0.3,
    < 10 => 0.55,
    < 20 => 0.8,
    _ => 1,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final days = stats.history;
    final weeks = (days.length / 7).ceil();
    return SectionCard(
      icon: Icons.calendar_month_rounded,
      title: l10n.statsHeatmap,
      children: [
        Text(
          l10n.statsHeatmapSummary(stats.activeDays),
          key: const ValueKey('stats-heatmap'),
        ),
        const SizedBox(height: 12),
        ExcludeSemantics(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var w = 0; w < weeks; w++)
                  Column(
                    children: [
                      for (var d = w * 7; d < w * 7 + 7 && d < days.length; d++)
                        Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.all(1.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: days[d].total == 0
                                ? scheme.surfaceContainerHighest
                                : scheme.primary.withValues(
                                    alpha: _intensity(days[d].total),
                                  ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AccuracyCard extends StatelessWidget {
  const _AccuracyCard({required this.stats});

  final LearningStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final overall = stats.overallAccuracy;
    final types = [
      for (final type in ExerciseType.values)
        if (stats.accuracyByType[type.id] case final a? when a.total > 0)
          (type, a),
    ];
    return SectionCard(
      icon: Icons.track_changes_rounded,
      title: l10n.statsAccuracy,
      children: [
        Text(
          overall.total == 0
              ? l10n.statsNoAnswers
              : l10n.statsAccuracyOverall(overall.percent, overall.total),
          key: const ValueKey('stats-accuracy'),
        ),
        for (final (type, a) in types)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 130,
                  child: Text(exerciseTypeLabel(l10n, type)),
                ),
                Expanded(
                  child: RoundedBar(
                    value: a.ratio,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
                SizedBox(
                  width: 56,
                  child: Text(
                    '%${a.percent}',
                    key: ValueKey('stats-accuracy-${type.id}'),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Alıştırma türünün kısa adı.
String exerciseTypeLabel(AppLocalizations l10n, ExerciseType type) =>
    switch (type) {
      ExerciseType.mcEnTr => l10n.exLabelMcEnTr,
      ExerciseType.mcTrEn => l10n.exLabelMcTrEn,
      ExerciseType.listenChoose => l10n.exLabelListen,
      ExerciseType.typing => l10n.exLabelTyping,
      ExerciseType.fillBlank => l10n.exLabelFillBlank,
      ExerciseType.matching => l10n.exLabelMatching,
      ExerciseType.scramble => l10n.exLabelScramble,
    };

class _ForecastCard extends StatelessWidget {
  const _ForecastCard({required this.upcoming, required this.today});

  final List<int> upcoming;

  /// Gün adları için bugünün tarihi.
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final weekdays = MaterialLocalizations.of(context).narrowWeekdays;
    final maxCount = upcoming.fold(1, (a, b) => math.max(a, b));
    final total = upcoming.fold(0, (a, b) => a + b);
    const chartHeight = 80.0;
    return SectionCard(
      icon: Icons.event_repeat_rounded,
      accent: true,
      title: l10n.statsForecast,
      children: [
        Text(
          l10n.statsForecastSummary(total),
          key: const ValueKey('stats-forecast'),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < upcoming.length; i++)
              Expanded(
                child: Semantics(
                  label:
                      '${_dayLabel(l10n, weekdays, today, i)}: '
                      '${upcoming[i]}',
                  excludeSemantics: true,
                  child: Column(
                    children: [
                      Text('${upcoming[i]}', style: theme.textTheme.bodySmall),
                      Container(
                        height: chartHeight * upcoming[i] / maxCount,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _dayLabel(l10n, weekdays, today, i),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  String _dayLabel(
    AppLocalizations l10n,
    List<String> weekdays,
    DateTime today,
    int offset,
  ) {
    if (offset == 0) return l10n.statsForecastToday;
    final day = DateTime(today.year, today.month, today.day + offset);
    return weekdays[day.weekday % 7];
  }
}

class _LevelsCard extends StatelessWidget {
  const _LevelsCard({required this.levels});

  final List<LevelOverview> levels;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SectionCard(
      icon: Icons.stairs_rounded,
      title: l10n.statsLevels,
      children: [
        for (final level in levels)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 44,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  margin: const EdgeInsetsDirectional.only(end: 10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    level.level.code,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                Expanded(child: RoundedBar(value: level.progress)),
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
    );
  }
}
