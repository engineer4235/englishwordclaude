import 'package:english_word_learning/domain/models/badge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('rozet koşulları (FR-73)', () {
    expect(
      qualifyingBadges(
        studiedWords: 0,
        learnedWords: 0,
        longestStreak: 0,
        completedLevels: const {},
      ),
      isEmpty,
    );
    expect(
      qualifyingBadges(
        studiedWords: 120,
        learnedWords: 100,
        longestStreak: 30,
        completedLevels: const {'A1'},
      ),
      ['first_word', 'words_100', 'streak_7', 'streak_30', 'level_A1'],
    );
  });
}
