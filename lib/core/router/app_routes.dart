/// Uygulamadaki rota yolları.
abstract final class AppRoutes {
  static const home = '/';
  static const review = '/tekrar';
  static const levelMap = '/harita';
  static const words = '/kelimelerim';
  static const stats = '/istatistik';
  static const profile = '/profil';
  static const onboarding = '/hosgeldin';
  static const placement = '/seviye-tespit';

  /// Tanıtımın son adımından açılan seviye tespit sınavı.
  static const placementFromOnboarding = '$placement?ilk=1';

  static String unit(int unitId) => '$levelMap/unite/$unitId';

  static String unitPractice(int unitId) => '${unit(unitId)}/alistirma';

  static String unitExam(int unitId) => '${unit(unitId)}/sinav';

  /// Kilitli üniteye hızlı geçiş sınavı (FR-27).
  static String quickPass(int unitId) => '${unit(unitId)}/gecis/sinav';

  static String levelExam(int levelId) => '$levelMap/seviye/$levelId/sinav';

  /// Favori kelimeler alıştırması (FR-93).
  static const favoritesPractice = '$words/alistirma/favoriler';

  /// Zorlanılan kelimeler alıştırması (FR-66, FR-93).
  static const difficultPractice = '$words/alistirma/zorlandiklarim';

  /// Kişisel listeler (FR-91).
  static const wordLists = '$words/listeler';

  /// Kişisel liste alıştırması (FR-93).
  static String wordListPractice(int listId) =>
      '$words/alistirma/liste/$listId';

  /// Alıştırma, sınav ve tekrar oturumları: alt menü gizlenir, kullanıcı
  /// oturuma odaklanır ve geri düğmesiyle çıkar.
  static bool isFocused(String path) =>
      path == review ||
      path.endsWith('/alistirma') ||
      path.endsWith('/sinav') ||
      path.contains('/alistirma/');
}
