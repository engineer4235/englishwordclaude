/// Kelime kartının öğrenme durumu (FR-63).
enum CardState {
  /// Hiç çalışılmamış.
  newCard('new'),

  /// İlk doğru cevap verildi ya da kelime unutuldu.
  learning('learning'),

  /// Günlük aralıklarla tekrar ediliyor.
  review('review'),

  /// Tekrar aralığı 21 günü geçti.
  mastered('mastered');

  const CardState(this.dbValue);

  /// Veritabanında saklanan değer.
  final String dbValue;

  static CardState fromDb(String value) => CardState.values.firstWhere(
    (s) => s.dbValue == value,
    orElse: () => CardState.newCard,
  );
}
