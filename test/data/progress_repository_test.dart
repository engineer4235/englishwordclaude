import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/repositories/favorites_repository.dart';
import 'package:english_word_learning/data/repositories/progress_repository.dart';
import 'package:english_word_learning/data/repositories/review_repository.dart';
import 'package:english_word_learning/domain/models/progress.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late DateTime now;
  late ProgressRepository repo;

  setUp(() async {
    db = memoryDatabase();
    await ContentSeeder(db).seedIfEmpty(seedJson);
    now = DateTime(2026, 10, 13, 9);
    repo = ProgressRepository(db, clock: () => now);
  });

  tearDown(() => db.close());

  Future<LevelOverview> a1() async => (await repo.overview()).first;

  test('başlangıçta yalnız A1 ve ilk ünitesi açık', () async {
    final levels = await repo.overview();
    expect(levels.first.status, ProgressStatus.open);
    expect(
      levels.skip(1).every((l) => l.status == ProgressStatus.locked),
      isTrue,
    );
    expect(levels.first.units.map((u) => u.status), [
      ProgressStatus.open,
      ProgressStatus.locked,
      ProgressStatus.locked,
    ]);
  });

  test('%70 altı sonraki üniteyi açmaz, %70 ve üzeri açar (kabul 2)', () async {
    final units = (await a1()).units;

    expect(await repo.recordUnitExam(units[0].id, 60), isFalse);
    var after = (await a1()).units;
    expect(after[0].status, ProgressStatus.open);
    expect(after[1].status, ProgressStatus.locked);

    expect(await repo.recordUnitExam(units[0].id, 70), isTrue);
    after = (await a1()).units;
    expect(after[0].status, ProgressStatus.completed);
    expect(after[0].bestScore, 70);
    expect(after[1].status, ProgressStatus.open);
  });

  test('hızlı geçiş: %90 altı kilitli üniteyi değiştirmez (FR-27)', () async {
    final units = (await a1()).units;
    expect(units[1].status, ProgressStatus.locked);

    expect(await repo.recordQuickPass(units[1].id, 85), isFalse);
    var after = (await a1()).units;
    expect(after[1].status, ProgressStatus.locked);
    expect(after[1].bestScore, isNull);

    expect(await repo.recordQuickPass(units[1].id, 90), isTrue);
    after = (await a1()).units;
    expect(after[1].status, ProgressStatus.completed);
    expect(after[1].bestScore, 90);
    expect(after[2].status, ProgressStatus.open);
    expect(after[0].status, ProgressStatus.open, reason: 'önceki ünite aynı');
  });

  test('seviye sınavı koşulları ve 24 saat bekleme (kabul 3, FR-24)', () async {
    final level = await a1();
    var eligibility = await repo.levelExamEligibility(level.level.id);
    expect(eligibility.canStart, isFalse);

    for (final unit in level.units) {
      await repo.recordUnitExam(unit.id, 90);
    }
    eligibility = await repo.levelExamEligibility(level.level.id);
    expect(eligibility.allUnitsCompleted, isTrue);
    expect(
      eligibility.canStart,
      isFalse,
      reason: 'kelimeler henüz öğrenilmedi',
    );

    final review = ReviewRepository(db, clock: () => now);
    for (final w in await db.select(db.words).get()) {
      await review.markKnown(w.id);
    }
    eligibility = await repo.levelExamEligibility(level.level.id);
    expect(eligibility.learnedRatio, 1);
    expect(eligibility.canStart, isTrue);

    expect(await repo.recordLevelExam(level.level.id, 70), isFalse);
    eligibility = await repo.levelExamEligibility(level.level.id);
    expect(eligibility.retryAvailableAt, now.add(const Duration(hours: 24)));
    expect(eligibility.canStart, isFalse);

    now = now.add(const Duration(hours: 25));
    expect((await repo.levelExamEligibility(level.level.id)).canStart, isTrue);

    expect(await repo.recordLevelExam(level.level.id, 85), isTrue);
    final levels = await repo.overview();
    expect(levels[0].status, ProgressStatus.completed);
    expect(levels[1].status, ProgressStatus.open);
  });

  test('favori ekle/çıkar (FR-35)', () async {
    final favorites = FavoritesRepository(db);
    final wordId = (await db.select(db.words).get()).first.id;
    expect(await favorites.toggle(wordId), isTrue);
    expect(await favorites.ids(), {wordId});
    expect(await favorites.toggle(wordId), isFalse);
    expect(await favorites.ids(), isEmpty);
  });
}
