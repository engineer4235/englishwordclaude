import 'package:english_word_learning/features/lesson/presentation/word_card.dart';
import 'package:english_word_learning/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

/// EWL-45 (FR-32): Kelime kartında somut kelimenin görseli gösterilir.
void main() {
  Future<void> open(
    WidgetTester tester,
    String lemma, {
    double scale = 1,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final db = memoryDatabase();
    addTearDown(db.close);
    final word = seedWords().firstWhere((w) => w.lemma == lemma);
    await tester.pumpWidget(
      testApp(
        db,
        child: MaterialApp(
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: Scaffold(body: WordCard(word: word)),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('somut kelimede görsel var', (tester) async {
    await open(tester, 'baby');
    expect(find.byKey(const ValueKey('word-image')), findsOneWidget);
    expect(find.text('👶'), findsOneWidget);
  });

  testWidgets('görseli olmayan kelimede kutu yok', (tester) async {
    await open(tester, 'mother');
    expect(find.byKey(const ValueKey('word-image')), findsNothing);
  });

  testWidgets('görsel ekran okuyucuya okunmaz', (tester) async {
    final handle = tester.ensureSemantics();
    await open(tester, 'baby');
    expect(find.bySemanticsLabel('👶'), findsNothing);
    handle.dispose();
  });

  testWidgets('2 kat yazı boyutunda taşma yok', (tester) async {
    await open(tester, 'family', scale: 2);
    expect(find.byKey(const ValueKey('word-image')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
