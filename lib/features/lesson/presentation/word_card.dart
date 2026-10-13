import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/tts/tts_service.dart';
import '../../../data/providers.dart';
import '../../../data/repositories/notes_repository.dart';
import '../../../domain/models/word.dart';
import '../../../l10n/app_localizations.dart';
import '../../word_lists/presentation/add_word_dialog.dart';
import '../../word_lists/presentation/word_lists_screen.dart';

/// Kelime kartı: kelime, okunuş, anlam, kişisel not ve örnek cümleler
/// (FR-30, FR-31, FR-33, FR-34, FR-35, FR-36).
class WordCard extends ConsumerWidget {
  const WordCard({super.key, required this.word});

  final Word word;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteWord),
        content: Text(l10n.deleteWordConfirm(word.lemma)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            key: const Key('delete-word-confirm'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await ref.read(customWordRepositoryProvider).delete(word.id);
    if (!context.mounted) return;
    invalidateCustomWords(ref);
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tts = ref.watch(ttsServiceProvider);
    final isFavorite = switch (ref.watch(favoriteIdsProvider)) {
      AsyncData(:final value) => value.contains(word.id),
      _ => false,
    };
    final isCustom = word.unitId == ref.watch(customUnitIdProvider).value;

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
                  key: const Key('add-to-list'),
                  tooltip: l10n.addToList,
                  icon: const Icon(Icons.playlist_add),
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    showDragHandle: true,
                    builder: (context) => AddToListSheet(wordId: word.id),
                  ),
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
            const SizedBox(height: 8),
            _NoteSection(wordId: word.id),
            _RelationsSection(wordId: word.id),
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
            if (isCustom) ...[
              TextButton.icon(
                key: const Key('delete-word'),
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.deleteWord),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
                onPressed: () => _delete(context, ref),
              ),
              const SizedBox(height: 8),
            ],
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

/// Kelimeye eklenen kişisel not ve düzenleme düğmesi (FR-36).
class _NoteSection extends ConsumerWidget {
  const _NoteSection({required this.wordId});

  final int wordId;

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    String? current,
  ) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _NoteDialog(initial: current ?? ''),
    );
    if (result == null || !context.mounted) return;
    await ref.read(notesRepositoryProvider).save(wordId, result);
    ref.invalidate(wordNoteProvider(wordId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final note = ref.watch(wordNoteProvider(wordId)).value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (note != null)
          Container(
            key: const Key('note-text'),
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.noteTitle, style: theme.textTheme.labelMedium),
                const SizedBox(height: 4),
                Text(note),
              ],
            ),
          ),
        TextButton.icon(
          key: const Key('note-edit'),
          icon: const Icon(Icons.edit_note),
          label: Text(note == null ? l10n.addNote : l10n.editNote),
          onPressed: () => _edit(context, ref, note),
        ),
      ],
    );
  }
}

/// Eş anlamlı, zıt anlamlı ve aynı ailedeki kelimeler (FR-33).
class _RelationsSection extends ConsumerWidget {
  const _RelationsSection({required this.wordId});

  final int wordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relations =
        ref.watch(wordRelationsProvider(wordId)).value ?? WordRelationSet.empty;
    if (relations.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tts = ref.watch(ttsServiceProvider);

    Widget group(String key, String title, List<Word> words) => Padding(
      key: Key('relations-$key'),
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final w in words)
                ActionChip(
                  label: Text('${w.lemma} · ${w.meaningTr}'),
                  onPressed: () => tts.speak(w.lemma),
                ),
            ],
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (relations.synonyms.isNotEmpty)
          group('synonym', l10n.synonyms, relations.synonyms),
        if (relations.antonyms.isNotEmpty)
          group('antonym', l10n.antonyms, relations.antonyms),
        if (relations.family.isNotEmpty)
          group('family', l10n.wordFamily, relations.family),
      ],
    );
  }
}

/// Not düzenleme penceresi; metin denetleyicisinin ömrünü kendisi yönetir.
class _NoteDialog extends StatefulWidget {
  const _NoteDialog({required this.initial});

  final String initial;

  @override
  State<_NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<_NoteDialog> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.noteTitle),
      content: TextField(
        key: const Key('note-field'),
        controller: _controller,
        autofocus: true,
        maxLines: 4,
        maxLength: NotesRepository.maxLength,
        decoration: InputDecoration(hintText: l10n.noteHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('note-save'),
          onPressed: () => Navigator.pop(context, _controller.text),
          child: Text(l10n.saveNote),
        ),
      ],
    );
  }
}

String partOfSpeechLabel(AppLocalizations l10n, String pos) => switch (pos) {
  'noun' => l10n.posNoun,
  'verb' => l10n.posVerb,
  'adjective' => l10n.posAdjective,
  'adverb' => l10n.posAdverb,
  'number' => l10n.posNumber,
  'interjection' => l10n.posInterjection,
  'other' => l10n.posOther,
  _ => pos,
};
