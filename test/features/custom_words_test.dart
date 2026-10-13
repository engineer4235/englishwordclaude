import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  void bigScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('kendi kelimeni ekleyip silebilirsin (FR-92)', (tester) async {
    bigScreen(tester);
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kelimelerim'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('add-word')));
    await tester.pumpAndSettle();
    final save = find.byKey(const Key('add-word-save'));
    expect(tester.widget<FilledButton>(save).onPressed, isNull);

    await tester.enterText(
      find.byKey(const Key('add-word-lemma')),
      'serendipity',
    );
    await tester.enterText(
      find.byKey(const Key('add-word-meaning')),
      'mutlu tesadüf',
    );
    await tester.pump();
    await tester.tap(save);
    await tester.pumpAndSettle();

    expect(find.text('"serendipity" eklendi'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('word-search')),
      'serendipity',
    );
    await tester.pumpAndSettle();
    expect(find.text('ÖZ'), findsOneWidget);
    expect(find.text('mutlu tesadüf'), findsOneWidget);

    // Aynı kelime tekrar eklenemez.
    tester
        .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger).first)
        .removeCurrentSnackBar();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('add-word')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('add-word-lemma')),
      'Serendipity',
    );
    await tester.enterText(find.byKey(const Key('add-word-meaning')), 'x');
    await tester.pump();
    await tester.tap(find.byKey(const Key('add-word-save')));
    await tester.pumpAndSettle();
    expect(find.text('Bu kelime zaten var.'), findsOneWidget);
    await tester.tap(find.text('Vazgeç'));
    await tester.pumpAndSettle();

    // Kelime kartından silme.
    await tester.tap(find.widgetWithText(ListTile, 'serendipity'));
    await tester.pumpAndSettle();
    expect(find.text('kendi kelimem'), findsOneWidget);
    await tester.tap(find.byKey(const Key('delete-word')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('delete-word-confirm')));
    await tester.pumpAndSettle();
    expect(find.text('mutlu tesadüf'), findsNothing);
    expect(find.text('Sonuç bulunamadı.'), findsOneWidget);
  });

  testWidgets('içerik kelimelerinde silme düğmesi yok', (tester) async {
    bigScreen(tester);
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kelimelerim'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('mother'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('delete-word')), findsNothing);
  });
}
