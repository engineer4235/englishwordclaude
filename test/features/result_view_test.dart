import 'package:english_word_learning/core/theme/app_theme.dart';
import 'package:english_word_learning/domain/exercise/exercise.dart';
import 'package:english_word_learning/domain/models/word.dart';
import 'package:english_word_learning/features/practice/presentation/practice_screen.dart';
import 'package:english_word_learning/features/practice/presentation/result_view.dart';
import 'package:english_word_learning/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// EWL-333: Sonuç ve kutlama ekranı.
void main() {
  const word = Word(
    id: 1,
    unitId: 1,
    lemma: 'mother',
    partOfSpeech: 'noun',
    meaningTr: 'anne',
  );

  Widget app(
    Widget child, {
    Brightness brightness = Brightness.light,
    double textScale = 1,
    bool disableAnimations = false,
  }) => MaterialApp(
    theme: brightness == Brightness.light ? AppTheme.light() : AppTheme.dark(),
    locale: const Locale('tr'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
          disableAnimations: disableAnimations,
        ),
        child: Scaffold(body: child),
      ),
    ),
  );

  const passedLevel = ResultView(
    mode: PracticeMode.levelExam,
    result: SessionResult(correct: 19, total: 20, wrongWords: [word]),
    passed: true,
    levelCode: 'A1',
    xp: 40,
    newBadges: ['level_A1', 'streak_7'],
  );

  const failedUnit = ResultView(
    mode: PracticeMode.unitExam,
    result: SessionResult(correct: 3, total: 8, wrongWords: [word, word]),
    passed: false,
    levelCode: 'A1',
    xp: 0,
  );

  testWidgets('seviye geçilince ödül, XP ve rozet kartları görünür', (
    tester,
  ) async {
    await tester.pumpWidget(app(passedLevel));
    await tester.pumpAndSettle();
    expect(find.text('%95'), findsOneWidget);
    expect(find.text('19/20 doğru'), findsOneWidget);
    expect(find.byKey(const ValueKey('xp-gained')), findsOneWidget);
    expect(find.text('+40 XP'), findsOneWidget);
    expect(find.byKey(const ValueKey('level-award')), findsOneWidget);
    expect(find.byKey(const ValueKey('new-badge-level_A1')), findsOneWidget);
    expect(find.byKey(const ValueKey('new-badge-streak_7')), findsOneWidget);
  });

  testWidgets('başarısız sınavda yanlış kelimeler bir kez listelenir', (
    tester,
  ) async {
    await tester.pumpWidget(app(failedUnit));
    await tester.pumpAndSettle();
    expect(find.text('%38'), findsOneWidget);
    expect(find.byKey(const ValueKey('xp-gained')), findsNothing);
    expect(find.byKey(const ValueKey('level-award')), findsNothing);
    expect(find.text('mother'), findsOneWidget);
  });

  testWidgets('animasyon kapalıyken her şey hemen görünür', (tester) async {
    await tester.pumpWidget(app(passedLevel, disableAnimations: true));
    await tester.pump();
    expect(find.text('%95'), findsOneWidget);
    expect(find.text('+40 XP'), findsOneWidget);
    expect(tester.hasRunningAnimations, isFalse);
  });

  for (final brightness in Brightness.values) {
    for (final view in {'geçti': passedLevel, 'kaldı': failedUnit}.entries) {
      testWidgets('renk kontrastı: ${view.key} (${brightness.name})', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(app(view.value, brightness: brightness));
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      });
    }
  }

  testWidgets('2 kat yazı boyutunda taşma yok', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app(passedLevel, textScale: 2));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('score')), findsOneWidget);
  });
}
