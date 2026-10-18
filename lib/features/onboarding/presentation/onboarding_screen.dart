import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/notifications/notification_service.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/brand_logo.dart';
import '../../../data/providers.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../l10n/app_localizations.dart';

/// İlk açılış: 3 tanıtım sayfası, amaç, günlük hedef, hatırlatma saati ve
/// başlangıç seçimi (FR-01..05).
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _introPages = 3;
  static const _goalStep = _introPages;
  static const _targetStep = _introPages + 1;
  static const _notifyStep = _introPages + 2;
  static const _startStep = _introPages + 3;

  /// Önerilen hatırlatma saatleri.
  static const notifyPresets = ['08:00', '13:00', '20:00'];

  int _step = 0;
  LearningGoal _goal = LearningGoal.general;
  int _target = 10;
  String? _notifyTime = '20:00';
  bool _saving = false;

  void _next() {
    // Hatırlatma saati seçildiyse bildirim izni istenir (FR-04).
    if (_step == _notifyStep && _notifyTime != null) {
      ref.read(notificationServiceProvider).requestPermission();
    }
    setState(() => _step++);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 20, minute: 0),
    );
    if (picked == null) return;
    String two(int n) => n.toString().padLeft(2, '0');
    setState(() => _notifyTime = '${two(picked.hour)}:${two(picked.minute)}');
  }

  Future<void> _finish({required bool placement}) async {
    setState(() => _saving = true);
    await ref
        .read(profileRepositoryProvider)
        .saveOnboardingChoices(
          goal: _goal,
          dailyTarget: _target,
          notifyTime: _notifyTime,
        );
    if (placement) {
      if (mounted) context.go(AppRoutes.placementFromOnboarding);
      return;
    }
    await ref.read(onboardingStatusProvider.notifier).complete();
    ref.invalidate(homeSummaryProvider);
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final Widget body;
    if (_step < _introPages) {
      final (icon, title, text) = switch (_step) {
        0 => (Icons.stairs_rounded, l10n.intro1Title, l10n.intro1Body),
        1 => (Icons.psychology_rounded, l10n.intro2Title, l10n.intro2Body),
        _ => (
          Icons.local_fire_department_rounded,
          l10n.intro3Title,
          l10n.intro3Body,
        ),
      };
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          if (_step == 0)
            const BrandLogo(size: 148)
          else
            _HeroIcon(icon: icon, accent: _step == 2),
          const SizedBox(height: 32),
          Text(
            title,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < _introPages; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.all(4),
                  width: i == _step ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: i == _step
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                  ),
                ),
            ],
          ),
        ],
      );
    } else if (_step == _goalStep) {
      body = _Choices(
        question: l10n.goalQuestion,
        children: [
          for (final (goal, label, icon) in [
            (LearningGoal.general, l10n.goalGeneral, Icons.public),
            (LearningGoal.travel, l10n.goalTravel, Icons.flight),
            (LearningGoal.work, l10n.goalWork, Icons.work),
            (LearningGoal.exam, l10n.goalExam, Icons.school),
          ])
            _Option(
              key: ValueKey('goal-${goal.dbValue}'),
              icon: icon,
              label: label,
              selected: _goal == goal,
              onTap: () => setState(() => _goal = goal),
            ),
        ],
      );
    } else if (_step == _targetStep) {
      body = _Choices(
        question: l10n.targetQuestion,
        children: [
          for (final count in ProfileRepository.dailyTargetOptions)
            _Option(
              key: ValueKey('target-$count'),
              icon: Icons.flag,
              label: l10n.targetOption(count),
              selected: _target == count,
              onTap: () => setState(() => _target = count),
            ),
        ],
      );
    } else if (_step == _notifyStep) {
      final custom =
          _notifyTime != null && !notifyPresets.contains(_notifyTime);
      body = _Choices(
        question: l10n.notifyQuestion,
        children: [
          for (final time in notifyPresets)
            _Option(
              key: ValueKey('time-$time'),
              icon: Icons.notifications,
              label: time,
              selected: _notifyTime == time,
              onTap: () => setState(() => _notifyTime = time),
            ),
          _Option(
            key: const ValueKey('time-custom'),
            icon: Icons.schedule,
            label: custom ? _notifyTime! : l10n.notifyPick,
            selected: custom,
            onTap: _pickTime,
          ),
          _Option(
            key: const ValueKey('time-none'),
            icon: Icons.notifications_off,
            label: l10n.notifyNone,
            selected: _notifyTime == null,
            onTap: () => setState(() => _notifyTime = null),
          ),
        ],
      );
    } else {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: BrandLogo(size: 96)),
          const SizedBox(height: 24),
          Text(
            l10n.startQuestion,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            key: const ValueKey('start-placement'),
            onPressed: _saving ? null : () => _finish(placement: true),
            icon: const Icon(Icons.quiz_rounded),
            label: Text(l10n.startPlacement),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.startPlacementHint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            key: const ValueKey('start-a1'),
            onPressed: _saving ? null : () => _finish(placement: false),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(l10n.startFromA1),
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (_step > 0)
                Row(
                  children: [
                    IconButton(
                      key: const ValueKey('back'),
                      tooltip: MaterialLocalizations.of(context)
                          .backButtonTooltip,
                      onPressed: () => setState(() => _step--),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    if (_step >= _goalStep) ...[
                      const SizedBox(width: 8),
                      // Ayar adımlarında ilerleme (amaç → başlangıç).
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            key: const ValueKey('setup-progress'),
                            minHeight: 10,
                            value:
                                (_step - _goalStep + 1) /
                                (_startStep - _goalStep + 1),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ],
                ),
              Expanded(child: SingleChildScrollView(child: body)),
              if (_step < _startStep)
                // Büyük yazı boyutunda düğmeler sığmazsa alt alta dizilir
                // (NFR-07).
                OverflowBar(
                  alignment: _step < _introPages
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  overflowAlignment: OverflowBarAlignment.end,
                  spacing: 8,
                  overflowSpacing: 8,
                  children: [
                    if (_step < _introPages)
                      TextButton(
                        key: const ValueKey('skip'),
                        onPressed: () => setState(() => _step = _goalStep),
                        child: Text(l10n.onboardingSkip),
                      ),
                    FilledButton(
                      key: const ValueKey('next'),
                      onPressed: _next,
                      child: Text(l10n.onboardingNext),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Choices extends StatelessWidget {
  const _Choices({required this.question, required this.children});

  final String question;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          question,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        for (final child in children)
          Padding(padding: const EdgeInsets.only(bottom: 10), child: child),
      ],
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? scheme.primaryContainer : scheme.surfaceContainerLowest,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        side: BorderSide(
          color: selected ? scheme.primary : scheme.outlineVariant,
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? scheme.primary : scheme.primaryContainer,
          ),
          child: Icon(
            icon,
            size: 22,
            color: selected ? scheme.onPrimary : scheme.onPrimaryContainer,
          ),
        ),
        title: Text(label),
        trailing: selected
            ? Icon(Icons.check_circle_rounded, color: scheme.primary)
            : null,
        selected: selected,
        selectedColor: scheme.onPrimaryContainer,
        onTap: onTap,
      ),
    );
  }
}

/// Tanıtım sayfalarındaki büyük simge.
class _HeroIcon extends StatelessWidget {
  const _HeroIcon({required this.icon, required this.accent});

  final IconData icon;

  /// Kehribar vurgu (seri sayfası).
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = AppColors.of(context);
    final bg = accent ? colors.streakContainer : scheme.primaryContainer;
    final fg = accent ? colors.streak : scheme.primary;
    return Container(
      width: 148,
      height: 148,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, size: 76, color: fg),
    );
  }
}
