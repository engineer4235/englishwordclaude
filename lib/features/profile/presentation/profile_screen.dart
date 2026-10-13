import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/notifications/notification_service.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/theme_mode_provider.dart';
import '../../../core/widgets/badge_labels.dart';
import '../../../data/db/app_database.dart';
import '../../../data/providers.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../domain/models/badge.dart';
import '../../../l10n/app_localizations.dart';

/// Profil ve ayarlar (FR-14, FR-120..123).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(profileSettingsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navProfile)),
      body: switch (profile) {
        AsyncData(:final value) => _Settings(profile: value),
        AsyncError() => Center(child: Text(l10n.loadError)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Settings extends ConsumerWidget {
  const _Settings({required this.profile});

  final UserProfileRow profile;

  /// Saat seçer ve [toCompanion] ile kaydeder.
  Future<void> _pickTime(
    BuildContext context,
    WidgetRef ref,
    String? current,
    UserProfileCompanion Function(String time) toCompanion,
  ) async {
    final parts = (current ?? '20:00').split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.tryParse(parts.first) ?? 20,
        minute: int.tryParse(parts.last) ?? 0,
      ),
    );
    if (picked == null) return;
    String two(int n) => n.toString().padLeft(2, '0');
    await ref
        .read(profileSettingsProvider.notifier)
        .save(toCompanion('${two(picked.hour)}:${two(picked.minute)}'));
  }

  /// Hatırlatma açılırken bildirim izni istenir (FR-04, FR-100).
  Future<void> _setReminder(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final denied = AppLocalizations.of(context).notifPermissionDenied;
    await ref
        .read(profileSettingsProvider.notifier)
        .save(UserProfileCompanion(reminderEnabled: Value(enabled)));
    if (!enabled) return;
    final granted = await ref
        .read(notificationServiceProvider)
        .requestPermission();
    if (!granted) messenger.showSnackBar(SnackBar(content: Text(denied)));
  }

  Future<void> _reset(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetConfirmTitle),
        content: Text(l10n.resetConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            key: const ValueKey('reset-confirm'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.resetAction),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(progressRepositoryProvider).resetProgress();
    ref
      ..invalidate(levelOverviewProvider)
      ..invalidate(homeSummaryProvider)
      ..invalidate(statsProvider)
      ..invalidate(earnedBadgesProvider)
      ..invalidate(profileSettingsProvider);
    messenger.showSnackBar(SnackBar(content: Text(l10n.resetDone)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.read(profileSettingsProvider.notifier);

    Widget header(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );

    return ListView(
      children: [
        header(l10n.badgesTitle),
        const _Badges(),
        header(l10n.sectionLearning),
        ListTile(
          title: Text(l10n.settingDailyTarget),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SegmentedButton<int>(
              key: const ValueKey('setting-target'),
              segments: [
                for (final n in ProfileRepository.dailyTargetOptions)
                  ButtonSegment(value: n, label: Text('$n')),
              ],
              selected: {profile.dailyTarget},
              onSelectionChanged: (s) => settings.save(
                UserProfileCompanion(dailyTarget: Value(s.first)),
              ),
            ),
          ),
        ),
        ListTile(
          key: const ValueKey('retake-placement'),
          leading: const Icon(Icons.quiz),
          title: Text(l10n.retakePlacement),
          subtitle: Text(l10n.retakePlacementHint),
          onTap: () => context.push(AppRoutes.placement),
        ),
        header(l10n.sectionNotifications),
        SwitchListTile(
          key: const ValueKey('setting-reminder'),
          title: Text(l10n.settingReminder),
          value: profile.reminderEnabled,
          onChanged: (v) => _setReminder(context, ref, v),
        ),
        ListTile(
          enabled: profile.reminderEnabled,
          title: Text(l10n.settingReminderTime),
          trailing: Text(profile.notifyTime ?? '20:00'),
          onTap: () => _pickTime(
            context,
            ref,
            profile.notifyTime,
            (t) => UserProfileCompanion(
              notifyTime: Value(t),
              reminderEnabled: const Value(true),
            ),
          ),
        ),
        SwitchListTile(
          key: const ValueKey('setting-streak-warning'),
          title: Text(l10n.settingStreakWarning),
          value: profile.streakWarningEnabled,
          onChanged: (v) => settings.save(
            UserProfileCompanion(streakWarningEnabled: Value(v)),
          ),
        ),
        SwitchListTile(
          key: const ValueKey('setting-quiet'),
          title: Text(l10n.settingQuietHours),
          subtitle: Text(l10n.settingQuietHoursHint),
          value: profile.quietHoursEnabled,
          onChanged: (v) =>
              settings.save(UserProfileCompanion(quietHoursEnabled: Value(v))),
        ),
        if (profile.quietHoursEnabled) ...[
          ListTile(
            key: const ValueKey('setting-quiet-start'),
            title: Text(l10n.settingQuietStart),
            trailing: Text(profile.quietStart),
            onTap: () => _pickTime(
              context,
              ref,
              profile.quietStart,
              (t) => UserProfileCompanion(quietStart: Value(t)),
            ),
          ),
          ListTile(
            key: const ValueKey('setting-quiet-end'),
            title: Text(l10n.settingQuietEnd),
            trailing: Text(profile.quietEnd),
            onTap: () => _pickTime(
              context,
              ref,
              profile.quietEnd,
              (t) => UserProfileCompanion(quietEnd: Value(t)),
            ),
          ),
        ],
        header(l10n.sectionSoundTheme),
        ListTile(
          title: Text(l10n.settingAccent),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SegmentedButton<String>(
              key: const ValueKey('setting-accent'),
              segments: [
                ButtonSegment(value: 'us', label: Text(l10n.accentUs)),
                ButtonSegment(value: 'uk', label: Text(l10n.accentUk)),
              ],
              selected: {profile.accent},
              onSelectionChanged: (s) =>
                  settings.save(UserProfileCompanion(accent: Value(s.first))),
            ),
          ),
        ),
        ListTile(
          title: Text(l10n.settingSpeechRate),
          subtitle: Slider(
            key: const ValueKey('setting-rate'),
            min: 0.2,
            max: 0.8,
            divisions: 6,
            value: profile.speechRate.clamp(0.2, 0.8).toDouble(),
            onChanged: (v) =>
                settings.save(UserProfileCompanion(speechRate: Value(v))),
          ),
        ),
        ListTile(
          title: Text(l10n.settingTheme),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SegmentedButton<ThemeMode>(
              key: const ValueKey('setting-theme'),
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l10n.themeSystem),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l10n.themeLight),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(l10n.themeDark),
                ),
              ],
              selected: {themeModeFromDb(profile.themeMode)},
              onSelectionChanged: (s) => settings.save(
                UserProfileCompanion(themeMode: Value(s.first.name)),
              ),
            ),
          ),
        ),
        SwitchListTile(
          key: const ValueKey('setting-sound'),
          title: Text(l10n.settingSound),
          value: profile.soundEffects,
          onChanged: (v) =>
              settings.save(UserProfileCompanion(soundEffects: Value(v))),
        ),
        SwitchListTile(
          key: const ValueKey('setting-haptics'),
          title: Text(l10n.settingHaptics),
          value: profile.haptics,
          onChanged: (v) =>
              settings.save(UserProfileCompanion(haptics: Value(v))),
        ),
        header(l10n.sectionData),
        ListTile(
          key: const ValueKey('reset-progress'),
          leading: Icon(Icons.restart_alt, color: theme.colorScheme.error),
          title: Text(
            l10n.resetProgress,
            style: TextStyle(color: theme.colorScheme.error),
          ),
          subtitle: Text(l10n.resetProgressHint),
          onTap: () => _reset(context, ref),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// Kazanılan ve henüz kazanılmayan rozetler (FR-73).
class _Badges extends ConsumerWidget {
  const _Badges();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final earned = ref.watch(earnedBadgesProvider).value ?? const {};
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final badge in badgeDefs)
            Tooltip(
              message: earned.containsKey(badge.code)
                  ? l10n.badgeEarned
                  : l10n.badgeLocked,
              child: Chip(
                key: ValueKey('badge-${badge.code}'),
                avatar: Icon(
                  badgeIcon(badge.code),
                  color: earned.containsKey(badge.code)
                      ? scheme.primary
                      : scheme.outline,
                ),
                label: Text(badgeName(l10n, badge.code)),
                backgroundColor: earned.containsKey(badge.code)
                    ? scheme.primaryContainer
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}
