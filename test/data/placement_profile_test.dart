import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/repositories/profile_repository.dart';
import 'package:english_word_learning/data/repositories/progress_repository.dart';
import 'package:english_word_learning/domain/models/progress.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late DateTime now;

  setUp(() async {
    db = memoryDatabase();
    await ContentSeeder(db).seedIfEmpty(seedJson);
    now = DateTime(2026, 10, 13, 9);
  });

  tearDown(() => db.close());

  test('seviye tespiti alt seviyeleri tamamlar ve kelimeleri bilinen sayar '
      '(FR-12, FR-13)', () async {
    final repo = ProgressRepository(db, clock: () => now);
    final levels = await repo.overview();
    final a2 = levels[1].level;

    await repo.applyPlacement(a2.id);

    final after = await repo.overview();
    expect(after[0].status, ProgressStatus.completed);
    expect(
      after[0].units.every((u) => u.status == ProgressStatus.completed),
      isTrue,
    );
    expect(after[1].status, ProgressStatus.open);
    expect(after[2].status, ProgressStatus.locked);

    final cards = await db.select(db.reviewCards).get();
    expect(cards, hasLength(24));
    expect(cards.every((c) => c.state == 'mastered'), isTrue);
    expect(
      cards.every((c) => c.dueAt == now.add(const Duration(days: 21))),
      isTrue,
      reason: 'ara sıra kontrol tekrarına girer',
    );

    final profile = await ProfileRepository(db).get();
    expect(profile.currentLevelId, a2.id);
  });

  test('A1 seçilince hiçbir kelime bilinen sayılmaz', () async {
    final repo = ProgressRepository(db, clock: () => now);
    final a1 = (await repo.overview()).first.level;

    await repo.applyPlacement(a1.id);

    expect(await db.select(db.reviewCards).get(), isEmpty);
    final after = await repo.overview();
    expect(after.first.status, ProgressStatus.open);
    expect(after.first.units.first.status, ProgressStatus.open);
  });

  test('tanıtım seçimleri profile kaydedilir (FR-02..04)', () async {
    final profiles = ProfileRepository(db);
    expect((await profiles.get()).onboardingDone, isFalse);

    await profiles.saveOnboardingChoices(
      goal: LearningGoal.travel,
      dailyTarget: 15,
      notifyTime: null,
    );
    await profiles.completeOnboarding();

    final p = await profiles.get();
    expect(LearningGoal.fromDb(p.goalType), LearningGoal.travel);
    expect(p.dailyTarget, 15);
    expect(p.notifyTime, isNull);
    expect(p.reminderEnabled, isFalse);
    expect(p.onboardingDone, isTrue);
  });
}
