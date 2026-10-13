import 'package:english_word_learning/features/lesson/presentation/word_card.dart';
import 'package:english_word_learning/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  testWidgets('kelime kartında zıt anlamlı kelime gösterilir (FR-33)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = memoryDatabase();
    addTearDown(db.close);
    final tts = FakeTts();
    final word = seedWords().firstWhere((w) => w.lemma == 'mother');

    await tester.pumpWidget(
      testApp(
        db,
        tts: tts,
        child: MaterialApp(
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(body: WordCard(word: word)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final antonyms = find.byKey(const Key('relations-antonym'));
    expect(antonyms, findsOneWidget);
    expect(find.text('Zıt anlamlı'), findsOneWidget);
    final chip = find.descendant(
      of: antonyms,
      matching: find.textContaining('father'),
    );
    expect(chip, findsOneWidget);
    expect(find.byKey(const Key('relations-synonym')), findsNothing);

    await tester.tap(chip);
    await tester.pump();
    expect(tts.spoken, contains('father'));
  });
}
