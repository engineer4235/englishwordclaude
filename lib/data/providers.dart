import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/level.dart';
import 'db/app_database.dart';
import 'repositories/content_repository.dart';

/// Veritabanı tek örnek olarak tutulur ve sağlayıcı kapanınca kapatılır.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final contentRepositoryProvider = Provider<ContentRepository>(
  (ref) => DriftContentRepository(ref.watch(appDatabaseProvider)),
);

final levelsProvider = FutureProvider<List<Level>>(
  (ref) => ref.watch(contentRepositoryProvider).getLevels(),
);
