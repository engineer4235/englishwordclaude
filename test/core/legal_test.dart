import 'dart:io';

import 'package:english_word_learning/core/legal/legal_markup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

/// REL-3: Gizlilik politikası ve KVKK aydınlatma metni.
void main() {
  test('basit biçim ayrıştırılır', () {
    final blocks = parseLegal('''
# Başlık

Birinci paragraf
devamı.

## Bölüm
- madde bir
- madde iki

Son paragraf.
''');
    expect(blocks.map((b) => b.runtimeType), [
      LegalTitle,
      LegalParagraph,
      LegalHeading,
      LegalBullet,
      LegalBullet,
      LegalParagraph,
    ]);
    expect(blocks[1].text, 'Birinci paragraf\ndevamı.');
    expect(blocks[3].text, 'madde bir');
  });

  test('HTML çıktısı kaçışlı ve listeler kapalı', () {
    final html = legalToHtml(parseLegal('# A & B\n\n- <x>\n- y\n\nson'));
    expect(html, contains('<h1>A &amp; B</h1>'));
    expect(html, contains('<li>&lt;x&gt;</li>'));
    expect(html.indexOf('</ul>'), lessThan(html.indexOf('<p>son</p>')));
  });

  for (final doc in LegalDocument.values) {
    group(doc.name, () {
      final source = doc.source;
      final blocks = doc.blocks;

      test('başlık, iletişim ve yürürlük tarihi var', () {
        expect(blocks.first, isA<LegalTitle>());
        expect(source, contains('engineer4235@gmail.com'));
        expect(source, contains('Yürürlük tarihi'));
      });

      test(
        'web sayfası kaynakla aynı (dart run tool/gen_legal_pages.dart)',
        () {
          final page = File('docs/${doc.webPage}').readAsStringSync();
          expect(page, legalToHtml(blocks));
        },
      );
    });
  }

  testWidgets('metinler profil ekranından açılır', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    Future<void> open(String key) async {
      final tile = find.byKey(ValueKey(key));
      await tester.scrollUntilVisible(
        tile,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(tile);
      await tester.pumpAndSettle();
    }

    await open('open-privacy');
    expect(find.byKey(const ValueKey('legal-privacy')), findsOneWidget);
    expect(find.text('Gizlilik Politikası'), findsOneWidget);
    expect(find.text('Kısaca'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await open('open-kvkk');
    expect(find.text('KVKK Aydınlatma Metni'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Haklarınız'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Haklarınız'), findsOneWidget);
  });
}
