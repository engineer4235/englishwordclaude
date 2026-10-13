import 'package:english_word_learning/domain/exercise/exercise.dart';
import 'package:english_word_learning/features/practice/presentation/exercise_views.dart';
import 'package:english_word_learning/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  final word = seedWords().firstWhere((w) => w.lemma == 'mother');

  Future<List<ExerciseOutcome>> pump(
    WidgetTester tester,
    List<String> letters,
  ) async {
    final outcomes = <ExerciseOutcome>[];
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: ScrambleExerciseView(
            exercise: ScrambleExercise(target: word, letters: letters),
            tts: FakeTts(),
            onOutcome: outcomes.add,
            onContinue: () {},
          ),
        ),
      ),
    );
    return outcomes;
  }

  testWidgets('harfler doğru sıraya dizilince doğru sayılır (FR-47)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    // "mother" harfleri: r e h t o m
    final outcomes = await pump(tester, ['r', 'e', 'h', 't', 'o', 'm']);
    expect(find.text('Harfleri doğru sıraya diz'), findsOneWidget);

    // Yanlış bir harf seçilip geri alınır.
    await tester.tap(find.byKey(const Key('letter-0')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('picked-0')));
    await tester.pump();
    expect(find.byKey(const Key('letter-0')), findsOneWidget);

    for (final i in [5, 4, 3, 2, 1, 0]) {
      await tester.tap(find.byKey(Key('letter-$i')));
      await tester.pump();
    }
    expect(outcomes, hasLength(1));
    expect(outcomes.single.allCorrect, isTrue);
    expect(find.byKey(const Key('continue')), findsOneWidget);
  });

  testWidgets('yanlış sıra yanlış sayılır ve doğrusu gösterilir', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final outcomes = await pump(tester, ['r', 'e', 'h', 't', 'o', 'm']);
    for (var i = 0; i < 6; i++) {
      await tester.tap(find.byKey(Key('letter-$i')));
      await tester.pump();
    }
    expect(outcomes.single.allCorrect, isFalse);
    expect(find.textContaining('mother'), findsWidgets);
  });
}
