import 'dart:convert';

import '../models/word.dart';

/// Seviye tespit sınavının soru havuzu (CNT-6, FR-11).
///
/// Ünite içeriğinden bağımsızdır; böylece henüz ünitesi olmayan seviyeler
/// (ör. C1, C2) de ölçülebilir. Kelime kimlikleri veritabanındaki
/// kimliklerle karışmasın diye negatiftir.
class PlacementPool {
  const PlacementPool(this.version, this.levels);

  /// `{"version": 1, "levels": {"A1": [[kelime, tür, anlam], ...]}}`
  factory PlacementPool.parse(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    var id = 0;
    final levels = <String, List<Word>>{};
    for (final entry in (data['levels'] as Map<String, dynamic>).entries) {
      levels[entry.key] = [
        for (final item in (entry.value as List).cast<List<dynamic>>())
          Word(
            id: --id,
            unitId: 0,
            lemma: item[0] as String,
            partOfSpeech: item[1] as String,
            meaningTr: item[2] as String,
          ),
      ];
    }
    return PlacementPool(data['version'] as int, levels);
  }

  /// Her seviyede bulunması gereken en az soru sayısı.
  static const minPerLevel = 30;

  final int version;

  /// Seviye koduna göre kelimeler, kolaydan zora.
  final Map<String, List<Word>> levels;

  List<Word> wordsOf(String levelCode) => levels[levelCode] ?? const [];
}
