import 'package:english_word_learning/domain/exercise/exercise_generator.dart';
import 'package:english_word_learning/domain/models/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

String _prompt(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('prompt'))).data!;

bool _shown(String key) => find.byKey(Key(key)).evaluate().isNotEmpty;

/// Sınavdaki her soruyu doğru cevaplar.
Future<int> answerAllCorrectly(
  WidgetTester tester,
  FakeTts tts,
  List<Word> words,
) async {
  var answered = 0;
  while (!_shown('score')) {
    final String answer;
    if (_shown('exercise-mc_en_tr')) {
      answer = words.firstWhere((w) => w.lemma == _prompt(tester)).meaningTr;
    } else if (_shown('exercise-mc_tr_en')) {
      answer = words.firstWhere((w) => w.meaningTr == _prompt(tester)).lemma;
    } else if (_shown('exercise-listen')) {
      answer = tts.spoken.last;
    } else if (_shown('exercise-fill_blank')) {
      final prompt = _prompt(tester);
      answer = words
          .firstWhere(
            (w) => w.examples.any((e) => blankOut(e.en, w.lemma) == prompt),
          )
          .lemma;
    } else {
      fail(
        'Beklenmeyen: ${find.byType(Text).evaluate().map((e) => (e.widget as Text).data).join(" | ")}',
      );
    }
    final option = find.widgetWithText(OutlinedButton, answer);
    await tester.ensureVisible(option);
    await tester.tap(option);
    await tester.pumpAndSettle();
    final next = find.byKey(const Key('continue'));
    await tester.ensureVisible(next);
    await tester.tap(next);
    await tester.pumpAndSettle();
    answered++;
  }
  return answered;
}

void main() {
  testWidgets('ünite sınavı %100 ile geçilir ve sıradaki ünite açılır', (
    tester,
  ) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final tts = FakeTts();
    await tester.pumpWidget(testApp(db, tts: tts));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Harita'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aile'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Ünite sınavı'));
    await tester.pumpAndSettle();
    expect(find.text('Soru 1/8'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing, reason: 'odak modu');

    final count = await answerAllCorrectly(
      tester,
      tts,
      seedWords(unitTitle: 'Aile'),
    );
    expect(count, 8);
    expect(find.text('%100'), findsOneWidget);
    expect(
      find.text('Ünite tamamlandı! Sıradaki ünite açıldı.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Haritaya dön'));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(unitLocked('Renkler'), isFalse);
  });

  testWidgets('kilitli ünite hızlı geçiş sınavıyla tamamlanır (FR-27)', (
    tester,
  ) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final tts = FakeTts();
    await tester.pumpWidget(testApp(db, tts: tts));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Harita'));
    await tester.pumpAndSettle();
    expect(unitLocked('Renkler'), isTrue);

    await tester.tap(find.text('Renkler'));
    await tester.pumpAndSettle();
    expect(find.textContaining('%90'), findsOneWidget);
    await tester.tap(find.byKey(const Key('quick-pass-start')));
    await tester.pumpAndSettle();
    expect(find.text('Hızlı geçiş sınavı: Renkler'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing, reason: 'odak modu');

    await answerAllCorrectly(tester, tts, seedWords(unitTitle: 'Renkler'));
    expect(
      find.text('Harika! Ünite tamamlandı, sonraki ünite açıldı.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Haritaya dön'));
    await tester.pumpAndSettle();
    expect(unitLocked('Renkler'), isFalse);
    expect(unitLocked('Sayılar'), isFalse);
  });

  testWidgets('cevaptan sonra geri bildirim ve Devam düğmesi gösterilir', (
    tester,
  ) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Harita'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aile'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Ünite sınavı'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(OutlinedButton).first);
    await tester.pumpAndSettle();
    final wrong = find.textContaining('Doğru cevap:').evaluate().isNotEmpty;
    final right = find.text('Doğru!').evaluate().isNotEmpty;
    expect(wrong || right, isTrue);
    expect(find.byKey(const Key('continue')), findsOneWidget);
  });
}
