import 'package:english_word_learning/core/legal/licenses.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

/// EWL-101 (CNT-1): Kullanılan bileşenlerin lisansları uygulamada görülür.
void main() {
  test('Lexend yazı tipinin lisansı kayıtlı', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerAppLicenses();
    final entries = await LicenseRegistry.licenses.toList();
    final lexend = entries.where((e) => e.packages.contains('Lexend'));
    expect(lexend, isNotEmpty);
    final text = lexend.first.paragraphs.map((p) => p.text).join(' ');
    expect(text, contains('SIL OPEN FONT LICENSE'));
  });

  testWidgets('profilden lisans sayfası açılır', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    final tile = find.byKey(const ValueKey('open-licenses'));
    await tester.scrollUntilVisible(
      tile,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Açık kaynak lisansları'), findsOneWidget);
    // Son satır alt gezinme çubuğunun altında kalabildiğinden doğrudan
    // dokunma yerine satırın eylemi çağrılır.
    tester.widget<ListTile>(tile).onTap!();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(LicensePage), findsOneWidget);
  });
}
