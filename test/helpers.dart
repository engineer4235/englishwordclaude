import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:english_word_learning/app.dart';
import 'package:english_word_learning/core/tts/tts_service.dart';
import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Testlerde kullanılan içerik paketi.
final seedJson = File(seedContentAsset).readAsStringSync();

AppDatabase memoryDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}

class FakeTts implements TtsService {
  final spoken = <String>[];

  @override
  Future<void> speak(String text) async => spoken.add(text);
}

/// Bellek içi veritabanı ve sahte TTS ile uygulama.
Widget testApp(AppDatabase db, {FakeTts? tts, Widget? child}) {
  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      appStartupProvider.overrideWith(
        (ref) => ContentSeeder(db).seedIfEmpty(seedJson),
      ),
      ttsServiceProvider.overrideWithValue(tts ?? FakeTts()),
    ],
    child: child ?? const EnglishWordApp(),
  );
}
