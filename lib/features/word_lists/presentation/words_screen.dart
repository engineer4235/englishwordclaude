import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../domain/search/word_search.dart';
import '../../../domain/srs/card_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../lesson/presentation/word_card.dart';

/// Kelimelerim: tüm kelimelerde arama, seviye, durum ve favori filtresi
/// (FR-90, FR-35).
class WordsScreen extends ConsumerStatefulWidget {
  const WordsScreen({super.key});

  @override
  ConsumerState<WordsScreen> createState() => _WordsScreenState();
}

class _WordsScreenState extends ConsumerState<WordsScreen> {
  final _search = TextEditingController();
  var _filter = const WordFilter();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  String _stateLabel(AppLocalizations l10n, CardState state) => switch (state) {
    CardState.newCard => l10n.stateNew,
    CardState.learning => l10n.stateLearning,
    CardState.review => l10n.stateReview,
    CardState.mastered => l10n.stateMastered,
  };

  void _open(WordEntry entry) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.85,
        child: WordCard(word: entry.word),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entries = ref.watch(wordEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navWords)),
      body: switch (entries) {
        AsyncData(:final value) => _body(l10n, value),
        AsyncError() => Center(child: Text(l10n.loadError)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _body(AppLocalizations l10n, List<WordEntry> all) {
    final levelCodes = [
      for (final code in {for (final e in all) e.levelCode})
        if (code.isNotEmpty) code,
    ];
    final results = searchWords(all, _filter);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: TextField(
            key: const ValueKey('word-search'),
            controller: _search,
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              suffixIcon: _filter.query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: l10n.clearSearch,
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _search.clear();
                        setState(() => _filter = _filter.copyWith(query: ''));
                      },
                    ),
            ),
            onChanged: (q) =>
                setState(() => _filter = _filter.copyWith(query: q)),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              FilterChip(
                key: const ValueKey('filter-favorites'),
                avatar: const Icon(Icons.favorite, size: 18),
                label: Text(l10n.filterFavorites),
                selected: _filter.favoritesOnly,
                onSelected: (v) => setState(
                  () => _filter = _filter.copyWith(favoritesOnly: v),
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String?>(
                key: const ValueKey('filter-level'),
                value: _filter.levelCode,
                underline: const SizedBox.shrink(),
                items: [
                  DropdownMenuItem(child: Text(l10n.filterAllLevels)),
                  for (final code in levelCodes)
                    DropdownMenuItem(value: code, child: Text(code)),
                ],
                onChanged: (code) => setState(
                  () => _filter = _filter.copyWith(levelCode: () => code),
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<CardState?>(
                key: const ValueKey('filter-state'),
                value: _filter.state,
                underline: const SizedBox.shrink(),
                items: [
                  DropdownMenuItem(child: Text(l10n.filterAllStates)),
                  for (final state in CardState.values)
                    DropdownMenuItem(
                      value: state,
                      child: Text(_stateLabel(l10n, state)),
                    ),
                ],
                onChanged: (state) => setState(
                  () => _filter = _filter.copyWith(state: () => state),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.resultCount(results.length),
              key: const ValueKey('result-count'),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? Center(child: Text(l10n.noResults))
              : ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, i) {
                    final e = results[i];
                    return ListTile(
                      key: ValueKey('word-${e.word.id}'),
                      leading: CircleAvatar(child: Text(e.levelCode)),
                      title: Text(e.word.lemma),
                      subtitle: Text(e.word.meaningTr),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_stateLabel(l10n, e.state)),
                          if (e.favorite) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.favorite,
                              size: 18,
                              semanticLabel: l10n.filterFavorites,
                            ),
                          ],
                        ],
                      ),
                      onTap: () => _open(e),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
