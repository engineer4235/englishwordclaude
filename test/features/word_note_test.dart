import 'package:english_word_learning/features/lesson/presentation/word_card.dart';
import 'package:english_word_learning/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  testWidgets('kelime kartına kişisel not eklenir (FR-36)', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = memoryDatabase();
    addTearDown(db.close);
    final word = seedWords().firstWhere((w) => w.lemma == 'mother');

    await tester.pumpWidget(
      testApp(
        db,
        child: MaterialApp(
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(body: WordCard(word: word)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Not ekle'), findsOneWidget);
    expect(find.byKey(const Key('note-text')), findsNothing);

    await tester.tap(find.byKey(const Key('note-edit')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('note-field')), 'mom ile aynı');
    await tester.tap(find.byKey(const Key('note-save')));
    await tester.pumpAndSettle();

    expect(find.text('mom ile aynı'), findsOneWidget);
    expect(find.text('Notu düzenle'), findsOneWidget);
  });
}
