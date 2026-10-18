import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import 'app_routes.dart';

/// Alt menüyü (Ana Sayfa · Harita · Kelimelerim · İstatistik · Profil) taşıyan
/// iskelet. Alıştırma ve sınavlarda menü gizlenir.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
    this.location = '',
  });

  final StatefulNavigationShell navigationShell;

  /// Geçerli yol; odak oturumlarında alt menü gizlenir.
  final String location;

  /// Geniş ekranlarda (tablet) içeriğin en fazla genişliği.
  static const maxContentWidth = 840.0;

  /// Sekme etiketleri tek satıra sığmıyorsa (dar ekran + büyük yazı)
  /// sığacak yazı boyutunu döndürür; sığıyorsa `null`.
  static double? _fittingLabelSize(BuildContext context, List<String> labels) {
    final theme = Theme.of(context);
    final style =
        theme.navigationBarTheme.labelTextStyle?.resolve({
          WidgetState.selected,
        }) ??
        theme.textTheme.labelMedium ??
        const TextStyle(fontSize: 12);
    // NavigationBar etiket yazısını en fazla 1,3 kata büyütür.
    final scaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.3);
    final perItem = MediaQuery.sizeOf(context).width / labels.length - 8;
    var widest = 0.0;
    for (final label in labels) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: style),
        textDirection: TextDirection.ltr,
        textScaler: scaler,
        maxLines: 1,
      )..layout();
      if (painter.width > widest) widest = painter.width;
      painter.dispose();
    }
    if (widest <= perItem) return null;
    final size = scaler.scale(style.fontSize ?? 12) * perItem / widest;
    return size.clamp(9.0, 40.0).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = [
      l10n.navHome,
      l10n.navMap,
      l10n.navWords,
      l10n.navStats,
      l10n.navProfile,
    ];
    return Scaffold(
      // Tablette içerik okunabilir bir genişlikte ortalanır (EWL-337).
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: navigationShell,
        ),
      ),
      bottomNavigationBar: AppRoutes.isFocused(location)
          ? null
          : _FittedLabels(
              size: _fittingLabelSize(context, labels),
              child: NavigationBar(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (index) => navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                ),
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.home_outlined),
                    selectedIcon: const Icon(Icons.home),
                    label: l10n.navHome,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.map_outlined),
                    selectedIcon: const Icon(Icons.map),
                    label: l10n.navMap,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.menu_book_outlined),
                    selectedIcon: const Icon(Icons.menu_book),
                    label: l10n.navWords,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.bar_chart_outlined),
                    selectedIcon: const Icon(Icons.bar_chart),
                    label: l10n.navStats,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.person_outline),
                    selectedIcon: const Icon(Icons.person),
                    label: l10n.navProfile,
                  ),
                ],
              ),
            ),
    );
  }
}

/// Dar ekranda büyük yazıyla sekme etiketleri kelime ortasından bölünmesin
/// diye etiket yazısını [size] boyutuna indirir (EWL-337).
class _FittedLabels extends StatelessWidget {
  const _FittedLabels({required this.size, required this.child});

  final double? size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = this.size;
    if (size == null) return child;
    final theme = Theme.of(context);
    final base = theme.navigationBarTheme.labelTextStyle;
    return MediaQuery.withNoTextScaling(
      child: Theme(
        data: theme.copyWith(
          navigationBarTheme: theme.navigationBarTheme.copyWith(
            labelTextStyle: WidgetStateProperty.resolveWith(
              (states) => (base?.resolve(states) ?? const TextStyle()).copyWith(
                fontSize: size,
              ),
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
