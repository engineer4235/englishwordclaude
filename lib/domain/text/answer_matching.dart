/// Yazılı cevap karşılaştırma sonucu (FR-43).
enum AnswerMatch { correct, almostCorrect, wrong }

/// Cevabı beklenen kelimeyle karşılaştırır. Büyük/küçük harf ve baştaki/sondaki
/// boşluklar önemsenmez. 4 harf ve üzeri kelimelerde tek harflik fark "neredeyse doğru"
/// sayılır.
AnswerMatch matchAnswer(String answer, String expected) {
  final a = _normalize(answer);
  final e = _normalize(expected);
  if (a.isEmpty) return AnswerMatch.wrong;
  if (a == e) return AnswerMatch.correct;
  if (e.length >= 4 && editDistance(a, e) == 1) {
    return AnswerMatch.almostCorrect;
  }
  return AnswerMatch.wrong;
}

String _normalize(String s) =>
    s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

/// Levenshtein mesafesi.
int editDistance(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  var previous = List<int>.generate(b.length + 1, (i) => i);
  for (var i = 1; i <= a.length; i++) {
    final current = List<int>.filled(b.length + 1, 0);
    current[0] = i;
    for (var j = 1; j <= b.length; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      current[j] = [
        previous[j] + 1,
        current[j - 1] + 1,
        previous[j - 1] + cost,
      ].reduce((x, y) => x < y ? x : y);
    }
    previous = current;
  }
  return previous[b.length];
}
