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

/// Bir seviyenin kartı: ilerleme halkası, tamamlanan ünite sayısı ve
/// üniteler. Tamamlanan seviyelerin üniteleri katlanmış başlar.
class _LevelCard extends StatefulWidget {
  const _LevelCard({required this.level});

  final LevelOverview level;

  @override
  State<_LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<_LevelCard> {
  late bool _expanded = widget.level.status != ProgressStatus.completed;

  @override
  void didUpdateWidget(_LevelCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.level.status != widget.level.status) {
      _expanded = widget.level.status != ProgressStatus.completed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = widget.level;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locked = level.status == ProgressStatus.locked;
    final completed = level.status == ProgressStatus.completed;
    final percent = (level.progress * 100).round();
    final doneUnits = level.units
        .where((u) => u.status == ProgressStatus.completed)
        .length;
    // Sıradaki çalışılacak ünite: açık olup henüz tamamlanmamış ilk ünite.
    final nextUnitId = level.units
        .where((u) => u.status == ProgressStatus.open)
        .map((u) => u.id)
        .firstOrNull;
    // Açık seviye mor, tamamlanan yeşil, kilitli gri başlıkla gösterilir
    // (tasarım yönü B).
    final (Color headerBg, Color headerFg) = locked
        ? (scheme.surfaceContainerHigh, scheme.onSurfaceVariant)
        : completed
        ? (scheme.tertiaryContainer, scheme.onTertiaryContainer)
        : (scheme.primary, scheme.onPrimary);

    return Card(
      key: ValueKey('level-${level.level.code}'),
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: headerBg,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _ProgressRing(
                  value: level.progress,
                  label: level.level.code,
                  color: headerFg,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        level.level.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: headerFg,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.levelProgress(percent),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: headerFg,
                        ),
                      ),
                      if (!locked && level.units.isNotEmpty)
                        Text(
                          l10n.unitsCompleted(doneUnits, level.units.length),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: headerFg,
                          ),
                        ),
                    ],
                  ),
                ),
                if (completed)
                  IconButton(
                    key: ValueKey('toggle-${level.level.code}'),
                    tooltip: _expanded ? l10n.hideUnits : l10n.showUnits,
                    color: headerFg,
                    icon: Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: () => setState(() => _expanded = !_expanded),
                  )
                else
                  _StatusIcon(status: level.status, color: headerFg),
              ],
            ),
          ),
          if (locked)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.levelLocked, style: theme.textTheme.bodyMedium),
            )
          else if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
              child: Stack(
                children: [
                  // Üniteleri birbirine bağlayan yol çizgisi.
                  Positioned(
                    left: 26.5,
                    top: 28,
                    bottom: 28,
                    width: 3,
                    child: ColoredBox(color: scheme.outlineVariant),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final unit in level.units)
                        _UnitTile(unit: unit, isNext: unit.id == nextUnitId),
                      if (level.status == ProgressStatus.open &&
                          level.allUnitsCompleted)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: _LevelExamButton(levelId: level.level.id),
                        ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Seviye kodunu çevreleyen ilerleme halkası.
class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.value,
    required this.label,
    required this.color,
  });

  final double value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 5,
              color: color,
              backgroundColor: color.withValues(alpha: 0.25),
            ),
          ),
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
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
  const _UnitTile({required this.unit, this.isNext = false});

  final UnitOverview unit;

  /// Sıradaki çalışılacak ünite vurgulanır.
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final locked = unit.status == ProgressStatus.locked;
    final score = unit.bestScore;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isNext ? scheme.primaryContainer.withAlpha(110) : null,
        leading: _UnitNode(status: unit.status, isNext: isNext),
        title: Text(
          unit.title,
          style: isNext ? const TextStyle(fontWeight: FontWeight.w600) : null,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.unitWords(unit.learnedCount, unit.wordCount)),
            if (!locked && unit.learnedCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: unit.progress,
                    minHeight: 3,
                  ),
                ),
              ),
          ],
        ),
        trailing: locked
            ? Icon(Icons.fast_forward, semanticLabel: l10n.quickPassExam)
            : isNext
            ? Chip(
                label: Text(l10n.nextUnitBadge),
                visualDensity: VisualDensity.compact,
                backgroundColor: scheme.secondaryContainer,
                labelStyle: TextStyle(color: scheme.onSecondaryContainer),
                side: BorderSide.none,
              )
            : score != null && score > 0
            ? Text(l10n.bestScore(score))
            : null,
        onTap: locked
            ? () => _offerQuickPass(context)
            : () => context.go(AppRoutes.unit(unit.id)),
      ),
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
  const _StatusIcon({required this.status, this.color});

  final ProgressStatus status;

  /// Verilirse tüm durumlar bu renkte çizilir (renkli başlıklar için).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return switch (status) {
      ProgressStatus.locked => Icon(
        Icons.lock_outline,
        semanticLabel: l10n.statusLocked,
        color: color ?? scheme.outline,
      ),
      ProgressStatus.open => Icon(
        Icons.play_circle_outline,
        semanticLabel: l10n.statusOpen,
        color: color ?? scheme.primary,
      ),
      ProgressStatus.completed => Icon(
        Icons.check_circle,
        semanticLabel: l10n.statusCompleted,
        color: color ?? scheme.tertiary,
      ),
    };
  }
}

/// Yol üzerindeki ünite düğümü: tamamlanan yeşil, sıradaki mor, açık
/// açık mor, kilitli gri daire.
class _UnitNode extends StatelessWidget {
  const _UnitNode({required this.status, required this.isNext});

  final ProgressStatus status;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final (Color bg, Color fg, IconData icon, String label) = switch (status) {
      ProgressStatus.completed => (
        scheme.tertiary,
        scheme.onTertiary,
        Icons.check_rounded,
        l10n.statusCompleted,
      ),
      ProgressStatus.locked => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
        Icons.lock_outline,
        l10n.statusLocked,
      ),
      ProgressStatus.open when isNext => (
        scheme.primary,
        scheme.onPrimary,
        Icons.play_arrow_rounded,
        l10n.statusOpen,
      ),
      ProgressStatus.open => (
        scheme.primaryContainer,
        scheme.primary,
        Icons.play_arrow_rounded,
        l10n.statusOpen,
      ),
    };
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: scheme.surfaceContainerLowest, width: 3),
      ),
      child: Icon(icon, size: 22, color: fg, semanticLabel: label),
    );
  }
}
