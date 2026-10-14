import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/tts/tts_service.dart';
import '../../../domain/exercise/exercise.dart';
import '../../../domain/models/word.dart';
import '../../../domain/text/answer_matching.dart';
import '../../../l10n/app_localizations.dart';

typedef OutcomeCallback = void Function(ExerciseOutcome outcome);

/// Cevaptan sonra gösterilen geri bildirim ve "Devam" düğmesi (FR-49).
class FeedbackBar extends StatelessWidget {
  const FeedbackBar({
    super.key,
    required this.correct,
    required this.message,
    required this.onContinue,
  });

  final bool correct;
  final String message;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = correct
        ? scheme.tertiaryContainer
        : scheme.errorContainer;
    final foreground = correct
        ? scheme.onTertiaryContainer
        : scheme.onErrorContainer;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  correct ? Icons.check_circle : Icons.cancel,
                  color: foreground,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton(
              key: const Key('continue'),
              onPressed: onContinue,
              child: Text(AppLocalizations.of(context).continueLabel),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dört seçenekli sorular (FR-40, FR-41, FR-42, FR-44).
class ChoiceExerciseView extends StatefulWidget {
  const ChoiceExerciseView({
    super.key,
    required this.exercise,
    required this.tts,
    required this.onOutcome,
    required this.onContinue,
  });

  final ChoiceExercise exercise;
  final TtsService tts;
  final OutcomeCallback onOutcome;
  final VoidCallback onContinue;

  @override
  State<ChoiceExerciseView> createState() => _ChoiceExerciseViewState();
}

class _ChoiceExerciseViewState extends State<ChoiceExerciseView> {
  final _stopwatch = Stopwatch()..start();
  int? _selected;

  bool get _isListen => widget.exercise.type == ExerciseType.listenChoose;

  @override
  void initState() {
    super.initState();
    if (_isListen) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.tts.speak(widget.exercise.target.lemma),
      );
    }
  }

  void _select(int index) {
    if (_selected != null) return;
    final ex = widget.exercise;
    final correct = index == ex.correctIndex;
    setState(() => _selected = index);
    widget.onOutcome(
      ExerciseOutcome([
        WordAnswer(ex.target, correct: correct),
      ], _stopwatch.elapsed),
    );
    if (!_isListen) widget.tts.speak(ex.target.lemma);
  }

  String _title(AppLocalizations l10n) => switch (widget.exercise.type) {
    ExerciseType.mcEnTr => l10n.exChooseMeaning,
    ExerciseType.mcTrEn => l10n.exChooseWord,
    ExerciseType.listenChoose => l10n.exListen,
    ExerciseType.fillBlank => l10n.exFillBlank,
    _ => '',
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ex = widget.exercise;
    final answered = _selected != null;

    return ListView(
      key: Key('exercise-${ex.type.id}'),
      padding: const EdgeInsets.all(16),
      children: [
        Text(_title(l10n), style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        if (_isListen)
          Center(
            child: IconButton.filledTonal(
              iconSize: 48,
              tooltip: l10n.replay,
              icon: const Icon(Icons.volume_up),
              onPressed: () => widget.tts.speak(ex.target.lemma),
            ),
          )
        else
          Text(
            ex.prompt,
            key: const Key('prompt'),
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
        if (ex.hint != null) ...[
          const SizedBox(height: 8),
          Text(
            ex.hint!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 24),
        for (var i = 0; i < ex.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _OptionButton(
              label: ex.options[i],
              state: !answered
                  ? _OptionState.idle
                  : i == ex.correctIndex
                  ? _OptionState.correct
                  : i == _selected
                  ? _OptionState.wrong
                  : _OptionState.disabled,
              onPressed: answered ? null : () => _select(i),
            ),
          ),
        if (answered) ...[
          const SizedBox(height: 8),
          FeedbackBar(
            correct: _selected == ex.correctIndex,
            message: _selected == ex.correctIndex
                ? l10n.correctFeedback
                : l10n.wrongFeedback(ex.correctAnswer),
            onContinue: widget.onContinue,
          ),
        ],
      ],
    );
  }
}

enum _OptionState { idle, correct, wrong, disabled }

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.label,
    required this.state,
    required this.onPressed,
  });

  final String label;
  final _OptionState state;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (Color? bg, IconData? icon) = switch (state) {
      _OptionState.correct => (scheme.tertiaryContainer, Icons.check),
      _OptionState.wrong => (scheme.errorContainer, Icons.close),
      _ => (null, null),
    };
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: bg,
        disabledBackgroundColor: bg,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        alignment: Alignment.centerLeft,
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Expanded(child: Text(label)),
          if (icon != null) Icon(icon, size: 20),
        ],
      ),
    );
  }
}

/// Türkçe anlamı verilen kelimeyi yazma (FR-43).
class TypingExerciseView extends StatefulWidget {
  const TypingExerciseView({
    super.key,
    required this.exercise,
    required this.tts,
    required this.onOutcome,
    required this.onContinue,
  });

  final TypingExercise exercise;
  final TtsService tts;
  final OutcomeCallback onOutcome;
  final VoidCallback onContinue;

  @override
  State<TypingExerciseView> createState() => _TypingExerciseViewState();
}

class _TypingExerciseViewState extends State<TypingExerciseView> {
  final _stopwatch = Stopwatch()..start();
  final _controller = TextEditingController();
  AnswerMatch? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _check() {
    if (_result != null || _controller.text.trim().isEmpty) return;
    final target = widget.exercise.target;
    final result = matchAnswer(_controller.text, target.lemma);
    setState(() => _result = result);
    widget.onOutcome(
      ExerciseOutcome([
        WordAnswer(
          target,
          correct: result == AnswerMatch.correct,
          almostCorrect: result == AnswerMatch.almostCorrect,
        ),
      ], _stopwatch.elapsed),
    );
    widget.tts.speak(target.lemma);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final target = widget.exercise.target;
    final result = _result;

    return ListView(
      key: const Key('exercise-typing'),
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.exType, style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        Text(
          target.meaningTr,
          key: const Key('prompt'),
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        TextField(
          key: const Key('typing-field'),
          controller: _controller,
          enabled: result == null,
          autofocus: true,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _check(),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: l10n.typingHint,
          ),
        ),
        const SizedBox(height: 12),
        if (result == null)
          FilledButton(onPressed: _check, child: Text(l10n.check))
        else
          FeedbackBar(
            correct: result == AnswerMatch.correct,
            message: switch (result) {
              AnswerMatch.correct => l10n.correctFeedback,
              AnswerMatch.almostCorrect => l10n.almostFeedback(target.lemma),
              AnswerMatch.wrong => l10n.wrongFeedback(target.lemma),
            },
            onContinue: widget.onContinue,
          ),
      ],
    );
  }
}

/// Karışık harflerden kelimeyi kurma (FR-47). Harflere sırayla dokunulur;
/// tüm harfler yerleşince cevap kontrol edilir.
class ScrambleExerciseView extends StatefulWidget {
  const ScrambleExerciseView({
    super.key,
    required this.exercise,
    required this.tts,
    required this.onOutcome,
    required this.onContinue,
  });

  final ScrambleExercise exercise;
  final TtsService tts;
  final OutcomeCallback onOutcome;
  final VoidCallback onContinue;

  @override
  State<ScrambleExerciseView> createState() => _ScrambleExerciseViewState();
}

class _ScrambleExerciseViewState extends State<ScrambleExerciseView> {
  final _stopwatch = Stopwatch()..start();

  /// Seçilen harflerin [ScrambleExercise.letters] içindeki sırası.
  final _picked = <int>[];
  bool? _correct;

  List<String> get _letters => widget.exercise.letters;

  String get _answer => [for (final i in _picked) _letters[i]].join();

  void _pick(int index) {
    if (_correct != null || _picked.contains(index)) return;
    setState(() => _picked.add(index));
    if (_picked.length == _letters.length) _check();
  }

  void _unpick(int index) {
    if (_correct != null) return;
    setState(() => _picked.remove(index));
  }

  void _check() {
    final target = widget.exercise.target;
    final correct = _answer == target.lemma.toLowerCase();
    setState(() => _correct = correct);
    widget.onOutcome(
      ExerciseOutcome([
        WordAnswer(target, correct: correct),
      ], _stopwatch.elapsed),
    );
    widget.tts.speak(target.lemma);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final target = widget.exercise.target;
    final correct = _correct;

    return ListView(
      key: const Key('exercise-scramble'),
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.exScramble, style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        Text(
          target.meaningTr,
          key: const Key('prompt'),
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        Semantics(
          label: _answer,
          child: Container(
            key: const Key('scramble-answer'),
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final i in _picked)
                  FilledButton.tonal(
                    key: Key('picked-$i'),
                    onPressed: correct == null ? () => _unpick(i) : null,
                    child: Text(_letters[i]),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 6,
          children: [
            for (var i = 0; i < _letters.length; i++)
              if (!_picked.contains(i))
                OutlinedButton(
                  key: Key('letter-$i'),
                  onPressed: correct == null ? () => _pick(i) : null,
                  child: Text(_letters[i]),
                ),
          ],
        ),
        const SizedBox(height: 12),
        if (correct == null)
          TextButton(
            onPressed: _picked.isEmpty ? null : () => setState(_picked.clear),
            child: Text(l10n.clearLetters),
          )
        else
          FeedbackBar(
            correct: correct,
            message: correct
                ? l10n.correctFeedback
                : l10n.wrongFeedback(target.lemma),
            onContinue: widget.onContinue,
          ),
      ],
    );
  }
}

/// Kelime–anlam eşleştirme (FR-45).
class MatchingExerciseView extends StatefulWidget {
  const MatchingExerciseView({
    super.key,
    required this.exercise,
    required this.onOutcome,
    required this.onContinue,
  });

  final MatchingExercise exercise;
  final OutcomeCallback onOutcome;
  final VoidCallback onContinue;

  /// Eşleştirme süresi (FR-45).
  static const timeLimit = Duration(seconds: 60);

  @override
  State<MatchingExerciseView> createState() => _MatchingExerciseViewState();
}

class _MatchingExerciseViewState extends State<MatchingExerciseView> {
  final _stopwatch = Stopwatch()..start();
  Timer? _timer;
  late int _secondsLeft = MatchingExerciseView.timeLimit.inSeconds;
  bool _timedOut = false;
  late final List<Word> _left = [...widget.exercise.words]..shuffle();
  late final List<Word> _right = [...widget.exercise.words]..shuffle();
  final _matched = <int>{};
  final _mistakes = <int>{};
  Word? _selected;
  int? _wrongFlash;

  bool get _done =>
      _timedOut || _matched.length == widget.exercise.words.length;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _done) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) _timeUp();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _report() {
    _timer?.cancel();
    widget.onOutcome(
      ExerciseOutcome([
        for (final w in widget.exercise.words)
          WordAnswer(
            w,
            correct: _matched.contains(w.id) && !_mistakes.contains(w.id),
          ),
      ], _stopwatch.elapsed),
    );
  }

  /// Süre dolunca eşleştirilmeyen kelimeler yanlış sayılır (FR-45).
  void _timeUp() {
    setState(() {
      _timedOut = true;
      _selected = null;
      for (final w in widget.exercise.words) {
        if (!_matched.contains(w.id)) _mistakes.add(w.id);
      }
    });
    _report();
  }

  void _tapRight(Word word) {
    final selected = _selected;
    if (_done || selected == null || _matched.contains(word.id)) return;
    setState(() {
      if (selected.id == word.id) {
        _matched.add(word.id);
        _selected = null;
        _wrongFlash = null;
      } else {
        _mistakes.add(selected.id);
        _wrongFlash = word.id;
      }
    });
    if (_done) _report();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    Widget tile(String label, int id, {required bool left}) {
      final matched = _matched.contains(id);
      final selected = left && _selected?.id == id;
      final wrong = !left && _wrongFlash == id;
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            backgroundColor: matched
                ? scheme.tertiaryContainer
                : selected
                ? scheme.secondaryContainer
                : wrong
                ? scheme.errorContainer
                : null,
          ),
          onPressed: matched || _timedOut
              ? null
              : left
              ? () => setState(() {
                  _selected = widget.exercise.words.firstWhere(
                    (w) => w.id == id,
                  );
                  _wrongFlash = null;
                })
              : () => _tapRight(
                  widget.exercise.words.firstWhere((w) => w.id == id),
                ),
          child: Text(label, textAlign: TextAlign.center),
        ),
      );
    }

    return ListView(
      key: const Key('exercise-matching'),
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.exMatch,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Icon(Icons.timer_outlined, color: scheme.primary),
            const SizedBox(width: 4),
            Text(
              l10n.matchTimeLeft(_secondsLeft),
              key: const Key('match-timer'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: _secondsLeft / MatchingExerciseView.timeLimit.inSeconds,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  for (final w in _left) tile(w.lemma, w.id, left: true),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  for (final w in _right) tile(w.meaningTr, w.id, left: false),
                ],
              ),
            ),
          ],
        ),
        if (_done)
          FeedbackBar(
            correct: _mistakes.isEmpty,
            message: _mistakes.isEmpty
                ? l10n.correctFeedback
                : (_timedOut ? '${l10n.matchTimeUp} ' : '') +
                      l10n.wrongFeedback(
                        widget.exercise.words
                            .where((w) => _mistakes.contains(w.id))
                            .map((w) => '${w.lemma} = ${w.meaningTr}')
                            .join(', '),
                      ),
            onContinue: widget.onContinue,
          ),
      ],
    );
  }
}
