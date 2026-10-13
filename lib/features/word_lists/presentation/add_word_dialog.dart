import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../data/repositories/custom_word_repository.dart';
import '../../../l10n/app_localizations.dart';

/// Kendi eklenen kelimeyle ilgili verileri yeniden yükler.
void invalidateCustomWords(WidgetRef ref) {
  ref.invalidate(wordEntriesProvider);
  ref.invalidate(wordListsProvider);
  ref.invalidate(customUnitIdProvider);
}

/// Kendi kelimeni ekleme penceresini açar; eklenen kelimeyi, vazgeçilirse
/// `null` döner (FR-92).
Future<String?> showAddWordDialog(BuildContext context) => showDialog<String>(
  context: context,
  builder: (context) => const _AddWordDialog(),
);

class _AddWordDialog extends ConsumerStatefulWidget {
  const _AddWordDialog();

  @override
  ConsumerState<_AddWordDialog> createState() => _AddWordDialogState();
}

class _AddWordDialogState extends ConsumerState<_AddWordDialog> {
  final _lemma = TextEditingController();
  final _meaning = TextEditingController();
  final _exampleEn = TextEditingController();
  final _exampleTr = TextEditingController();
  String? _error;
  var _saving = false;

  @override
  void dispose() {
    for (final c in [_lemma, _meaning, _exampleEn, _exampleTr]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _valid =>
      _lemma.text.trim().isNotEmpty && _meaning.text.trim().isNotEmpty;

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      await ref
          .read(customWordRepositoryProvider)
          .add(
            lemma: _lemma.text,
            meaningTr: _meaning.text,
            exampleEn: _exampleEn.text,
            exampleTr: _exampleTr.text,
          );
      if (!mounted) return;
      invalidateCustomWords(ref);
      Navigator.pop(context, _lemma.text.trim());
    } on DuplicateWordException {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = l10n.duplicateWord;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Widget field(
      String key,
      TextEditingController c,
      String label, {
      int? maxLength,
      String? error,
    }) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        key: Key(key),
        controller: c,
        maxLength: maxLength,
        decoration: InputDecoration(labelText: label, errorText: error),
        onChanged: (_) => setState(() => _error = null),
      ),
    );

    return AlertDialog(
      title: Text(l10n.addWord),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            field(
              'add-word-lemma',
              _lemma,
              l10n.wordEnLabel,
              maxLength: CustomWordRepository.maxLemmaLength,
              error: _error,
            ),
            field(
              'add-word-meaning',
              _meaning,
              l10n.wordTrLabel,
              maxLength: CustomWordRepository.maxMeaningLength,
            ),
            field('add-word-example-en', _exampleEn, l10n.exampleEnLabel),
            field('add-word-example-tr', _exampleTr, l10n.exampleTrLabel),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('add-word-save'),
          onPressed: _valid && !_saving ? _save : null,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
