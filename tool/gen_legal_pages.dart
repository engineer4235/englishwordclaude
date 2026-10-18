// Yasal metinlerin web sayfalarını üretir (REL-3).
//
// Kaynak: lib/core/legal/legal_texts.dart  →  Çıktı: docs/*.html (GitHub Pages)
//
//   dart run tool/gen_legal_pages.dart
import 'dart:io';

import 'package:english_word_learning/core/legal/legal_markup.dart';

void main() {
  for (final doc in LegalDocument.values) {
    File('docs/${doc.webPage}').writeAsStringSync(legalToHtml(doc.blocks));
    stdout.writeln('docs/${doc.webPage}');
  }
}
