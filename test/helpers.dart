import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:english_word_learning/app.dart';
import 'package:english_word_learning/core/growth/review_prompt.dart';
import 'package:english_word_learning/core/growth/share_service.dart';
import 'package:english_word_learning/core/notifications/notification_plan.dart';
import 'package:english_word_learning/core/notifications/notification_service.dart';
import 'package:english_word_learning/core/tts/tts_service.dart';
import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/providers.dart';
import 'package:english_word_learning/domain/models/word.dart';
import 'package:english_word_learning/domain/placement/placement_pool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Testlerde kullanılan sabit içerik paketi (3 A1 ünitesi, 24 kelime).
/// Uygulamanın asıl içeriği büyüdükçe testler etkilenmesin diye ayrıdır.
final seedJson = File('test/fixtures/seed_content.json').readAsStringSync();

/// Uygulamayla gelen asıl içerik paketi.
final appContentJson = File(seedContentAsset).readAsStringSync();

/// Seviye tespit sınavının soru havuzu (asıl dosya).
final placementPool = PlacementPool.parse(
  File(placementPoolAsset).readAsStringSync(),
);

AppDatabase memoryDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}

class FakeTts implements TtsService {
  final spoken = <String>[];

  @override
  Future<void> speak(String text) async => spoken.add(text);
}

class FakeShare implements ShareService {
  final shared = <String>[];

  @override
  Future<void> shareText(String text) async => shared.add(text);
}

class FakeReview implements ReviewRequester {
  int requests = 0;

  @override
  Future<void> request() async => requests++;
}

class FakeNotifications implements NotificationService {
  final plans = <NotificationPlan>[];
  int permissionRequests = 0;
  bool grant = true;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return grant;
  }

  @override
  Future<void> apply(NotificationPlan plan, NotificationTexts texts) async =>
      plans.add(plan);
}

/// Tanıtımı tamamlamış kullanıcı.
class _Onboarded extends OnboardingStatus {
  @override
  Future<bool> build() async => true;
}

/// Bellek içi veritabanı ve sahte TTS ile uygulama. [onboarded] `false`
/// verilirse tanıtım ekranı gösterilir; [now] verilirse uygulama saati o ana
/// sabitlenir.
Widget testApp(
  AppDatabase db, {
  FakeTts? tts,
  FakeNotifications? notifications,
  FakeShare? share,
  FakeReview? review,
  Widget? child,
  bool onboarded = true,
  DateTime? now,
}) {
  return ProviderScope(
    overrides: [
      if (onboarded) onboardingStatusProvider.overrideWith(_Onboarded.new),
      if (now != null) clockProvider.overrideWithValue(() => now),
      appDatabaseProvider.overrideWithValue(db),
      appStartupProvider.overrideWith((ref) async {
        final seeder = ContentSeeder(db);
        await seeder.seedIfEmpty(seedJson);
        await seeder.syncRelations(seedJson);
      }),
      placementPoolProvider.overrideWith((ref) async => placementPool),
      ttsServiceProvider.overrideWithValue(tts ?? FakeTts()),
      notificationServiceProvider.overrideWithValue(
        notifications ?? FakeNotifications(),
      ),
      shareServiceProvider.overrideWithValue(share ?? FakeShare()),
      reviewRequesterProvider.overrideWithValue(review ?? FakeReview()),
    ],
    child: child ?? const EnglishWordApp(),
  );
}

/// İçerik paketindeki kelimeler (veritabanı kimlikleri yükleme sırasıyla aynı).
List<Word> seedWords({String? unitTitle}) {
  final data = jsonDecode(seedJson) as Map<String, dynamic>;
  var id = 0;
  var unitId = 0;
  final words = <Word>[];
  for (final unit in (data['units'] as List).cast<Map<String, dynamic>>()) {
    unitId++;
    for (final w in (unit['words'] as List).cast<Map<String, dynamic>>()) {
      id++;
      if (unitTitle != null && unit['title'] != unitTitle) continue;
      words.add(
        Word(
          id: id,
          unitId: unitId,
          lemma: w['lemma'] as String,
          partOfSpeech: w['pos'] as String,
          meaningTr: w['tr'] as String,
          ipa: w['ipa'] as String?,
          examples: [
            for (final e in (w['examples'] as List).cast<List<dynamic>>())
              Example(en: e[0] as String, tr: e[1] as String),
          ],
        ),
      );
    }
  }
  return words;
}

/// Ünite satırında kilit simgesi var mı.
bool unitLocked(String title) => find
    .descendant(
      of: find.ancestor(of: find.text(title), matching: find.byType(ListTile)),
      matching: find.byIcon(Icons.lock_outline),
    )
    .evaluate()
    .isNotEmpty;
