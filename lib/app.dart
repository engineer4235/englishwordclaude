import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/notifications/notification_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_provider.dart';
import 'data/providers.dart';
import 'l10n/app_localizations.dart';

/// Uygulamanın kök widget'ı (SRS 5.1 / 5.2).
class EnglishWordApp extends ConsumerWidget {
  const EnglishWordApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    ref.listen(profileSettingsProvider, (_, next) {
      final mode = next.value?.themeMode;
      if (mode != null) {
        ref.read(themeModeProvider.notifier).setMode(themeModeFromDb(mode));
      }
    });
    // Plan değişince bildirimler yeniden kurulur (FR-100..102).
    ref.listen(notificationPlanProvider, (previous, next) {
      final plan = next.value;
      if (plan == null || plan == previous?.value) return;
      final l10n = lookupAppLocalizations(const Locale('tr'));
      ref
          .read(notificationServiceProvider)
          .apply(
            plan,
            NotificationTexts(
              reminderTitle: l10n.notifReminderTitle,
              reminderBody: l10n.notifReminderBody,
              streakTitle: l10n.notifStreakTitle,
              streakBody: l10n.notifStreakBody,
            ),
          );
    });
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: const Locale('tr'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
    );
  }
}
