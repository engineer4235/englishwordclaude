import '../srs/card_state.dart';

/// Bir günün çalışma özeti (FR-81).
class DayActivity {
  const DayActivity({
    required this.day,
    this.newWords = 0,
    this.reviews = 0,
    this.minutes = 0,
  });

  final DateTime day;
  final int newWords;
  final int reviews;
  final int minutes;

  int get total => newWords + reviews;
}

/// İstatistik ekranı verisi (FR-80, FR-81).
class LearningStats {
  const LearningStats({required this.byState, required this.last30Days});

  /// Durumlara göre kelime sayısı (FR-80).
  final Map<CardState, int> byState;

  /// Son 30 gün, en eski önce; son eleman bugün.
  final List<DayActivity> last30Days;

  /// Tekrar ya da ustalık aşamasındaki kelimeler öğrenilmiş sayılır.
  int get learned =>
      (byState[CardState.review] ?? 0) + (byState[CardState.mastered] ?? 0);

  int get studied => byState.values.fold(0, (a, b) => a + b);

  List<DayActivity> get last7Days => last30Days.sublist(last30Days.length - 7);
}
