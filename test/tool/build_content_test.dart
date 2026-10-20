import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/build_content.dart';

/// EWL-105 (CNT-5): İçerik derleme aracı.
void main() {
  test('içerik paketi kaynak dosyalarla güncel', () {
    final built = buildContent(Directory(contentDir));
    expect(
      built == File(outputPath).readAsStringSync(),
      isTrue,
      reason: 'dart run tool/build_content.dart çalıştırın',
    );
  });

  group('hatalı kaynak', () {
    late Directory dir;

    setUp(() {
      dir = Directory.systemTemp.createTempSync('content');
      File('${dir.path}/meta.json').writeAsStringSync(
        '{"version": 1, "levels": [{"code": "A1", "title": "Başlangıç"}]}',
      );
    });
    tearDown(() => dir.deleteSync(recursive: true));

    void level(String body) =>
        File('${dir.path}/A1.txt').writeAsStringSync(body);

    const ok = 'cat|/kæt/|noun|kedi|A cat.|Bir kedi.|My cat.|Kedim.';

    test('geçerli kaynak derlenir', () {
      level('## Hayvanlar | animals | pets\n$ok\n');
      final json = buildContent(dir);
      expect(json, contains('"lemma": "cat"'));
      expect(json, contains('"icon": "pets"'));
    });

    test('yinelenen kelime reddedilir', () {
      level(
        '## Hayvanlar | animals |\n$ok\n${ok.replaceFirst('cat', 'Cat')}\n',
      );
      expect(() => buildContent(dir), throwsA(isA<ContentError>()));
    });

    test('eksik örnek reddedilir', () {
      level('## Hayvanlar | animals |\ncat|/kæt/|noun|kedi|A cat.|Bir kedi.\n');
      expect(() => buildContent(dir), throwsA(isA<ContentError>()));
    });

    test('bilinmeyen sözcük türü reddedilir', () {
      level('## Hayvanlar | animals |\n${ok.replaceFirst('noun', 'nun')}\n');
      expect(() => buildContent(dir), throwsA(isA<ContentError>()));
    });

    test('bilinmeyen kelimeye ilişki reddedilir', () {
      level('## Hayvanlar | animals |\n$ok\n');
      File('${dir.path}/relations.txt').writeAsStringSync('cat|dog|synonym\n');
      expect(() => buildContent(dir), throwsA(isA<ContentError>()));
    });
  });
}
