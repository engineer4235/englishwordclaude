import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

/// EWL-337: Görsel kalite kontrolü.
///
/// Ana ekranların ekran görüntüsü (golden) testleri ve küçük telefon / tablet
/// boyutlarında taşma kontrolü. Görüntüler `test/golden/goldens/` altındadır;
/// bilerek yapılan bir tasarım değişikliğinden sonra şu komutla yenilenir:
///
///     flutter test --update-goldens test/golden
void main() {
  /// Ekran görüntüleri her gün aynı çıksın diye sabit bir gün.
  final fixedNow = DateTime(2026, 10, 19, 10);

  setUpAll(loadAppFonts);

  Future<void> tapNav(WidgetTester tester, String tab) async {
    await tester.tap(
      find.descendant(of: find.byType(NavigationBar), matching: find.text(tab)),
    );
    await tester.pumpAndSettle();
  }

  final screens = <String, Future<void> Function(WidgetTester)>{
    'home': (t) async {},
    'map': (t) => tapNav(t, 'Harita'),
    'words': (t) => tapNav(t, 'Kelimelerim'),
    'stats': (t) => tapNav(t, 'İstatistik'),
    'profile': (t) => tapNav(t, 'Profil'),
  };

  Future<void> open(
    WidgetTester tester, {
    required Size size,
    Brightness brightness = Brightness.light,
    double textScale = 1,
    bool onboarded = true,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.platformBrightnessTestValue = brightness;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db, onboarded: onboarded, now: fixedNow));
    await tester.pumpAndSettle();
  }

  Future<void> snapshot(WidgetTester tester, String name) => expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('goldens/$name.png'),
  );

  const phone = Size(390, 844);
  const smallPhone = Size(320, 568);
  const tablet = Size(1024, 1366);

  group('telefon', () {
    for (final brightness in Brightness.values) {
      for (final screen in screens.entries) {
        testWidgets('${screen.key} (${brightness.name})', (tester) async {
          await open(tester, size: phone, brightness: brightness);
          await screen.value(tester);
          await snapshot(tester, '${screen.key}_${brightness.name}');
        });
      }
    }

    testWidgets('kelime kartı', (tester) async {
      await open(tester, size: phone);
      await tapNav(tester, 'Harita');
      await tester.ensureVisible(find.text('Aile'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aile'));
      await tester.pumpAndSettle();
      await snapshot(tester, 'word_card_light');
    });

    testWidgets('tanıtım', (tester) async {
      await open(tester, size: phone, onboarded: false);
      await snapshot(tester, 'onboarding_light');
    });
  });

  group('küçük telefon, büyük yazı', () {
    for (final screen in screens.entries) {
      testWidgets('${screen.key} taşmaz', (tester) async {
        await open(tester, size: smallPhone, textScale: 1.3);
        await screen.value(tester);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('ana sayfa görüntüsü', (tester) async {
      await open(tester, size: smallPhone, textScale: 1.3);
      await snapshot(tester, 'home_small_text130');
    });
  });

  group('tablet', () {
    for (final screen in screens.entries) {
      testWidgets('${screen.key} taşmaz', (tester) async {
        await open(tester, size: tablet);
        await screen.value(tester);
        expect(tester.takeException(), isNull);
      });
    }

    for (final name in ['home', 'map']) {
      testWidgets('$name görüntüsü', (tester) async {
        await open(tester, size: tablet);
        await screens[name]!(tester);
        await snapshot(tester, '${name}_tablet');
      });
    }
  });
}

/// Uygulama yazı tipini (Lexend) ve Material simgelerini yükler; yüklenmezse
/// testlerde tüm yazılar kutu olarak çizilir.
Future<void> loadAppFonts() async {
  Future<ByteData> bytes(File f) async =>
      ByteData.view((await f.readAsBytes()).buffer);

  final lexend = FontLoader('Lexend');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    lexend.addFont(bytes(File('assets/fonts/Lexend-$weight.ttf')));
  }
  await lexend.load();

  final root = Platform.environment['FLUTTER_ROOT'];
  if (root == null) return;
  final icons = File(
    '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (icons.existsSync()) {
    await (FontLoader('MaterialIcons')..addFont(bytes(icons))).load();
  }
}
