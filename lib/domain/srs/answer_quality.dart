/// Cevaptan SM-2 kalitesini hesaplar (FR-61).
///
/// Doğru ve hızlı = 5, doğru ve yavaş = 4, neredeyse doğru = 3, yanlış = 1.
int answerQuality({
  required bool correct,
  required Duration responseTime,
  bool almostCorrect = false,
  Duration fastThreshold = const Duration(seconds: 5),
}) {
  if (correct) return responseTime <= fastThreshold ? 5 : 4;
  if (almostCorrect) return 3;
  return 1;
}
