import 'package:flutter/material.dart';

/// Material 3 tema tanımları (EWL-19).
abstract final class AppTheme {
  /// Uygulamanın ana rengi; tüm renk paleti bu tohum renkten türetilir.
  static const Color seedColor = Color(0xFF3949AB);

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: scheme.secondaryContainer,
      ),
    );
  }
}
