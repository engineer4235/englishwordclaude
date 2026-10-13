/// Rozet türü (FR-73).
enum BadgeKind { words, streak, level }

/// Bir rozetin tanımı.
class BadgeDef {
  const BadgeDef(this.code, this.kind, {this.threshold = 0, this.levelCode});

  final String code;
  final BadgeKind kind;

  /// Kelime ya da seri eşiği.
  final int threshold;

  /// Seviye rozetinde seviye kodu (A1 … C2).
  final String? levelCode;
}

/// Uygulamadaki tüm rozetler, gösterim sırasıyla.
const badgeDefs = <BadgeDef>[
  BadgeDef('first_word', BadgeKind.words, threshold: 1),
  BadgeDef('words_100', BadgeKind.words, threshold: 100),
  BadgeDef('words_500', BadgeKind.words, threshold: 500),
  BadgeDef('streak_7', BadgeKind.streak, threshold: 7),
  BadgeDef('streak_30', BadgeKind.streak, threshold: 30),
  BadgeDef('streak_100', BadgeKind.streak, threshold: 100),
  BadgeDef('level_A1', BadgeKind.level, levelCode: 'A1'),
  BadgeDef('level_A2', BadgeKind.level, levelCode: 'A2'),
  BadgeDef('level_B1', BadgeKind.level, levelCode: 'B1'),
  BadgeDef('level_B2', BadgeKind.level, levelCode: 'B2'),
  BadgeDef('level_C1', BadgeKind.level, levelCode: 'C1'),
  BadgeDef('level_C2', BadgeKind.level, levelCode: 'C2'),
];

/// Koşulları sağlanan rozetler (FR-73).
///
/// İlk kelime rozeti çalışılan ilk kelimede, diğer kelime rozetleri
/// öğrenilmiş (tekrar ya da ustalık aşamasındaki) kelime sayısıyla verilir.
List<String> qualifyingBadges({
  required int studiedWords,
  required int learnedWords,
  required int longestStreak,
  required Set<String> completedLevels,
}) => [
  for (final b in badgeDefs)
    if (switch (b.kind) {
      BadgeKind.words =>
        b.code == 'first_word'
            ? studiedWords >= b.threshold
            : learnedWords >= b.threshold,
      BadgeKind.streak => longestStreak >= b.threshold,
      BadgeKind.level => completedLevels.contains(b.levelCode),
    })
      b.code,
];
