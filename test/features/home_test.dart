import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/repositories/study_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  testWidgets('ana ekran seri, XP, hedef ve sıradaki üniteyi gösterir', (
    tester,
  ) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();

    expect(find.text('0 gün seri'), findsOneWidget);
    expect(find.text('0 XP'), findsOneWidget);
    expect(find.text('0 seri koruması'), findsOneWidget);
    expect(find.text('0/10 yeni kelime'), findsOneWidget);
    expect(find.text('Şu an tekrar edilecek kelime yok.'), findsOneWidget);
    expect(find.text('Sıradaki ünite: Aile'), findsOneWidget);

    await tester.tap(find.text('Yeni kelimeler'));
    await tester.pumpAndSettle();
    expect(find.text('mother'), findsOneWidget);
  });

  testWidgets('tekrar zamanı gelince tekrar oturumu açılır (FR-64)', (
    tester,
  ) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // İki gün önce iki yeni kelime çalışılmış: bugün tekrarları gelmiş olur.
    await ContentSeeder(db).seedIfEmpty(seedJson);
    final words = await db.select(db.words).get();
    final past = DateTime.now().subtract(const Duration(days: 2));
    final study = StudyRepository(db, clock: () => past);
    for (final w in words.take(2)) {
      await study.recordAnswer(
        wordId: w.id,
        quality: 5,
        correct: true,
        exerciseType: 'mc_en_tr',
        responseMs: 1000,
      );
    }

    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    expect(find.text('30 XP'), findsOneWidget);
    expect(find.text('Bugün tekrar edilecek 2 kelime'), findsOneWidget);

    await tester.tap(find.text('Tekrarlara başla'));
    await tester.pumpAndSettle();
    expect(find.text('Soru 1/2'), findsOneWidget);
  });

  testWidgets('ana ekranda günün kelimesi gösterilir (FR-75)', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();

    final card = find.byKey(const ValueKey('word-of-day'));
    expect(card, findsOneWidget);
    expect(
      find.descendant(of: card, matching: find.text('Günün kelimesi')),
      findsOneWidget,
    );

    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
  });
}
