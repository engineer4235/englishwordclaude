/// Bir örnek cümle ve çevirisi.
class Example {
  const Example({required this.en, required this.tr});

  final String en;
  final String tr;
}

/// Öğrenilecek bir kelime (FR-30).
class Word {
  const Word({
    required this.id,
    required this.unitId,
    required this.lemma,
    required this.partOfSpeech,
    required this.meaningTr,
    this.ipa,
    this.examples = const [],
  });

  final int id;
  final int unitId;
  final String lemma;
  final String partOfSpeech;
  final String meaningTr;
  final String? ipa;
  final List<Example> examples;
}
