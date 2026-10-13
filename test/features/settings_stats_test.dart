import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/repositories/study_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  Future<void> bigScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('istatistik ekranı öğrenilenleri ve aktiviteyi gösterir '
      '(FR-80..82)', (tester) async {
    await bigScreen(tester);
    final db = memoryDatabase();
    addTearDown(db.close);
    await ContentSeeder(db).seedIfEmpty(seedJson);
    final words = await db.select(db.words).get();
    final study = StudyRepository(db);
    for (final w in words.take(3)) {
      await study.recordAnswer(
        wordId: w.id,
        quality: 5,
        correct: true,
        exerciseType: 'mc_en_tr',
        responseMs: 1000,
      );
    }

    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('İstatistik'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('stats-learned')), findsOneWidget);
    expect(find.text('3 kelime çalışıldı'), findsOneWidget);
    expect(find.text('3 yeni kelime, 0 tekrar, 0 dakika'), findsOneWidget);
    expect(find.byKey(const ValueKey('stats-level-A1')), findsOneWidget);

    await tester.tap(find.text('30 gün'));
    await tester.pumpAndSettle();
    expect(find.text('3 yeni kelime, 0 tekrar, 0 dakika'), findsOneWidget);
  });

  testWidgets('ayarlar kaydedilir ve uygulanır (FR-120, FR-121)', (
    tester,
  ) async {
    await bigScreen(tester);
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Koyu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('İngiliz'));
    await tester.pumpAndSettle();

    final profile = await db.ensureProfile();
    expect(profile.dailyTarget, 15);
    expect(profile.themeMode, 'dark');
    expect(profile.accent, 'uk');
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);

    await tester.tap(find.text('Ana Sayfa'));
    await tester.pumpAndSettle();
    expect(find.text('0/15 yeni kelime'), findsOneWidget);
  });

  testWidgets('ilerleme onayla sıfırlanır (FR-123)', (tester) async {
    await bigScreen(tester);
    final db = memoryDatabase();
    addTearDown(db.close);
    await ContentSeeder(db).seedIfEmpty(seedJson);
    final word = (await db.select(db.words).get()).first;
    await StudyRepository(db).recordAnswer(
      wordId: word.id,
      quality: 5,
      correct: true,
      exerciseType: 'mc_en_tr',
      responseMs: 1000,
    );

    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('reset-progress')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vazgeç'));
    await tester.pumpAndSettle();
    expect(await db.select(db.reviewCards).get(), hasLength(1));

    await tester.tap(find.byKey(const ValueKey('reset-progress')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('reset-confirm')));
    await tester.pumpAndSettle();

    expect(await db.select(db.reviewCards).get(), isEmpty);
    expect(find.text('İlerleme sıfırlandı.'), findsOneWidget);
  });
}
