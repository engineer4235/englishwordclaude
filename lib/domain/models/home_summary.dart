/// Ana ekran özeti (FR-64, FR-65, FR-70, FR-71).
class HomeSummary {
  const HomeSummary({
    required this.dueCount,
    required this.todayNewWords,
    required this.dailyTarget,
    required this.todayXp,
    required this.totalXp,
    required this.streak,
    required this.longestStreak,
    required this.goalMet,
    required this.reviewOverload,
    required this.newWordQuota,
  });

  /// Bugün tekrar zamanı gelmiş kelime sayısı.
  final int dueCount;
  final int todayNewWords;
  final int dailyTarget;
  final int todayXp;
  final int totalXp;

  /// Gösterilen seri: bugün ya da dün hedef tamamlanmadıysa 0.
  final int streak;
  final int longestStreak;
  final bool goalMet;

  /// Tekrar yığılması: yeni kelime kotası azaltıldı (FR-65).
  final bool reviewOverload;

  /// Bugün öğrenilebilecek yeni kelime sayısı.
  final int newWordQuota;

  double get goalProgress =>
      dailyTarget == 0 ? 1 : (todayNewWords / dailyTarget).clamp(0, 1);
}
