import 'package:english_word_learning/core/router/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('alıştırma, sınav ve tekrarda alt menü gizlenir', () {
    expect(AppRoutes.isFocused(AppRoutes.review), isTrue);
    expect(AppRoutes.isFocused(AppRoutes.unitPractice(3)), isTrue);
    expect(AppRoutes.isFocused(AppRoutes.unitExam(3)), isTrue);
    expect(AppRoutes.isFocused(AppRoutes.levelExam(1)), isTrue);
    expect(AppRoutes.isFocused(AppRoutes.favoritesPractice), isTrue);
    expect(AppRoutes.isFocused(AppRoutes.difficultPractice), isTrue);
  });

  test('ana sekmelerde ve kelime kartlarında alt menü görünür', () {
    for (final path in [
      AppRoutes.home,
      AppRoutes.levelMap,
      AppRoutes.unit(3),
      AppRoutes.words,
      AppRoutes.stats,
      AppRoutes.profile,
    ]) {
      expect(AppRoutes.isFocused(path), isFalse, reason: path);
    }
  });
}
