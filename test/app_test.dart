import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  testWidgets('uygulama açılır ve alt menüde 5 sekme vardır', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(5));
    expect(find.widgetWithText(AppBar, 'Ana Sayfa'), findsOneWidget);
  });

  testWidgets('alt menüden Harita sekmesine geçilir', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Harita'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Harita'), findsOneWidget);
  });
}
