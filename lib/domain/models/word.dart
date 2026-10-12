/// Öğrenilecek bir kelime (FR-30).
class Word {
  const Word({
    required this.id,
    required this.unitId,
    required this.lemma,
    required this.partOfSpeech,
    required this.meaningTr,
    this.ipa,
  });

  final int id;
  final int unitId;
  final String lemma;
  final String partOfSpeech;
  final String meaningTr;
  final String? ipa;
}
