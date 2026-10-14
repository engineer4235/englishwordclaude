import 'package:flutter/material.dart';

/// Uygulamanın tasarım sistemi (EWL-327): "Mor ve Kehribar" yönü.
///
/// Renkler, yazı tipi, köşe yuvarlaklıkları ve bileşen görünümleri tek yerde
/// tanımlanır; ekranlar sabit renk yerine tema değerlerini kullanır. Metin ve
/// zemin çiftleri açık ve koyu temada WCAG AA kontrastını sağlar (NFR-07).
abstract final class AppTheme {
  /// Pakete gömülü yazı tipi (çevrimdışı çalışır).
  static const fontFamily = 'Lexend';

  /// Marka renkleri.
  static const purple = Color(0xFF6C3CE9);
  static const amber = Color(0xFFF5A524);

  static ThemeData light() => _build(lightScheme, AppColors.light);

  static ThemeData dark() => _build(darkScheme, AppColors.dark);

  static const lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: purple,
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFEFE9FE),
    onPrimaryContainer: Color(0xFF2A1067),
    secondary: amber,
    onSecondary: Color(0xFF3D2600),
    secondaryContainer: Color(0xFFFFF4DE),
    onSecondaryContainer: Color(0xFF5C3800),
    tertiary: Color(0xFF0B7A5F),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFE1F6EF),
    onTertiaryContainer: Color(0xFF0B5C47),
    error: Color(0xFFC62F3B),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFDE4E4),
    onErrorContainer: Color(0xFF7A1219),
    surface: Color(0xFFF6F4FD),
    onSurface: Color(0xFF1C1433),
    onSurfaceVariant: Color(0xFF5E5878),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFFFFFFF),
    surfaceContainer: Color(0xFFF1EEFB),
    surfaceContainerHigh: Color(0xFFECE8F7),
    surfaceContainerHighest: Color(0xFFE6E1F5),
    outline: Color(0xFF8F89A8),
    outlineVariant: Color(0xFFE2DCF5),
    shadow: Color(0xFF1C1433),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF2A2440),
    onInverseSurface: Color(0xFFF1EEFB),
    inversePrimary: Color(0xFFB9A2FF),
    surfaceTint: Color(0x00000000),
  );

  static const darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFB9A2FF),
    onPrimary: Color(0xFF2A1067),
    primaryContainer: Color(0xFF43209E),
    onPrimaryContainer: Color(0xFFEFE9FE),
    secondary: Color(0xFFFFC766),
    onSecondary: Color(0xFF3D2600),
    secondaryContainer: Color(0xFF5A3B00),
    onSecondaryContainer: Color(0xFFFFE9C2),
    tertiary: Color(0xFF5FD3B0),
    onTertiary: Color(0xFF003828),
    tertiaryContainer: Color(0xFF0B5C47),
    onTertiaryContainer: Color(0xFFC9F5E6),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF15111F),
    onSurface: Color(0xFFECE8F7),
    onSurfaceVariant: Color(0xFFB9B3CF),
    surfaceContainerLowest: Color(0xFF100D18),
    surfaceContainerLow: Color(0xFF1D1829),
    surfaceContainer: Color(0xFF221C30),
    surfaceContainerHigh: Color(0xFF2A2440),
    surfaceContainerHighest: Color(0xFF332C4A),
    outline: Color(0xFF8F89A8),
    outlineVariant: Color(0xFF3A3350),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFECE8F7),
    onInverseSurface: Color(0xFF2A2440),
    inversePrimary: purple,
    surfaceTint: Color(0x00000000),
  );

  /// Köşe yuvarlaklıkları.
  static const radiusSmall = 12.0;
  static const radius = 16.0;
  static const radiusLarge = 22.0;

  static ThemeData _build(ColorScheme scheme, AppColors colors) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: fontFamily,
    );
    final t = base.textTheme;
    final text = t.copyWith(
      displaySmall: t.displaySmall?.copyWith(fontWeight: FontWeight.w800),
      headlineLarge: t.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
      headlineMedium: t.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
      headlineSmall: t.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
      titleLarge: t.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: t.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: t.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
    final rounded = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
    const buttonSize = Size(64, 52);
    const buttonText = TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: scheme.outlineVariant, width: 2),
    );

    return base.copyWith(
      textTheme: text,
      scaffoldBackgroundColor: scheme.surface,
      extensions: [colors],
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          shape: rounded,
          textStyle: buttonText,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: buttonSize,
          shape: rounded,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          shape: rounded,
          textStyle: buttonText,
          backgroundColor: scheme.surfaceContainerLowest,
          side: BorderSide(color: scheme.outlineVariant, width: 2),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: rounded,
          textStyle: buttonText,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: scheme.surfaceContainerLowest,
        indicatorColor: scheme.primaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontFamily: fontFamily,
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? scheme.onSurface
                : scheme.onSurfaceVariant,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.onSurfaceVariant,
          ),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        circularTrackColor: scheme.surfaceContainerHighest,
        linearMinHeight: 10,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        border: fieldBorder,
        enabledBorder: fieldBorder,
        focusedBorder: fieldBorder.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: rounded,
        iconColor: scheme.primary,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
    );
  }
}

/// Renk şemasında karşılığı olmayan uygulama renkleri: seri ve XP vurguları.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.streak,
    required this.streakContainer,
    required this.onStreakContainer,
    required this.xp,
  });

  static const light = AppColors(
    streak: Color(0xFFF5A524),
    streakContainer: Color(0xFFFFF4DE),
    onStreakContainer: Color(0xFF5C3800),
    xp: Color(0xFF6C3CE9),
  );

  static const dark = AppColors(
    streak: Color(0xFFFFC766),
    streakContainer: Color(0xFF5A3B00),
    onStreakContainer: Color(0xFFFFE9C2),
    xp: Color(0xFFB9A2FF),
  );

  /// Seri simgesi (alev) ve rozeti.
  final Color streak;
  final Color streakContainer;
  final Color onStreakContainer;

  /// XP simgesi.
  final Color xp;

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>() ?? light;

  @override
  AppColors copyWith({
    Color? streak,
    Color? streakContainer,
    Color? onStreakContainer,
    Color? xp,
  }) => AppColors(
    streak: streak ?? this.streak,
    streakContainer: streakContainer ?? this.streakContainer,
    onStreakContainer: onStreakContainer ?? this.onStreakContainer,
    xp: xp ?? this.xp,
  );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      streak: Color.lerp(streak, other.streak, t)!,
      streakContainer: Color.lerp(streakContainer, other.streakContainer, t)!,
      onStreakContainer: Color.lerp(
        onStreakContainer,
        other.onStreakContainer,
        t,
      )!,
      xp: Color.lerp(xp, other.xp, t)!,
    );
  }
}
