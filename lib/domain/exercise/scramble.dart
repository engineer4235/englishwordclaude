import 'dart:math';

final _scrambleable = RegExp(r'^[a-zA-Z]{3,12}$');

/// Harf karıştırma yalnız 3–12 harfli, tek sözcüklük kelimelerde sorulur
/// (FR-47).
bool canScramble(String lemma) => _scrambleable.hasMatch(lemma);

/// Kelimenin harflerini karıştırır. Sonuç, harfleri farklı olan kelimelerde
/// hiçbir zaman kelimenin kendisi olmaz.
List<String> scrambleLetters(String lemma, Random random) {
  final letters = lemma.toLowerCase().split('');
  if (letters.toSet().length < 2) return letters;
  final original = letters.join();
  final shuffled = [...letters];
  do {
    shuffled.shuffle(random);
  } while (shuffled.join() == original);
  return shuffled;
}
