/// Uygulamadaki rota yolları.
abstract final class AppRoutes {
  static const home = '/';
  static const levelMap = '/harita';
  static const words = '/kelimelerim';
  static const stats = '/istatistik';
  static const profile = '/profil';

  static String unit(int unitId) => '$levelMap/unite/$unitId';

  static String unitPractice(int unitId) => '${unit(unitId)}/alistirma';

  static String unitExam(int unitId) => '${unit(unitId)}/sinav';

  static String levelExam(int levelId) => '$levelMap/seviye/$levelId/sinav';
}
