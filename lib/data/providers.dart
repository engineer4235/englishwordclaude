import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/exercise/exercise_generator.dart';
import '../domain/models/level.dart';
import '../domain/models/progress.dart';
import '../domain/models/word.dart';
import 'content/content_seeder.dart';
import 'db/app_database.dart';
import 'repositories/content_repository.dart';
import 'repositories/favorites_repository.dart';
import 'repositories/progress_repository.dart';
import 'repositories/review_repository.dart';

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
  await ContentSeeder(db).seedIfEmpty(json);
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
