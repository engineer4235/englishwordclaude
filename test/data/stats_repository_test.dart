import 'package:drift/drift.dart' show Value;
import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/repositories/progress_repository.dart';
import 'package:english_word_learning/data/repositories/review_repository.dart';
import 'package:english_word_learning/data/repositories/stats_repository.dart';
import 'package:english_word_learning/data/repositories/study_repository.dart';
import 'package:english_word_learning/domain/models/progress.dart';
import 'package:english_word_learning/domain/srs/card_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late DateTime now;
  late List<int> wordIds;

  setUp(() async {
    db = memoryDatabase();
    await ContentSeeder(db).seedIfEmpty(seedJson);
    wordIds = [for (final w in await db.select(db.words).get()) w.id];
    now = DateTime(2026, 10, 13, 9);
  });

  tearDown(() => db.close());

  Future<void> answer(StudyRepository study, int wordId) => study.recordAnswer(
    wordId: wordId,
    quality: 5,
    correct: true,
    exerciseType: 'mc_en_tr',
    responseMs: 1000,
  );

  test('durum dağılımı ve son 30 günlük aktivite (FR-80, FR-81)', () async {
    final yesterday = StudyRepository(
      db,
      clock: () => now.subtract(const Duration(days: 1)),
    );
    await answer(yesterday, wordIds[0]);
    final today = StudyRepository(db, clock: () => now);
    await answer(today, wordIds[1]);
    await answer(today, wordIds[2]);
    await today.addStudyTime(const Duration(seconds: 90));
    await ReviewRepository(db, clock: () => now).markKnown(wordIds[3]);

    final stats = await StatsRepository(db, clock: () => now).stats();

    expect(stats.byState[CardState.learning], 3);
    expect(stats.byState[CardState.mastered], 1);
    expect(stats.learned, 1);
    expect(stats.studied, 4);
    expect(stats.last30Days, hasLength(30));
    expect(stats.last7Days, hasLength(7));
    expect(stats.last30Days.last.day, DateTime(2026, 10, 13));
    expect(stats.last30Days.last.newWords, 2);
    expect(stats.last30Days.last.minutes, 2);
    expect(stats.last30Days[28].newWords, 1);
    expect(stats.last30Days.first.total, 0);
  });

  test('doğruluk oranı ve gelecek tekrar yükü (FR-83, FR-85)', () async {
    Future<void> record(
      StudyRepository study,
      int wordId,
      String type, {
      required bool correct,
    }) => study.recordAnswer(
      wordId: wordId,
      quality: correct ? 5 : 1,
      correct: correct,
      exerciseType: type,
      responseMs: 1000,
    );

    final earlier = StudyRepository(
      db,
      clock: () => now.subtract(const Duration(days: 3)),
    );
    await record(earlier, wordIds[3], 'listen', correct: true);
    final today = StudyRepository(db, clock: () => now);
    await record(today, wordIds[0], 'mc_en_tr', correct: true);
    await record(today, wordIds[1], 'mc_en_tr', correct: false);
    await record(today, wordIds[2], 'typing', correct: true);
    await ReviewRepository(db, clock: () => now).markKnown(wordIds[4]);

    final stats = await StatsRepository(db, clock: () => now).stats();

    expect(stats.accuracyByType['mc_en_tr']!.correct, 1);
    expect(stats.accuracyByType['mc_en_tr']!.total, 2);
    expect(stats.accuracyByType['mc_en_tr']!.percent, 50);
    expect(stats.accuracyByType['typing']!.percent, 100);
    expect(stats.overallAccuracy.total, 4);
    expect(stats.overallAccuracy.percent, 75);

    expect(stats.upcoming, hasLength(7));
    expect(stats.upcoming[0], 1, reason: 'gecikmiş kart bugüne sayılır');
    expect(stats.upcoming[1], 3);
    expect(stats.upcoming.fold(0, (a, b) => a + b), 4);

    final difficult = await ReviewRepository(
      db,
      clock: () => now,
    ).difficultWordIds();
    expect(difficult, {wordIds[1]});
  });

  test('ilerleme sıfırlanır, ayarlar korunur (FR-123)', () async {
    final study = StudyRepository(db, clock: () => now);
    await answer(study, wordIds[0]);
    await db
        .update(db.userProfile)
        .write(const UserProfileCompanion(dailyTarget: Value(20)));
    final progress = ProgressRepository(db, clock: () => now);
    await progress.recordUnitExam(
      (await progress.overview()).first.units.first.id,
      100,
    );

    await progress.resetProgress();

    expect(await db.select(db.reviewCards).get(), isEmpty);
    expect(await db.select(db.dailyStats).get(), isEmpty);
    final levels = await progress.overview();
    expect(levels.first.status, ProgressStatus.open);
    expect(levels.first.units.map((u) => u.status), [
      ProgressStatus.open,
      ProgressStatus.locked,
      ProgressStatus.locked,
    ]);
    final profile = await db.ensureProfile();
    expect(profile.totalXp, 0);
    expect(profile.streak, 0);
    expect(profile.dailyTarget, 20);
  });
}
