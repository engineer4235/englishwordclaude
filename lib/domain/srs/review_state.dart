import 'card_state.dart';

/// Bir kelimenin aralıklı tekrar durumu.
class ReviewState {
  const ReviewState({
    this.state = CardState.newCard,
    this.easeFactor = 2.5,
    this.intervalDays = 0,
    this.repetitions = 0,
    this.lapses = 0,
    this.dueAt,
  });

  static const initial = ReviewState();

  final CardState state;
  final double easeFactor;
  final int intervalDays;
  final int repetitions;
  final int lapses;
  final DateTime? dueAt;

  /// Kart [now] anında tekrar edilmeli mi?
  bool isDue(DateTime now) => dueAt == null || !dueAt!.isAfter(now);

  @override
  String toString() =>
      'ReviewState(${state.name}, ef: ${easeFactor.toStringAsFixed(2)}, '
      'interval: $intervalDays, reps: $repetitions, lapses: $lapses, due: $dueAt)';
}
