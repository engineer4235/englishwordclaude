import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// NFR-12: Arayüz metinleri koda gömülmez, ARB dosyalarından gelir.
void main() {
  test('arayüz kodunda sabit metin yok (NFR-12)', () {
    // Text('...') ya da Text("...") içinde harf geçen, değişken olmayan metin.
    final literal = RegExp(
      r'''Text\(\s*(['"])(?!\$)[^'"]*[A-Za-zÇĞİÖŞÜçğıöşü]''',
    );
    final offenders = <String>[];
    for (final dir in ['lib/features', 'lib/core/widgets', 'lib/app.dart']) {
      final entity = FileSystemEntity.isDirectorySync(dir)
          ? Directory(dir).listSync(recursive: true)
          : [File(dir)];
      for (final file in entity.whereType<File>()) {
        if (!file.path.endsWith('.dart')) continue;
        final lines = file.readAsLinesSync();
        for (var i = 0; i < lines.length; i++) {
          if (literal.hasMatch(lines[i])) {
            offenders.add('${file.path}:${i + 1}: ${lines[i].trim()}');
          }
        }
      }
    }
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
