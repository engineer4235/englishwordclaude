import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../data/providers.dart';
import '../../../data/repositories/word_list_repository.dart';
import '../../../domain/models/word_list.dart';
import '../../../l10n/app_localizations.dart';

/// Kişisel listeler: oluştur, yeniden adlandır, sil ve listeyle çalış
/// (FR-91, FR-93).
class WordListsScreen extends ConsumerWidget {
  const WordListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lists = ref.watch(wordListsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.myLists)),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('new-list'),
        icon: const Icon(Icons.add),
        label: Text(l10n.newList),
        onPressed: () async {
          final name = await askListName(context, title: l10n.newList);
          if (name == null) return;
          await ref.read(wordListRepositoryProvider).create(name);
          ref.invalidate(wordListsProvider);
        },
      ),
      body: switch (lists) {
        AsyncData(:final value) when value.isEmpty => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(l10n.noLists, textAlign: TextAlign.center),
          ),
        ),
        AsyncData(:final value) => ListView(
          padding: const EdgeInsets.only(bottom: 88),
          children: [for (final list in value) _ListTile(list: list)],
        ),
        AsyncError() => Center(child: Text(l10n.loadError)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _ListTile extends ConsumerWidget {
  const _ListTile({required this.list});

  final WordList list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.read(wordListRepositoryProvider);
    return ListTile(
      key: ValueKey('list-${list.id}'),
      leading: const CircleAvatar(child: Icon(Icons.list_alt)),
      title: Text(list.name),
      subtitle: Text(l10n.resultCount(list.wordCount)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            key: ValueKey('practice-list-${list.id}'),
            tooltip: l10n.practiceList,
            icon: const Icon(Icons.play_circle_outline),
            onPressed: list.wordCount == 0
                ? null
                : () => context.go(AppRoutes.wordListPractice(list.id)),
          ),
          PopupMenuButton<String>(
            key: ValueKey('list-menu-${list.id}'),
            onSelected: (action) async {
              if (action == 'rename') {
                final name = await askListName(
                  context,
                  title: l10n.renameList,
                  initial: list.name,
                );
                if (name == null) return;
                await repo.rename(list.id, name);
              } else {
                await repo.remove(list.id);
              }
              ref.invalidate(wordListsProvider);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'rename', child: Text(l10n.renameList)),
              PopupMenuItem(value: 'delete', child: Text(l10n.deleteList)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Liste adı soran pencere. Vazgeçilirse ya da ad boşsa `null` döner.
Future<String?> askListName(
  BuildContext context, {
  required String title,
  String initial = '',
}) async {
  final name = await showDialog<String>(
    context: context,
    builder: (context) => _ListNameDialog(title: title, initial: initial),
  );
  if (name == null || name.trim().isEmpty) return null;
  return name.trim();
}

class _ListNameDialog extends StatefulWidget {
  const _ListNameDialog({required this.title, required this.initial});

  final String title;
  final String initial;

  @override
  State<_ListNameDialog> createState() => _ListNameDialogState();
}

class _ListNameDialogState extends State<_ListNameDialog> {
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
      title: Text(widget.title),
      content: TextField(
        key: const Key('list-name-field'),
        controller: _controller,
        autofocus: true,
        maxLength: WordListRepository.maxNameLength,
        decoration: InputDecoration(hintText: l10n.listNameHint),
        onSubmitted: (v) => Navigator.pop(context, v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('list-name-save'),
          onPressed: () => Navigator.pop(context, _controller.text),
          child: Text(l10n.saveNote),
        ),
      ],
    );
  }
}

/// Kelimeyi listelere ekleme/çıkarma sayfası (FR-91).
class AddToListSheet extends ConsumerWidget {
  const AddToListSheet({super.key, required this.wordId});

  final int wordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lists = ref.watch(wordListsProvider).value ?? const [];
    final member = ref.watch(listsOfWordProvider(wordId)).value ?? const {};
    final repo = ref.read(wordListRepositoryProvider);

    void refresh() {
      ref.invalidate(wordListsProvider);
      ref.invalidate(listsOfWordProvider(wordId));
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(
              l10n.addToList,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final list in lists)
            CheckboxListTile(
              key: ValueKey('sheet-list-${list.id}'),
              title: Text(list.name),
              value: member.contains(list.id),
              onChanged: (checked) async {
                if (checked ?? false) {
                  await repo.addWord(list.id, wordId);
                } else {
                  await repo.removeWord(list.id, wordId);
                }
                refresh();
              },
            ),
          ListTile(
            key: const ValueKey('sheet-new-list'),
            leading: const Icon(Icons.add),
            title: Text(l10n.newList),
            onTap: () async {
              final name = await askListName(context, title: l10n.newList);
              if (name == null) return;
              final id = await repo.create(name);
              await repo.addWord(id, wordId);
              refresh();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
