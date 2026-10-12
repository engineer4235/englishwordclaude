import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../data/providers.dart';
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
            ],
          ],
        ),
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
      enabled: !locked,
      leading: _StatusIcon(status: unit.status),
      title: Text(unit.title),
      subtitle: Text(l10n.unitWords(unit.learnedCount, unit.wordCount)),
      trailing: score != null && score > 0 ? Text(l10n.bestScore(score)) : null,
      onTap: locked ? null : () => context.go(AppRoutes.unit(unit.id)),
    );
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
