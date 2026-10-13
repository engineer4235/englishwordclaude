/// Ana ekran özeti (FR-64, FR-65, FR-70, FR-71, FR-72).
class HomeSummary {
  const HomeSummary({
    required this.dueCount,
    required this.todayNewWords,
    required this.dailyTarget,
    required this.todayXp,
    required this.totalXp,
    required this.streak,
    required this.longestStreak,
    this.streakFreezes = 0,
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

  /// Gösterilen seri: kaçırılan günler seri korumasıyla kapatılamıyorsa 0.
  final int streak;
  final int longestStreak;

  /// Kullanılmayı bekleyen seri koruması (FR-72).
  final int streakFreezes;
  final bool goalMet;

  /// Tekrar yığılması: yeni kelime kotası azaltıldı (FR-65).
  final bool reviewOverload;

  /// Bugün öğrenilebilecek yeni kelime sayısı.
  final int newWordQuota;

  double get goalProgress =>
      dailyTarget == 0 ? 1 : (todayNewWords / dailyTarget).clamp(0, 1);
}
