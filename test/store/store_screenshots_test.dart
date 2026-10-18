import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/repositories/study_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../golden/golden_test.dart' show loadAppFonts;
import '../helpers.dart';

/// REL-4: Mağaza ekran görüntüleri (ham). Normal test çalışmasında atlanır;
/// üretmek için (bkz. docs/RELEASE.md):
///
///     flutter test --update-goldens --dart-define=STORE_SHOTS=true test/store
///     python3 tool/gen_store_images.py
///
/// Ham görüntüler 1080×1920 (360×640, 3x) olarak `test/store/raw/` altına
/// yazılır; çerçeveli ve açıklamalı mağaza görselleri `docs/store/` altına
/// üretilir.
void main() {
  const enabled = bool.fromEnvironment('STORE_SHOTS');

  setUpAll(() async {
    if (enabled) await loadAppFonts();
  });

  Future<void> open(
    WidgetTester tester, {
    Brightness brightness = Brightness.light,
  }) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 3;
    tester.platformDispatcher.platformBrightnessTestValue = brightness;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    final db = memoryDatabase();
    addTearDown(db.close);
    // Biraz ilerleme: ilk ünitenin kelimeleri bugün doğru cevaplanmış.
    await tester.runAsync(() async {
      await ContentSeeder(db).seedIfEmpty(seedJson);
      final words = await db.select(db.words).get();
      final study = StudyRepository(db);
      for (final w in words.take(8)) {
        await study.recordAnswer(
          wordId: w.id,
          quality: 5,
          correct: true,
          exerciseType: 'mc_en_tr',
          responseMs: 2500,
        );
      }
    });
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
  }

  Future<void> nav(WidgetTester tester, String tab) async {
    await tester.tap(
      find.descendant(of: find.byType(NavigationBar), matching: find.text(tab)),
    );
    await tester.pumpAndSettle();
  }

  Future<void> shot(WidgetTester tester, String name) =>
      expectLater(find.byType(MaterialApp), matchesGoldenFile('raw/$name.png'));

  testWidgets('1 ana sayfa', skip: !enabled, (tester) async {
    await open(tester);
    await shot(tester, '1_home');
  });

  testWidgets('2 harita', skip: !enabled, (tester) async {
    await open(tester);
    await nav(tester, 'Harita');
    await shot(tester, '2_map');
  });

  testWidgets('3 alıştırma', skip: !enabled, (tester) async {
    await open(tester);
    await nav(tester, 'Harita');
    await tester.ensureVisible(find.text('Aile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aile'));
    await tester.pumpAndSettle();
    final start = find.text('Alıştırmaya başla');
    for (var i = 0; i < 20 && start.evaluate().isEmpty; i++) {
      await tester.tap(find.text('Sonraki'));
      await tester.pumpAndSettle();
    }
    await tester.tap(start);
    await tester.pumpAndSettle();
    await shot(tester, '3_practice');
  });

  testWidgets('4 istatistik', skip: !enabled, (tester) async {
    await open(tester);
    await nav(tester, 'İstatistik');
    await shot(tester, '4_stats');
  });

  testWidgets('5 profil', skip: !enabled, (tester) async {
    await open(tester);
    await nav(tester, 'Profil');
    await shot(tester, '5_profile');
  });

  testWidgets('6 koyu tema', skip: !enabled, (tester) async {
    await open(tester, brightness: Brightness.dark);
    await shot(tester, '6_home_dark');
  });
}
