import 'package:english_word_learning/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uygulama açılır ve alt menüde 5 sekme vardır', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: EnglishWordApp()));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(5));
    expect(find.widgetWithText(AppBar, 'Ana Sayfa'), findsOneWidget);
  });

  testWidgets('alt menüden Harita sekmesine geçilir', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: EnglishWordApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Harita'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Harita'), findsOneWidget);
  });
}
