import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../data/providers.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../../domain/models/progress.dart';
import '../../../l10n/app_localizations.dart';

/// Seviye haritası: seviyeler, üniteler ve kilit durumları (FR-25).
class LevelMapScreen extends ConsumerWidget {
  const LevelMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final overview = ref.watch(levelOverviewProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navMap)),
      body: switch (overview) {
        AsyncData(:final value) => ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: value.length,
          itemBuilder: (context, i) => _LevelCard(level: value[i]),
        ),
        AsyncError() => Center(child: Text(l10n.loadError)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.level});

  final LevelOverview level;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locked = level.status == ProgressStatus.locked;
    final percent = (level.progress * 100).round();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: locked
                      ? theme.colorScheme.surfaceContainerHighest
                      : theme.colorScheme.primaryContainer,
                  child: Text(level.level.code),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        level.level.title,
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        l10n.levelProgress(percent),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                _StatusIcon(status: level.status),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: level.progress,
              semanticsLabel: l10n.levelProgress(percent),
            ),
            if (locked)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  l10n.levelLocked,
                  style: theme.textTheme.bodyMedium,
                ),
              )
            else ...[
              const SizedBox(height: 8),
              for (final unit in level.units) _UnitTile(unit: unit),
              if (level.status == ProgressStatus.open &&
                  level.allUnitsCompleted)
                _LevelExamButton(levelId: level.level.id),
            ],
          ],
        ),
      ),
    );
  }
}

/// Seviye atlama sınavı girişi ve koşulları (FR-23, FR-24).
class _LevelExamButton extends ConsumerWidget {
  const _LevelExamButton({required this.levelId});

  final int levelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final eligibility = switch (ref.watch(
      levelExamEligibilityProvider(levelId),
    )) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (eligibility == null) return const SizedBox.shrink();
    final retryAt = eligibility.retryAvailableAt;
    final String? reason;
    if (retryAt != null) {
      String two(int n) => n.toString().padLeft(2, '0');
      reason = l10n.examRetryAt(
        '${two(retryAt.day)}.${two(retryAt.month)} '
        '${two(retryAt.hour)}:${two(retryAt.minute)}',
      );
    } else if (eligibility.learnedRatio < 0.8) {
      reason = l10n.examNeedLearned((eligibility.learnedRatio * 100).round());
    } else {
      reason = null;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            icon: const Icon(Icons.workspace_premium_outlined),
            label: Text(l10n.levelExam),
            onPressed: eligibility.canStart
                ? () => context.go(AppRoutes.levelExam(levelId))
                : null,
          ),
          if (reason != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(reason, style: Theme.of(context).textTheme.bodySmall),
            ),
        ],
      ),
    );
  }
}

class _UnitTile extends StatelessWidget {
  const _UnitTile({required this.unit});

  final UnitOverview unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locked = unit.status == ProgressStatus.locked;
    final score = unit.bestScore;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: _StatusIcon(status: unit.status),
      title: Text(unit.title),
      subtitle: Text(l10n.unitWords(unit.learnedCount, unit.wordCount)),
      trailing: locked
          ? Icon(Icons.fast_forward, semanticLabel: l10n.quickPassExam)
          : score != null && score > 0
          ? Text(l10n.bestScore(score))
          : null,
      onTap: locked
          ? () => _offerQuickPass(context)
          : () => context.go(AppRoutes.unit(unit.id)),
    );
  }

  /// Kilitli ünite için hızlı geçiş sınavı önerisi (FR-27).
  Future<void> _offerQuickPass(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final start = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.quickPassExam),
        content: Text(
          l10n.quickPassInfo(unit.title, ProgressRepository.quickPassScore),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            key: const Key('quick-pass-start'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.startExam),
          ),
        ],
      ),
    );
    if (start == true && context.mounted) {
      context.go(AppRoutes.quickPass(unit.id));
    }
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});

  final ProgressStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return switch (status) {
      ProgressStatus.locked => Icon(
        Icons.lock_outline,
        semanticLabel: l10n.statusLocked,
        color: scheme.outline,
      ),
      ProgressStatus.open => Icon(
        Icons.play_circle_outline,
        semanticLabel: l10n.statusOpen,
        color: scheme.primary,
      ),
      ProgressStatus.completed => Icon(
        Icons.check_circle,
        semanticLabel: l10n.statusCompleted,
        color: scheme.tertiary,
      ),
    };
  }
}
