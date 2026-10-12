import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/tts/tts_service.dart';
import '../../../data/providers.dart';
import '../../../domain/models/word.dart';
import '../../../l10n/app_localizations.dart';

/// Kelime kartı: kelime, okunuş, anlam, örnek cümleler (FR-30, FR-31,
/// FR-34, FR-35).
class WordCard extends ConsumerWidget {
  const WordCard({super.key, required this.word});

  final Word word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tts = ref.watch(ttsServiceProvider);
    final isFavorite = switch (ref.watch(favoriteIdsProvider)) {
      AsyncData(:final value) => value.contains(word.id),
      _ => false,
    };

    return Card(
      margin: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.lemma,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.listen,
                  icon: const Icon(Icons.volume_up),
                  onPressed: () => tts.speak(word.lemma),
                ),
                IconButton(
                  tooltip: isFavorite ? l10n.removeFavorite : l10n.addFavorite,
                  icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                  onPressed: () async {
                    await ref.read(favoritesRepositoryProvider).toggle(word.id);
                    if (!context.mounted) return;
                    ref.invalidate(favoriteIdsProvider);
                  },
                ),
              ],
            ),
            if (word.ipa != null)
              Text(
                word.ipa!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text(partOfSpeechLabel(l10n, word.partOfSpeech)),
              ),
            ),
            const SizedBox(height: 16),
            Text(word.meaningTr, style: theme.textTheme.titleLarge),
            const Divider(height: 32),
            Text(l10n.examples, style: theme.textTheme.titleSmall),
            for (final example in word.examples)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(example.en),
                subtitle: Text(example.tr),
                trailing: IconButton(
                  tooltip: l10n.listen,
                  icon: const Icon(Icons.volume_up_outlined),
                  onPressed: () => tts.speak(example.en),
                ),
              ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.check),
              label: Text(l10n.iKnowThis),
              onPressed: () async {
                await ref.read(reviewRepositoryProvider).markKnown(word.id);
                if (!context.mounted) return;
                ref.invalidate(levelOverviewProvider);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.markedKnown(word.lemma))),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String partOfSpeechLabel(AppLocalizations l10n, String pos) => switch (pos) {
  'noun' => l10n.posNoun,
  'verb' => l10n.posVerb,
  'adjective' => l10n.posAdjective,
  'adverb' => l10n.posAdverb,
  'number' => l10n.posNumber,
  _ => pos,
};
