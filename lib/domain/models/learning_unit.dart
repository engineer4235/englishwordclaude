/// Bir seviyedeki temalı ünite (~20 kelime, FR-21).
class LearningUnit {
  const LearningUnit({
    required this.id,
    required this.levelId,
    required this.sortOrder,
    required this.title,
    required this.theme,
  });

  final int id;
  final int levelId;
  final int sortOrder;
  final String title;
  final String theme;
}
