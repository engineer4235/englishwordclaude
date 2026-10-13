import 'package:drift/drift.dart' show Value;
import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/repositories/badge_repository.dart';
import 'package:english_word_learning/data/repositories/progress_repository.dart';
import 'package:english_word_learning/data/repositories/study_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 10, 13, 9);

  setUp(() async {
    db = memoryDatabase();
    await ContentSeeder(db).seedIfEmpty(seedJson);
  });

  tearDown(() => db.close());

  test('rozetler bir kez verilir (FR-73)', () async {
    final badges = BadgeRepository(db, clock: () => now);
    expect(await badges.check(), isEmpty);

    final word = (await db.select(db.words).get()).first;
    await StudyRepository(db, clock: () => now).recordAnswer(
      wordId: word.id,
      quality: 5,
      correct: true,
      exerciseType: 'mc_en_tr',
      responseMs: 1000,
    );
    await db
        .update(db.userProfile)
        .write(const UserProfileCompanion(longestStreak: Value(7)));
    final levels = await ProgressRepository(db, clock: () => now).overview();
    await ProgressRepository(
      db,
      clock: () => now,
    ).applyPlacement(levels[1].level.id);

    expect(await badges.check(), ['first_word', 'streak_7', 'level_A1']);
    expect(await badges.check(), isEmpty);
    final earned = await badges.earned();
    expect(earned.keys, containsAll(['first_word', 'streak_7', 'level_A1']));
    expect(earned['first_word'], now);
  });
}
