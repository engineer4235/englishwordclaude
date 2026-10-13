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

/// Bir alıştırma türündeki doğru cevap oranı (FR-83).
class AccuracyStat {
  const AccuracyStat({this.correct = 0, this.total = 0});

  final int correct;
  final int total;

  /// 0–1 arası oran; hiç cevap yoksa 0.
  double get ratio => total == 0 ? 0 : correct / total;

  int get percent => (ratio * 100).round();

  AccuracyStat add({required bool isCorrect}) =>
      AccuracyStat(correct: correct + (isCorrect ? 1 : 0), total: total + 1);
}

/// İstatistik ekranı verisi (FR-80, FR-81, FR-83, FR-85).
class LearningStats {
  const LearningStats({
    required this.byState,
    required this.history,
    this.accuracyByType = const {},
    this.upcoming = const [],
  });

  /// Durumlara göre kelime sayısı (FR-80).
  final Map<CardState, int> byState;

  /// Isı haritası için tutulan gün sayısı: 12 hafta (FR-84).
  static const historyDays = 84;

  /// Son [historyDays] gün, en eski önce; son eleman bugün.
  final List<DayActivity> history;

  /// Son 30 gün, en eski önce; son eleman bugün.
  List<DayActivity> get last30Days =>
      history.length <= 30 ? history : history.sublist(history.length - 30);

  /// Çalışma yapılan gün sayısı (ısı haritası özeti).
  int get activeDays => history.where((d) => d.total > 0).length;

  /// Son 30 günde alıştırma türüne göre doğruluk; anahtar alıştırma kimliği
  /// (FR-83).
  final Map<String, AccuracyStat> accuracyByType;

  /// Bugünden başlayarak 7 günün tekrar yükü; bugün gecikmiş kartları da
  /// içerir (FR-85).
  final List<int> upcoming;

  /// Tüm türlerin toplam doğruluğu.
  AccuracyStat get overallAccuracy => accuracyByType.values.fold(
    const AccuracyStat(),
    (a, b) =>
        AccuracyStat(correct: a.correct + b.correct, total: a.total + b.total),
  );

  /// Tekrar ya da ustalık aşamasındaki kelimeler öğrenilmiş sayılır.
  int get learned =>
      (byState[CardState.review] ?? 0) + (byState[CardState.mastered] ?? 0);

  int get studied => byState.values.fold(0, (a, b) => a + b);

  List<DayActivity> get last7Days => last30Days.sublist(last30Days.length - 7);
}
