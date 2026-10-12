import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../data/providers.dart';
import '../../../domain/models/word.dart';
import '../../../l10n/app_localizations.dart';
import 'word_card.dart';

/// Bir ünitenin kelime kartları (FR-30).
class UnitScreen extends ConsumerStatefulWidget {
  const UnitScreen({super.key, required this.unitId});

  final int unitId;

  @override
  ConsumerState<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends ConsumerState<UnitScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = switch (ref.watch(unitTitleProvider(widget.unitId))) {
      AsyncData(:final value) => value,
      _ => '',
    };
    final words = ref.watch(unitWordsProvider(widget.unitId));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: l10n.unitExam,
            icon: const Icon(Icons.quiz_outlined),
            onPressed: () => context.go(AppRoutes.unitExam(widget.unitId)),
          ),
        ],
      ),
      body: switch (words) {
        AsyncData(:final value) when value.isEmpty => Center(
          child: Text(l10n.noWords),
        ),
        AsyncData(:final value) => _buildCards(context, value),
        AsyncError() => Center(child: Text(l10n.loadError)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildCards(BuildContext context, List<Word> words) {
    final l10n = AppLocalizations.of(context);
    final isLast = _index >= words.length - 1;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: (_index + 1) / words.length,
                ),
              ),
              const SizedBox(width: 12),
              Text(l10n.wordPosition(_index + 1, words.length)),
            ],
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: words.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) => WordCard(word: words[i]),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: _index > 0 ? () => _goTo(_index - 1) : null,
                  child: Text(l10n.previous),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: isLast
                      ? () => context.go(AppRoutes.unitPractice(widget.unitId))
                      : () => _goTo(_index + 1),
                  child: Text(isLast ? l10n.startPractice : l10n.next),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
