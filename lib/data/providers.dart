import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/notifications/notification_plan.dart';

import '../domain/daily/word_of_day.dart';
import '../domain/exercise/exercise_generator.dart';
import '../domain/models/home_summary.dart';
import '../domain/models/level.dart';
import '../domain/models/progress.dart';
import '../domain/models/stats.dart';
import '../domain/models/word.dart';
import '../domain/placement/placement_exam.dart';
import '../domain/search/word_search.dart';
import '../domain/srs/card_state.dart';
import 'content/content_seeder.dart';
import 'db/app_database.dart';
import 'repositories/badge_repository.dart';
import 'repositories/content_repository.dart';
import 'repositories/favorites_repository.dart';
import 'repositories/notes_repository.dart';
import 'repositories/profile_repository.dart';
import 'repositories/progress_repository.dart';
import 'repositories/review_repository.dart';
import 'repositories/stats_repository.dart';
import 'repositories/study_repository.dart';

/// Uygulamayla gelen içerik paketi.
const seedContentAsset = 'assets/content/seed_content.json';

/// Veritabanı tek örnek olarak tutulur ve sağlayıcı kapanınca kapatılır.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// İlk açılışta içerik paketini veritabanına yükler.
final appStartupProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final json = await rootBundle.loadString(seedContentAsset);
  final seeder = ContentSeeder(db);
  // Güncellemeyle gelen yeni üniteler mevcut kurulumlara eklenir (CNT-5).
  if (!await seeder.seedIfEmpty(json)) await seeder.addMissingUnits(json);
  await seeder.syncRelations(json);
});

final contentRepositoryProvider = Provider<ContentRepository>(
  (ref) => DriftContentRepository(ref.watch(appDatabaseProvider)),
);

final reviewRepositoryProvider = Provider<ReviewRepository>(
  (ref) => ReviewRepository(ref.watch(appDatabaseProvider)),
);

final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => ProgressRepository(ref.watch(appDatabaseProvider)),
);

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(ref.watch(appDatabaseProvider)),
);

final notesRepositoryProvider = Provider<NotesRepository>(
  (ref) => NotesRepository(ref.watch(appDatabaseProvider)),
);

/// Bir kelimenin eş anlamlı, zıt anlamlı ve aynı ailedeki kelimeleri
/// (FR-33).
final wordRelationsProvider = FutureProvider.family<WordRelationSet, int>((
  ref,
  wordId,
) async {
  await ref.watch(appStartupProvider.future);
  return ref.watch(contentRepositoryProvider).getRelations(wordId);
});

/// Bir kelimenin kişisel notu (FR-36).
final wordNoteProvider = FutureProvider.family<String?, int>((
  ref,
  wordId,
) async {
  await ref.watch(appStartupProvider.future);
  return ref.watch(notesRepositoryProvider).get(wordId);
});

final levelsProvider = FutureProvider<List<Level>>((ref) async {
  await ref.watch(appStartupProvider.future);
  return ref.watch(contentRepositoryProvider).getLevels();
});

/// Seviye haritası verisi (FR-25).
final levelOverviewProvider = FutureProvider<List<LevelOverview>>((ref) async {
  await ref.watch(appStartupProvider.future);
  return ref.watch(progressRepositoryProvider).overview();
});

final unitWordsProvider = FutureProvider.family<List<Word>, int>((
  ref,
  unitId,
) async {
  await ref.watch(appStartupProvider.future);
  return ref.watch(contentRepositoryProvider).getWords(unitId);
});

final unitTitleProvider = FutureProvider.family<String, int>((
  ref,
  unitId,
) async {
  final levels = await ref.watch(levelOverviewProvider.future);
  for (final level in levels) {
    for (final unit in level.units) {
      if (unit.id == unitId) return unit.title;
    }
  }
  return '';
});

final favoriteIdsProvider = FutureProvider<Set<int>>((ref) async {
  await ref.watch(appStartupProvider.future);
  return ref.watch(favoritesRepositoryProvider).ids();
});

final exerciseGeneratorProvider = Provider<ExerciseGenerator>(
  (ref) => ExerciseGenerator(),
);

/// Bir seviyenin tüm kelimeleri (çeldirici havuzu ve seviye sınavı için).
final levelWordsProvider = FutureProvider.family<List<Word>, int>((
  ref,
  levelId,
) async {
  await ref.watch(appStartupProvider.future);
  final content = ref.watch(contentRepositoryProvider);
  final words = <Word>[];
  for (final unit in await content.getUnits(levelId)) {
    words.addAll(await content.getWords(unit.id));
  }
  return words;
});

/// Seviye sınavına girme koşulları (FR-23, FR-24).
final levelExamEligibilityProvider =
    FutureProvider.family<LevelExamEligibility, int>((ref, levelId) async {
      await ref.watch(levelOverviewProvider.future);
      return ref
          .watch(progressRepositoryProvider)
          .levelExamEligibility(levelId);
    });

final studyRepositoryProvider = Provider<StudyRepository>(
  (ref) => StudyRepository(ref.watch(appDatabaseProvider)),
);

/// Ana ekran özeti (FR-64, FR-65, FR-70, FR-71).
final homeSummaryProvider = FutureProvider<HomeSummary>((ref) async {
  await ref.watch(appStartupProvider.future);
  return ref.watch(studyRepositoryProvider).summary();
});

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(appDatabaseProvider)),
);

/// Tanıtım tamamlandı mı (FR-01..05). Tamamlanmadıysa yönlendirici
/// kullanıcıyı tanıtım ekranına götürür.
class OnboardingStatus extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    await ref.watch(appStartupProvider.future);
    final profile = await ref.watch(profileRepositoryProvider).get();
    return profile.onboardingDone;
  }

  Future<void> complete() async {
    await ref.read(profileRepositoryProvider).completeOnboarding();
    state = const AsyncData(true);
  }
}

final onboardingStatusProvider = AsyncNotifierProvider<OnboardingStatus, bool>(
  OnboardingStatus.new,
);

/// Seviye tespit sınavının soru havuzları (FR-11).
final placementLevelsProvider = FutureProvider<List<PlacementLevel>>((
  ref,
) async {
  final levels = await ref.watch(levelsProvider.future);
  return [
    for (final level in levels)
      PlacementLevel(
        level,
        await ref.watch(levelWordsProvider(level.id).future),
      ),
  ];
});

/// Kullanıcı ayarları (FR-120..122).
class ProfileSettings extends AsyncNotifier<UserProfileRow> {
  @override
  Future<UserProfileRow> build() async {
    await ref.watch(appStartupProvider.future);
    return ref.watch(profileRepositoryProvider).get();
  }

  Future<void> save(UserProfileCompanion changes) async {
    final updated = await ref.read(profileRepositoryProvider).update(changes);
    state = AsyncData(updated);
    ref.invalidate(homeSummaryProvider);
  }
}

final profileSettingsProvider =
    AsyncNotifierProvider<ProfileSettings, UserProfileRow>(ProfileSettings.new);

final statsRepositoryProvider = Provider<StatsRepository>(
  (ref) => StatsRepository(ref.watch(appDatabaseProvider)),
);

/// İstatistik ekranı verisi (FR-80, FR-81).
final statsProvider = FutureProvider<LearningStats>((ref) async {
  await ref.watch(appStartupProvider.future);
  return ref.watch(statsRepositoryProvider).stats();
});

/// Kelimelerim ekranındaki tüm kelimeler; seviye, durum ve favori bilgisiyle
/// (FR-90).
final wordEntriesProvider = FutureProvider<List<WordEntry>>((ref) async {
  final levels = await ref.watch(levelOverviewProvider.future);
  final favorites = await ref.watch(favoriteIdsProvider.future);
  final words = await ref.watch(contentRepositoryProvider).getAllWords();
  final states = await ref.watch(reviewRepositoryProvider).allStates();
  final difficult = await ref
      .watch(reviewRepositoryProvider)
      .difficultWordIds();
  final levelOfUnit = {
    for (final l in levels)
      for (final u in l.units) u.id: l.level.code,
  };
  return [
    for (final w in words)
      WordEntry(
        word: w,
        levelCode: levelOfUnit[w.unitId] ?? '',
        state: states[w.id] ?? CardState.newCard,
        favorite: favorites.contains(w.id),
        difficult: difficult.contains(w.id),
      ),
  ];
});

/// Günün kelimesi: açık seviyelerdeki kelimelerden seçilir (FR-75).
final wordOfDayProvider = FutureProvider<Word?>((ref) async {
  final levels = await ref.watch(levelOverviewProvider.future);
  final words = await ref.watch(contentRepositoryProvider).getAllWords();
  final openUnits = {
    for (final l in levels)
      if (l.status != ProgressStatus.locked)
        for (final u in l.units) u.id,
  };
  final candidates = [
    for (final w in words)
      if (openUnits.contains(w.unitId)) w,
  ];
  return pickWordOfDay(candidates.isEmpty ? words : candidates, DateTime.now());
});

/// Ayarlara ve bugünkü duruma göre planlanan bildirimler (FR-100..102).
final notificationPlanProvider = FutureProvider<NotificationPlan>((ref) async {
  final profile = await ref.watch(profileSettingsProvider.future);
  final summary = await ref.watch(homeSummaryProvider.future);
  final quietStart = ClockTime.tryParse(profile.quietStart);
  final quietEnd = ClockTime.tryParse(profile.quietEnd);
  return planNotifications(
    now: DateTime.now(),
    reminderEnabled: profile.reminderEnabled,
    reminderTime: profile.notifyTime,
    streakWarningEnabled: profile.streakWarningEnabled,
    streak: summary.streak,
    goalMetToday: summary.goalMet,
    quietHours:
        profile.quietHoursEnabled && quietStart != null && quietEnd != null
        ? QuietHours(quietStart, quietEnd)
        : null,
  );
});

final badgeRepositoryProvider = Provider<BadgeRepository>(
  (ref) => BadgeRepository(ref.watch(appDatabaseProvider)),
);

/// Kazanılan rozetler: kod → kazanılma zamanı (FR-73).
final earnedBadgesProvider = FutureProvider<Map<String, DateTime>>((ref) async {
  await ref.watch(appStartupProvider.future);
  final badges = ref.watch(badgeRepositoryProvider);
  await badges.check();
  return badges.earned();
});
