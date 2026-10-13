import 'package:english_word_learning/domain/exercise/exercise.dart';
import 'package:english_word_learning/features/practice/presentation/exercise_views.dart';
import 'package:english_word_learning/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  testWidgets('eşleştirme süre dolunca biter (FR-45)', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final words = seedWords().take(5).toList();
    ExerciseOutcome? outcome;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: MatchingExerciseView(
            exercise: MatchingExercise(words: words),
            onOutcome: (o) => outcome = o,
            onContinue: () {},
          ),
        ),
      ),
    );
    expect(find.text('60 sn'), findsOneWidget);

    // Bir eşleştirme yapılır, kalanlar süre dolunca yanlış sayılır.
    await tester.tap(find.widgetWithText(OutlinedButton, words.first.lemma));
    await tester.pump();
    await tester.tap(
      find.widgetWithText(OutlinedButton, words.first.meaningTr),
    );
    await tester.pump();

    await tester.pump(const Duration(seconds: 10));
    expect(find.text('50 sn'), findsOneWidget);
    expect(outcome, isNull);

    for (var i = 0; i < 50; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    expect(outcome, isNotNull);
    expect(outcome!.answers.where((a) => a.correct), hasLength(1));
    expect(find.textContaining('Süre doldu!'), findsOneWidget);
  });
}
