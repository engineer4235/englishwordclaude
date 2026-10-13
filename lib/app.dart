import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
