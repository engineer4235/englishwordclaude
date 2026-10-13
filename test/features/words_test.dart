import 'package:english_word_learning/features/lesson/presentation/word_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  testWidgets('Kelimelerim ekranında arama ve filtre (FR-90)', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Kelimelerim'));
    await tester.pumpAndSettle();
    expect(find.text('24 kelime'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('word-search')),
      'kirmizi',
    );
    await tester.pumpAndSettle();
    expect(find.text('1 kelime'), findsOneWidget);
    expect(find.text('red'), findsOneWidget);

    await tester.tap(find.text('red'));
    await tester.pumpAndSettle();
    expect(find.byType(WordCard), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('filter-favorites')));
    await tester.pumpAndSettle();
    expect(find.text('Sonuç bulunamadı.'), findsOneWidget);
  });
}
