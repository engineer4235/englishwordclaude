import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/notifications/notification_service.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_mode_provider.dart';
import '../../../core/widgets/badge_labels.dart';
import '../../../core/widgets/section_card.dart';
import '../../../data/db/app_database.dart';
import '../../../data/providers.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../domain/models/badge.dart';
import '../../../l10n/app_localizations.dart';

/// Profil ve ayarlar (FR-14, FR-120..124).
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

  /// Verileri JSON ya da CSV olarak panoya kopyalar (FR-124).
  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final format = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              key: const ValueKey('export-json'),
              leading: const Icon(Icons.data_object),
              title: Text(l10n.exportJson),
              subtitle: Text(l10n.exportJsonHint),
              onTap: () => Navigator.pop(context, 'json'),
            ),
            ListTile(
              key: const ValueKey('export-csv'),
              leading: const Icon(Icons.table_chart_outlined),
              title: Text(l10n.exportCsv),
              subtitle: Text(l10n.exportCsvHint),
              onTap: () => Navigator.pop(context, 'csv'),
            ),
          ],
        ),
      ),
    );
    if (format == null) return;
    final export = await ref.read(exportRepositoryProvider).collect();
    await Clipboard.setData(
      ClipboardData(text: format == 'csv' ? export.toCsv() : export.toJson()),
    );
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.exportCopied(export.words.length))),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.read(profileSettingsProvider.notifier);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const _ProfileHeader(),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.military_tech_rounded,
          accent: true,
          title: l10n.badgesTitle,
          children: const [_Badges()],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.school_rounded,
          title: l10n.sectionLearning,
          flush: true,
          children: [
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
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.notifications_rounded,
          title: l10n.sectionNotifications,
          flush: true,
          children: [
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
              onChanged: (v) => settings.save(
                UserProfileCompanion(quietHoursEnabled: Value(v)),
              ),
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
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.palette_rounded,
          title: l10n.sectionSoundTheme,
          flush: true,
          children: [
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
                  onSelectionChanged: (s) => settings.save(
                    UserProfileCompanion(accent: Value(s.first)),
                  ),
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
          ],
        ),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.storage_rounded,
          title: l10n.sectionData,
          flush: true,
          children: [
            ListTile(
              key: const ValueKey('export-data'),
              leading: const Icon(Icons.download_outlined),
              title: Text(l10n.exportData),
              subtitle: Text(l10n.exportDataHint),
              onTap: () => _export(context, ref),
            ),
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
          ],
        ),
        const SizedBox(height: 12),
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = AppColors.of(context);
    final earned = ref.watch(earnedBadgesProvider).value ?? const {};
    return Wrap(
      spacing: 4,
      runSpacing: 12,
      alignment: WrapAlignment.spaceEvenly,
      children: [
        for (final badge in badgeDefs)
          Builder(
            builder: (context) {
              final has = earned.containsKey(badge.code);
              return Tooltip(
                message: has ? l10n.badgeEarned : l10n.badgeLocked,
                child: SizedBox(
                  key: ValueKey('badge-${badge.code}'),
                  width: 92,
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: has
                              ? colors.streakContainer
                              : scheme.surfaceContainerHighest,
                          border: Border.all(
                            color: has ? colors.streak : scheme.outlineVariant,
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          has ? badgeIcon(badge.code) : Icons.lock_rounded,
                          size: 28,
                          color: has
                              ? colors.onStreakContainer
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        badgeName(l10n, badge.code),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: has
                              ? scheme.onSurface
                              : scheme.onSurfaceVariant,
                          fontWeight: has ? FontWeight.w600 : null,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

/// Mor profil başlığı: seri, XP ve rozet sayısı.
class _ProfileHeader extends ConsumerWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = AppColors.of(context);
    final summary = ref.watch(homeSummaryProvider).value;
    final earned = ref.watch(earnedBadgesProvider).value ?? const {};
    final onHero = scheme.onPrimary;

    Widget chip(IconData icon, Color iconColor, String label) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: onHero.withValues(alpha: 0.12),
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
              style: theme.textTheme.labelLarge?.copyWith(color: onHero),
            ),
          ),
        ],
      ),
    );

    return Container(
      key: const ValueKey('profile-header'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge + 6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: onHero.withValues(alpha: 0.16),
                ),
                child: Icon(Icons.person_rounded, size: 32, color: onHero),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  summary == null
                      ? l10n.navProfile
                      : l10n.longestStreak(summary.longestStreak),
                  style: theme.textTheme.titleMedium?.copyWith(color: onHero),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (summary != null) ...[
                chip(
                  Icons.local_fire_department_rounded,
                  colors.streak,
                  l10n.streakDays(summary.streak),
                ),
                chip(Icons.bolt_rounded, onHero, l10n.xpTotal(summary.totalXp)),
              ],
              chip(
                Icons.military_tech_rounded,
                colors.streak,
                l10n.badgesEarnedCount(earned.length, badgeDefs.length),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
