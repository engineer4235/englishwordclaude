import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/tts/tts_service.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/providers.dart';
import '../../../domain/models/home_summary.dart';
import '../../../domain/models/progress.dart';
import '../../../l10n/app_localizations.dart';
import '../../lesson/presentation/word_card.dart';

/// Ana ekran: seri, XP, günlük hedef, bugünkü tekrarlar, yeni kelimeler ve
/// günün kelimesi (EWL-329, tasarım yönü B).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final summary = ref.watch(homeSummaryProvider);
    final levels = ref.watch(levelOverviewProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navHome),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        titleTextStyle: Theme.of(context).textTheme.titleLarge
            ?.copyWith(color: scheme.onPrimary),
      ),
      body: switch ((summary, levels)) {
        (AsyncData(value: final s), AsyncData(value: final l)) =>
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(homeSummaryProvider);
              ref.invalidate(levelOverviewProvider);
            },
            child: _HomeBody(summary: s, nextUnit: _nextUnit(l)),
          ),
        (AsyncError(), _) || (_, AsyncError()) => EmptyState.error(
          context,
          onRetry: () {
            ref.invalidate(homeSummaryProvider);
            ref.invalidate(levelOverviewProvider);
          },
        ),
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
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _Header(summary: summary),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _NextUnitCard(summary: summary, unit: nextUnit),
              const SizedBox(height: 14),
              _ReviewCard(summary: summary),
              const SizedBox(height: 14),
              const _WordOfDayCard(),
            ],
          ),
        ),
      ],
    );
  }
}

/// Mor başlık: seri, XP, seri koruması ve günlük hedef çubuğu.
class _Header extends StatelessWidget {
  const _Header({required this.summary});

  final HomeSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = AppColors.of(context);
    final onHeader = theme.textTheme.bodyMedium?.copyWith(
      color: scheme.onPrimary,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeaderChip(
                icon: Icons.local_fire_department_rounded,
                iconColor: colors.streak,
                label: l10n.streakDays(summary.streak),
              ),
              _HeaderChip(
                icon: Icons.bolt_rounded,
                iconColor: scheme.onPrimary,
                label: l10n.xpTotal(summary.totalXp),
              ),
              Tooltip(
                message: l10n.streakFreezeHint,
                child: _HeaderChip(
                  key: const ValueKey('streak-freezes'),
                  icon: Icons.ac_unit_rounded,
                  iconColor: scheme.onPrimary,
                  label: l10n.streakFreezes(summary.streakFreezes),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Büyük yazı boyutunda ilerleme metni alt satıra geçer (NFR-07).
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            children: [
              Text(l10n.dailyGoal, style: onHeader),
              Text(
                l10n.dailyGoalProgress(
                  summary.todayNewWords,
                  summary.dailyTarget,
                ),
                style: onHeader?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: summary.goalProgress,
              minHeight: 12,
              color: colors.streak,
              backgroundColor: scheme.onPrimary.withValues(alpha: 0.22),
              semanticsLabel: l10n.dailyGoal,
            ),
          ),
          if (summary.goalMet) ...[
            const SizedBox(height: 8),
            Text(
              l10n.goalDone,
              style: onHeader?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onPrimary = theme.colorScheme.onPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: onPrimary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(color: onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sıradaki ünite ve yeni kelime düğmesi.
class _NextUnitCard extends StatelessWidget {
  const _NextUnitCard({required this.summary, required this.unit});

  final HomeSummary summary;
  final UnitOverview? unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final unit = this.unit;
    final hasReviews = summary.dueCount > 0;
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: scheme.onSurfaceVariant,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radius),
                  ),
                  child: Icon(
                    unit == null
                        ? Icons.emoji_events_outlined
                        : Icons.auto_stories_outlined,
                    color: scheme.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    unit == null
                        ? l10n.allUnitsDone
                        : l10n.nextUnit(unit.title),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            if (unit != null) ...[
              const SizedBox(height: 12),
              Text(l10n.newWordQuota(summary.newWordQuota), style: muted),
              if (hasReviews) Text(l10n.reviewsFirst, style: muted),
              const SizedBox(height: 14),
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
    );
  }
}

/// Bugünkü tekrarlar (kehribar kart).
class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.summary});

  final HomeSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasReviews = summary.dueCount > 0;
    final onCard = scheme.onSecondaryContainer;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.replay_rounded, color: onCard),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hasReviews ? l10n.dueToday(summary.dueCount) : l10n.noReviews,
                  style: theme.textTheme.titleMedium?.copyWith(color: onCard),
                ),
              ),
            ],
          ),
          if (summary.reviewOverload) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, size: 20, color: onCard),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.reviewOverload,
                    style: theme.textTheme.bodyMedium?.copyWith(color: onCard),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: scheme.secondary,
              foregroundColor: scheme.onSecondary,
            ),
            icon: const Icon(Icons.replay),
            label: Text(l10n.startReview),
            onPressed: hasReviews ? () => context.go(AppRoutes.review) : null,
          ),
        ],
      ),
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
    final scheme = theme.colorScheme;
    return Card(
      key: const ValueKey('word-of-day'),
      clipBehavior: Clip.antiAlias,
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
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.wordOfDay,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(word.lemma, style: theme.textTheme.headlineSmall),
                    Text(
                      word.meaningTr,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                icon: const Icon(Icons.volume_up_rounded),
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
