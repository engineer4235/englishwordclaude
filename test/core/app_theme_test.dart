import 'dart:io';

import 'package:english_word_learning/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  for (final entry in {
    'açık': AppTheme.light(),
    'koyu': AppTheme.dark(),
  }.entries) {
    final theme = entry.value;
    final s = theme.colorScheme;
    final c = theme.extension<AppColors>()!;

    test('${entry.key} temada metin ve zemin çiftleri WCAG AA (NFR-07)', () {
      final pairs = <String, (Color, Color)>{
        'primary': (s.onPrimary, s.primary),
        'primaryContainer': (s.onPrimaryContainer, s.primaryContainer),
        'seçili öğe': (s.primary, s.primaryContainer),
        'secondary': (s.onSecondary, s.secondary),
        'secondaryContainer': (s.onSecondaryContainer, s.secondaryContainer),
        'tertiary': (s.onTertiary, s.tertiary),
        'tertiaryContainer': (s.onTertiaryContainer, s.tertiaryContainer),
        'error': (s.onError, s.error),
        'errorContainer': (s.onErrorContainer, s.errorContainer),
        'surface': (s.onSurface, s.surface),
        'surfaceVariant metin': (s.onSurfaceVariant, s.surface),
        'en koyu kap': (s.onSurfaceVariant, s.surfaceContainerHighest),
        'kart': (s.onSurface, s.surfaceContainerLowest),
        'bağlantı rengi': (s.primary, s.surface),
        'seri rozeti': (c.onStreakContainer, c.streakContainer),
      };
      for (final p in pairs.entries) {
        expect(
          _contrast(p.value.$1, p.value.$2),
          greaterThanOrEqualTo(4.5),
          reason: p.key,
        );
      }
    });

    test(
      '${entry.key} tema Lexend yazı tipini ve marka renklerini kullanır',
      () {
        expect(theme.useMaterial3, isTrue);
        expect(theme.textTheme.bodyMedium?.fontFamily, AppTheme.fontFamily);
        expect(theme.scaffoldBackgroundColor, s.surface);
        expect(theme.navigationBarTheme.indicatorColor, s.primaryContainer);
      },
    );
  }

  test('marka renkleri açık temada', () {
    final s = AppTheme.light().colorScheme;
    expect(s.primary, AppTheme.purple);
    expect(s.secondary, AppTheme.amber);
  });

  test('yazı tipi dosyaları pakette (çevrimdışı)', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('family: ${AppTheme.fontFamily}'));
    for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
      final path = 'assets/fonts/Lexend-$w.ttf';
      expect(pubspec, contains(path));
      expect(File(path).existsSync(), isTrue, reason: path);
    }
    expect(File('assets/fonts/OFL.txt').existsSync(), isTrue);
  });
}
