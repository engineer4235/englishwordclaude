import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

/// NFR-06: Yeni kullanıcı ilk dersine 90 saniye içinde başlayabilmelidir.
///
/// Süre cihazda ölçülür; burada en kısa yolun kaç dokunuş sürdüğü ve her
/// adımın beklemeden açıldığı denetlenir. Adım başına cömert bir 10 saniye
/// okuma ve karar süresiyle bile 6 dokunuş 60 saniyenin altında kalır.
void main() {
  testWidgets('ilk açılıştan ilk kelime kartına 6 dokunuşta varılır', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final db = memoryDatabase();
    addTearDown(db.close);

    var taps = 0;
    Future<void> tap(Finder finder) async {
      expect(finder, findsOneWidget);
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
      await tester.tap(finder);
      await tester.pumpAndSettle();
      taps++;
    }

    await tester.pumpWidget(testApp(db, onboarded: false));
    await tester.pumpAndSettle();

    // Tanıtım sayfaları atlanır; hedef, günlük kelime sayısı ve hatırlatma
    // saati varsayılan değerleriyle geçilir.
    await tap(find.byKey(const ValueKey('skip')));
    await tap(find.byKey(const ValueKey('next')));
    await tap(find.byKey(const ValueKey('next')));
    await tap(find.byKey(const ValueKey('next')));
    await tap(find.byKey(const ValueKey('start-a1')));

    // Ana sayfadan ilk ders.
    await tap(find.text('Yeni kelimeler'));
    expect(find.text('mother'), findsOneWidget);

    expect(taps, lessThanOrEqualTo(6));
    const secondsPerStep = 10;
    expect(taps * secondsPerStep, lessThan(90));
  });
}
