import 'dart:io';

import 'package:english_word_learning/data/content/review_export.dart';

/// İçerik paketinden çeviri kontrol tablosunu üretir (CNT-7):
///
///     dart run tool/export_review.dart
///
/// Çıktı: docs/content_review.csv
void main() {
  final json = File('assets/content/seed_content.json').readAsStringSync();
  File('docs/content_review.csv').writeAsStringSync(buildReviewCsv(json));
  stdout.writeln('docs/content_review.csv yazıldı.');
}
