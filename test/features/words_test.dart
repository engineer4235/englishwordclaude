import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/repositories/favorites_repository.dart';
import 'package:english_word_learning/features/lesson/presentation/word_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  testWidgets('Kelimelerim ekranında arama ve filtre (FR-90)', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Kelimelerim'));
    await tester.pumpAndSettle();
    expect(find.text('24 kelime'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('word-search')),
      'kirmizi',
    );
    await tester.pumpAndSettle();
    expect(find.text('1 kelime'), findsOneWidget);
    expect(find.text('red'), findsOneWidget);

    await tester.tap(find.text('red'));
    await tester.pumpAndSettle();
    expect(find.byType(WordCard), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('filter-favorites')));
    await tester.pumpAndSettle();
    expect(find.text('Sonuç bulunamadı.'), findsOneWidget);

    // Boş sonuç ekranındaki düğme arama ve filtreleri temizler (EWL-336).
    await tester.tap(find.byKey(const ValueKey('clear-filters')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('no-results')), findsNothing);
    expect(find.text('24 kelime'), findsOneWidget);
  });

  testWidgets('favori kelimelerle alıştırma başlatılır (FR-93)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = memoryDatabase();
    addTearDown(db.close);
    await ContentSeeder(db).seedIfEmpty(seedJson);
    final words = await db.select(db.words).get();
    final favorites = FavoritesRepository(db);
    await favorites.toggle(words[0].id);
    await favorites.toggle(words[1].id);

    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kelimelerim'));
    await tester.pumpAndSettle();

    final difficult = tester.widget<ActionChip>(
      find.byKey(const ValueKey('practice-difficult')),
    );
    expect(difficult.onPressed, isNull, reason: 'zorlanılan kelime yok');

    await tester.tap(find.byKey(const ValueKey('practice-favorites')));
    await tester.pumpAndSettle();
    expect(find.text('Favorileri çalış'), findsOneWidget);
    // 2 yeni kelime ve her biri için 2 oturum içi tekrar (FR-62).
    expect(find.text('Soru 1/6'), findsOneWidget);
  });
}
