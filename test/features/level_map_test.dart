import 'package:english_word_learning/data/providers.dart';
import 'package:english_word_learning/data/repositories/progress_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

Future<void> openMap(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.tap(find.text('Harita'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('haritada A1 açık, ilk ünite açık, diğerleri kilitli', (
    tester,
  ) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db));
    await openMap(tester);

    expect(find.text('Başlangıç'), findsOneWidget);
    expect(find.text('Aile'), findsOneWidget);
    expect(find.byIcon(Icons.play_circle_outline), findsWidgets);

    expect(unitLocked('Renkler'), isTrue);
  });

  testWidgets('üniteye girilir, kart gezilir ve kelime seslendirilir', (
    tester,
  ) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final tts = FakeTts();
    await tester.pumpWidget(testApp(db, tts: tts));
    await openMap(tester);

    await tester.tap(find.text('Aile'));
    await tester.pumpAndSettle();

    expect(find.text('mother'), findsOneWidget);
    expect(find.text('anne'), findsOneWidget);
    expect(find.text('1 / 8'), findsOneWidget);

    await tester.tap(find.byTooltip('Dinle').first);
    expect(tts.spoken, ['mother']);

    await tester.tap(find.text('Sonraki'));
    await tester.pumpAndSettle();
    expect(find.text('father'), findsOneWidget);
    expect(find.text('2 / 8'), findsOneWidget);
  });

  testWidgets('ünite sınavı geçilince sonraki ünite açılır (FR-22)', (
    tester,
  ) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db));
    await openMap(tester);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(Scaffold).first),
    );
    final units = (await container.read(levelOverviewProvider.future))
        .first
        .units;
    await ProgressRepository(db).recordUnitExam(units.first.id, 80);
    container.invalidate(levelOverviewProvider);
    await tester.pumpAndSettle();

    expect(unitLocked('Renkler'), isFalse);
  });
}
