import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/repositories/study_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late DateTime now;
  late StudyRepository repo;
  late List<int> wordIds;

  setUp(() async {
    db = memoryDatabase();
    await ContentSeeder(db).seedIfEmpty(seedJson);
    wordIds = [for (final w in await db.select(db.words).get()) w.id];
    now = DateTime(2026, 10, 13, 9);
    repo = StudyRepository(db, clock: () => now);
  });

  tearDown(() => db.close());

  Future<int> answer(int wordId, {bool correct = true, bool exam = false}) =>
      repo.recordAnswer(
        wordId: wordId,
        quality: correct ? 5 : 1,
        correct: correct,
        exerciseType: 'mc_en_tr',
        responseMs: 1000,
        exam: exam,
      );

  Future<void> learnNew(int count, {int offset = 0}) async {
    for (var i = 0; i < count; i++) {
      await answer(wordIds[offset + i]);
    }
  }

  test('XP: yeni kelime 15, tekrar 10, sınav 20, yanlış 0 (FR-70)', () async {
    expect(await answer(wordIds[0]), 15);
    expect(await answer(wordIds[0]), 10);
    expect(await answer(wordIds[1], exam: true), 20);
    expect(await answer(wordIds[2], correct: false), 0);
    expect((await repo.summary()).totalXp, 45);
  });

  test('günlük hedef tamamlanınca seri 1 olur (FR-71)', () async {
    var s = await repo.summary();
    expect(s.streak, 0);
    expect(s.dailyTarget, 10);

    await learnNew(10);
    s = await repo.summary();
    expect(s.goalMet, isTrue);
    expect(s.streak, 1);
    expect(s.todayNewWords, 10);
  });

  test(
    'art arda günlerde seri artar, gün kaçınca 0 görünür (kabul 7)',
    () async {
      await learnNew(10);
      now = now.add(const Duration(days: 1));
      expect((await repo.summary()).streak, 1, reason: 'dün tamamlandı');
      await learnNew(10, offset: 10);
      expect((await repo.summary()).streak, 2);

      now = now.add(const Duration(days: 2));
      expect((await repo.summary()).streak, 0, reason: 'bir gün atlandı');
      await learnNew(4, offset: 20);
      expect((await repo.summary()).streak, 0, reason: 'hedef henüz yok');
    },
  );

  test('zamanı gelen tekrarlar sayılır (FR-64)', () async {
    await learnNew(3);
    expect((await repo.summary()).dueCount, 0);
    now = now.add(const Duration(days: 2));
    expect((await repo.summary()).dueCount, 3);
  });
}
