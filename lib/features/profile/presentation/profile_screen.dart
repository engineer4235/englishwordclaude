import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../l10n/app_localizations.dart';

/// Profil ve ayarlar. Seviye tespit sınavı buradan yeniden yapılır (FR-14).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navProfile)),
      body: ListView(
        children: [
          ListTile(
            key: const ValueKey('retake-placement'),
            leading: const Icon(Icons.quiz),
            title: Text(l10n.retakePlacement),
            subtitle: Text(l10n.retakePlacementHint),
            onTap: () => context.push(AppRoutes.placement),
          ),
        ],
      ),
    );
  }
}
