import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  testWidgets('veriler CSV ve JSON olarak panoya kopyalanır (FR-124)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final copied = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied.add((call.arguments as Map)['text'] as String);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    final db = memoryDatabase();
    addTearDown(db.close);
    await ContentSeeder(db).seedIfEmpty(seedJson);
    final word = (await db.select(db.words).get()).first;
    await FavoritesRepository(db).toggle(word.id);

    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    Future<void> export(String key) async {
      final tile = find.byKey(const ValueKey('export-data'));
      await tester.scrollUntilVisible(
        tile,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(tile);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey(key)));
      await tester.pumpAndSettle();
    }

    await export('export-csv');
    expect(copied, hasLength(1));
    expect(copied.single, contains('Kelime,Anlam'));
    expect(copied.single, contains('mother,anne'));
    expect(find.text('1 kelimenin verisi panoya kopyalandı'), findsOneWidget);

    ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first))
        .removeCurrentSnackBar();
    await tester.pumpAndSettle();

    await export('export-json');
    expect(copied, hasLength(2));
    expect(copied.last, contains('"format": "english-word-learning-export"'));
    expect(copied.last, contains('"lemma": "mother"'));
  });
}
