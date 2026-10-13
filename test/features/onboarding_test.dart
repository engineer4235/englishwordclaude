import 'package:english_word_learning/data/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  Future<void> bigScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('ilk açılışta tanıtım gösterilir ve A1 ile başlanır '
      '(FR-01..05)', (tester) async {
    await bigScreen(tester);
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db, onboarded: false));
    await tester.pumpAndSettle();

    expect(find.text('Seviye seviye ilerle'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('next')));
    await tester.pumpAndSettle();
    expect(find.text('Unutmadan öğren'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('skip')));
    await tester.pumpAndSettle();
    expect(find.text('İngilizceyi ne için öğreniyorsun?'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('goal-travel')));
    await tester.tap(find.byKey(const ValueKey('next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('target-15')));
    await tester.tap(find.byKey(const ValueKey('next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('time-none')));
    await tester.tap(find.byKey(const ValueKey('next')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('start-a1')));
    await tester.pumpAndSettle();

    expect(find.text('0/15 yeni kelime'), findsOneWidget);
    final profile = await ProfileRepository(db).get();
    expect(profile.onboardingDone, isTrue);
    expect(profile.goalType, 'travel');
    expect(profile.notifyTime, isNull);
  });

  testWidgets('tanıtımdan seviye tespit sınavına girilir (FR-05, FR-10..12)', (
    tester,
  ) async {
    await bigScreen(tester);
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db, onboarded: false));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('skip')));
    await tester.pumpAndSettle();
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(const ValueKey('next')));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.byKey(const ValueKey('start-placement')));
    await tester.pumpAndSettle();

    expect(find.text('Seviye tespit sınavı'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('placement-start')));
    await tester.pumpAndSettle();
    expect(find.text('Soru 1'), findsOneWidget);

    var asked = 0;
    while (find.byKey(const ValueKey('dont-know')).evaluate().isNotEmpty) {
      await tester.tap(find.byKey(const ValueKey('dont-know')));
      await tester.pumpAndSettle();
      asked++;
    }
    expect(asked, lessThanOrEqualTo(30));
    expect(find.textContaining('Önerilen seviye: A1'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('placement-accept')));
    await tester.pumpAndSettle();

    expect(find.text('Sıradaki ünite: Aile'), findsOneWidget);
    expect((await ProfileRepository(db).get()).onboardingDone, isTrue);
  });

  testWidgets('tanıtım tamamlanmışsa doğrudan ana sayfa açılır', (
    tester,
  ) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    await ProfileRepository(db).completeOnboarding();
    await tester.pumpWidget(testApp(db, onboarded: false));
    await tester.pumpAndSettle();

    expect(find.text('Seviye seviye ilerle'), findsNothing);
    expect(find.widgetWithText(AppBar, 'Ana Sayfa'), findsOneWidget);
  });

  testWidgets('seviye tespit sınavı profilden yeniden yapılır (FR-14)', (
    tester,
  ) async {
    await bigScreen(tester);
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('retake-placement')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('placement-start')), findsOneWidget);
  });
}
