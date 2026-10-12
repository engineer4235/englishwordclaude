import 'package:english_word_learning/core/theme/app_theme.dart';
import 'package:english_word_learning/core/theme/theme_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tema varsayılan olarak sistem ayarını izler ve değiştirilebilir', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(themeModeProvider), ThemeMode.system);
    container.read(themeModeProvider.notifier).setMode(ThemeMode.dark);
    expect(container.read(themeModeProvider), ThemeMode.dark);
  });

  test('açık ve koyu temalar Material 3 kullanır', () {
    expect(AppTheme.light().useMaterial3, isTrue);
    expect(AppTheme.dark().colorScheme.brightness, Brightness.dark);
  });
}
