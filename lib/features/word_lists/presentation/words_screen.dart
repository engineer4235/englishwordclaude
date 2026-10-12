import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_screen.dart';
import '../../../l10n/app_localizations.dart';

class WordsScreen extends StatelessWidget {
  const WordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: AppLocalizations.of(context).navWords,
      icon: Icons.menu_book,
    );
  }
}
