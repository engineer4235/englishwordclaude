import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/repositories/word_list_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  void bigScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('liste oluşturulur ve kelime karttan eklenir (FR-91)', (
    tester,
  ) async {
    bigScreen(tester);
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kelimelerim'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('open-lists')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Henüz listen yok'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('new-list')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('list-name-field')), 'Aile');
    await tester.tap(find.byKey(const Key('list-name-save')));
    await tester.pumpAndSettle();
    expect(find.text('Aile'), findsOneWidget);
    expect(find.text('0 kelime'), findsOneWidget);

    // Kelime kartından listeye ekleme.
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('mother'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('add-to-list')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Aile'));
    await tester.pumpAndSettle();
    final tile = tester.widget<CheckboxListTile>(
      find.widgetWithText(CheckboxListTile, 'Aile'),
    );
    expect(tile.value, isTrue);
    final rows = await tester.runAsync(() => db.select(db.wordListItems).get());
    expect(rows, hasLength(1));
  });

  testWidgets('listeyle alıştırma başlatılır (FR-93)', (tester) async {
    bigScreen(tester);
    final db = memoryDatabase();
    addTearDown(db.close);
    await ContentSeeder(db).seedIfEmpty(seedJson);
    final words = await db.select(db.words).get();
    final repo = WordListRepository(db);
    final id = await repo.create('Zor kelimeler');
    await repo.addWord(id, words[0].id);
    await repo.addWord(id, words[1].id);

    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kelimelerim'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('open-lists')));
    await tester.pumpAndSettle();
    expect(find.text('2 kelime'), findsOneWidget);

    await tester.tap(find.byKey(ValueKey('practice-list-$id')));
    await tester.pumpAndSettle();
    expect(find.text('Zor kelimeler'), findsOneWidget);
    expect(find.text('Soru 1/6'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}
