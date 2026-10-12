import 'level.dart';

/// Seviye ve ünite kilit durumu (FR-22, FR-25).
enum ProgressStatus {
  locked,
  open,
  completed;

  static ProgressStatus fromDb(String? value) => switch (value) {
    'open' => ProgressStatus.open,
    'completed' => ProgressStatus.completed,
    _ => ProgressStatus.locked,
  };

  String get dbValue => name;
}

/// Seviye haritasında bir ünite.
class UnitOverview {
  const UnitOverview({
    required this.id,
    required this.levelId,
    required this.sortOrder,
    required this.title,
    required this.status,
    required this.wordCount,
    required this.learnedCount,
    this.bestScore,
  });

  final int id;
  final int levelId;
  final int sortOrder;
  final String title;
  final ProgressStatus status;
  final int wordCount;

  /// "Tekrarda" veya "Öğrenildi" durumundaki kelime sayısı.
  final int learnedCount;
  final int? bestScore;

  double get progress => wordCount == 0 ? 0 : learnedCount / wordCount;
}

/// Seviye haritasında bir seviye ve üniteleri.
class LevelOverview {
  const LevelOverview({
    required this.level,
    required this.status,
    required this.units,
    this.examBestScore,
  });

  final Level level;
  final ProgressStatus status;
  final List<UnitOverview> units;
  final int? examBestScore;

  int get wordCount => units.fold(0, (sum, u) => sum + u.wordCount);

  int get learnedCount => units.fold(0, (sum, u) => sum + u.learnedCount);

  double get progress => wordCount == 0 ? 0 : learnedCount / wordCount;

  bool get allUnitsCompleted =>
      units.isNotEmpty &&
      units.every((u) => u.status == ProgressStatus.completed);
}

/// Seviye atlama sınavına girilebilir mi? (FR-23, FR-24)
class LevelExamEligibility {
  const LevelExamEligibility({
    required this.allUnitsCompleted,
    required this.learnedRatio,
    this.retryAvailableAt,
  });

  final bool allUnitsCompleted;
  final double learnedRatio;

  /// Başarısız denemeden sonra 24 saat dolmadıysa tekrar deneme zamanı.
  final DateTime? retryAvailableAt;

  bool get canStart =>
      allUnitsCompleted && learnedRatio >= 0.8 && retryAvailableAt == null;
}
