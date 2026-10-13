// Tasarım incelemesi için ekran görüntüsü üretir. CI'da çalışmaz:
// flutter test --update-goldens screenshots/screens_test.dart
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:english_word_learning/app.dart';
import 'package:english_word_learning/core/notifications/notification_service.dart';
import 'package:english_word_learning/core/router/app_router.dart';
import 'package:english_word_learning/core/router/app_routes.dart';
import 'package:english_word_learning/core/tts/tts_service.dart';
import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/providers.dart';
import 'package:english_word_learning/data/repositories/favorites_repository.dart';
import 'package:english_word_learning/data/repositories/study_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test/helpers.dart';

Future<void> _loadFonts() async {
  final root =
      Platform.environment['FLUTTER_ROOT'] ??
      '${Platform.environment['HOME']}/flutter';
  final dir = '$root/bin/cache/artifacts/material_fonts';
  ByteData read(String name) =>
      ByteData.view(File('$dir/$name').readAsBytesSync().buffer);
  final roboto = FontLoader('Roboto');
  for (final f in [
    'Roboto-Regular.ttf',
    'Roboto-Medium.ttf',
    'Roboto-Bold.ttf',
    'Roboto-Light.ttf',
  ]) {
    if (File('$dir/$f').existsSync()) roboto.addFont(Future.value(read(f)));
  }
  await roboto.load();
  final icons = FontLoader('MaterialIcons')
    ..addFont(Future.value(read('MaterialIcons-Regular.otf')));
  await icons.load();
}

Future<AppDatabase> _demoDb() async {
  final db = memoryDatabase();
  final seeder = ContentSeeder(db);
  await seeder.seedIfEmpty(appContentJson);
  await seeder.syncRelations(appContentJson);
  await db.ensureProfile();
  await db
      .update(db.userProfile)
      .write(
        const UserProfileCompanion(
          onboardingDone: Value(true),
          dailyTarget: Value(5),
        ),
      );
  final words = await db.select(db.words).get();
  final now = DateTime.now();
  var w = 0;
  for (var day = 12; day >= 0; day--) {
    if (day == 4 || day == 9) continue;
    final study = StudyRepository(
      db,
      clock: () => now.subtract(Duration(days: day, hours: 1)),
    );
    for (var i = 0; i < 4 + day % 3; i++) {
      await study.recordAnswer(
        wordId: words[w++].id,
        quality: i == 1 ? 2 : 5,
        correct: i != 1,
        exerciseType: ['mc_en_tr', 'mc_tr_en', 'listen', 'typing'][i % 4],
        responseMs: 1500,
      );
    }
    await study.addStudyTime(const Duration(minutes: 6));
  }
  final fav = FavoritesRepository(db);
  for (final i in [0, 3, 7]) {
    await fav.toggle(words[i].id);
  }
  return db;
}

Widget _app(AppDatabase db) => ProviderScope(
  overrides: [
    appDatabaseProvider.overrideWithValue(db),
    appStartupProvider.overrideWith((ref) async {}),
    ttsServiceProvider.overrideWithValue(FakeTts()),
    notificationServiceProvider.overrideWithValue(FakeNotifications()),
  ],
  child: const EnglishWordApp(),
);

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 30; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _shot(WidgetTester tester, String name) async {
  await _settle(tester);
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('shots/$name.png'),
  );
}

void _go(WidgetTester tester, String path) {
  ProviderScope.containerOf(
    tester.element(find.byType(MaterialApp)),
  ).read(routerProvider).go(path);
}

void main() {
  setUpAll(_loadFonts);

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  testWidgets('ekranlar', (tester) async {
    phone(tester);
    final db = await tester.runAsync(_demoDb);
    addTearDown(db!.close);
    await tester.pumpWidget(_app(db));
    await _shot(tester, '01_ana_ekran');

    _go(tester, AppRoutes.levelMap);
    await _shot(tester, '02_seviye_haritasi');

    final unit = (await tester.runAsync(
      () => db.select(db.units).get(),
    ))!.first;
    _go(tester, AppRoutes.unit(unit.id));
    await _shot(tester, '03_kelime_karti');

    _go(tester, AppRoutes.unitPractice(unit.id));
    await _shot(tester, '04_alistirma');

    _go(tester, AppRoutes.words);
    await _shot(tester, '05_kelimelerim');

    _go(tester, AppRoutes.stats);
    await _shot(tester, '06_istatistik');
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -900));
    await _shot(tester, '07_istatistik_alt');

    _go(tester, AppRoutes.profile);
    await _shot(tester, '08_profil');
  });

  testWidgets('karanlık tema', (tester) async {
    phone(tester);
    final db = await tester.runAsync(_demoDb);
    addTearDown(db!.close);
    await tester.runAsync(
      () => db
          .update(db.userProfile)
          .write(const UserProfileCompanion(themeMode: Value('dark'))),
    );
    await tester.pumpWidget(_app(db));
    await _shot(tester, '09_ana_ekran_karanlik');
  });

  testWidgets('tanıtım', (tester) async {
    phone(tester);
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.runAsync(
      () => ContentSeeder(db).seedIfEmpty(appContentJson),
    );
    await tester.pumpWidget(_app(db));
    await _shot(tester, '00_tanitim');
  });
}
