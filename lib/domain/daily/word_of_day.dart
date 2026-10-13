import '../models/word.dart';

/// Günün kelimesi (FR-75). Aynı gün için her zaman aynı kelimeyi, ardışık
/// günlerde farklı kelimeleri seçer. [candidates] boşsa `null` döner.
Word? pickWordOfDay(List<Word> candidates, DateTime day) {
  if (candidates.isEmpty) return null;
  final sorted = [...candidates]..sort((a, b) => a.id.compareTo(b.id));
  final dayNumber = DateTime.utc(
    day.year,
    day.month,
    day.day,
  ).difference(DateTime.utc(2024)).inDays;
  // 7919 asal sayı: ardışık günler listede uzak kelimelere düşer.
  return sorted[(dayNumber * 7919) % sorted.length];
}
