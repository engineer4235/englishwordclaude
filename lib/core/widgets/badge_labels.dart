import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Rozet adı (FR-73).
String badgeName(AppLocalizations l10n, String code) => switch (code) {
  'first_word' => l10n.badgeFirstWord,
  'words_100' => l10n.badgeWords(100),
  'words_500' => l10n.badgeWords(500),
  'streak_7' => l10n.badgeStreak(7),
  'streak_30' => l10n.badgeStreak(30),
  'streak_100' => l10n.badgeStreak(100),
  _ when code.startsWith('level_') => l10n.badgeLevel(code.substring(6)),
  _ => code,
};

/// Rozet simgesi.
IconData badgeIcon(String code) => switch (code) {
  'first_word' => Icons.auto_awesome,
  _ when code.startsWith('words_') => Icons.menu_book,
  _ when code.startsWith('streak_') => Icons.local_fire_department,
  _ => Icons.military_tech,
};
