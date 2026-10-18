import 'package:flutter/material.dart';

import '../../../core/legal/legal_markup.dart';

/// Gizlilik politikası ve KVKK aydınlatma metni (REL-3).
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.document});

  final LegalDocument document;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blocks = document.blocks;
    return Scaffold(
      appBar: AppBar(),
      body: SelectionArea(
        child: ListView(
          key: ValueKey('legal-${document.name}'),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          children: [
            for (final block in blocks)
              switch (block) {
                LegalTitle() => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    block.text,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                LegalHeading() => Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 6),
                  child: Text(block.text, style: theme.textTheme.titleMedium),
                ),
                LegalParagraph() => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(block.text, style: theme.textTheme.bodyMedium),
                ),
                LegalBullet() => Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExcludeSemantics(
                        child: Text(
                          '•  ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          block.text,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              },
            const SizedBox(height: 16),
            Text(
              document.url,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
