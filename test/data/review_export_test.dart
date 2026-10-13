import 'dart:convert';
import 'dart:io';

import 'package:english_word_learning/data/content/review_export.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CSV her kelime için bir satır ve kaçışlı alanlar içerir (CNT-7)', () {
    final json = jsonEncode({
      'units': [
        {
          'level': 'A1',
          'title': 'Aile',
          'words': [
            {
              'lemma': 'mother',
              'ipa': '/ˈmʌðər/',
              'pos': 'noun',
              'tr': 'anne',
              'examples': [
                ['Hi, "Mom".', 'Merhaba, anne.'],
              ],
            },
          ],
        },
      ],
    });
    final csv = buildReviewCsv(json);
    expect(csv.startsWith('﻿'), isTrue);
    final lines = csv.substring(1).trimRight().split('\r\n');
    expect(lines, hasLength(2));
    expect(lines.first, startsWith('Seviye,Ünite,Kelime'));
    expect(
      lines.last,
      'A1,Aile,mother,/ˈmʌðər/,noun,anne,"Hi, ""Mom"".",'
      '"Merhaba, anne.",,,,',
    );
  });

  test('docs/content_review.csv içerik paketiyle güncel', () {
    final json = File('assets/content/seed_content.json').readAsStringSync();
    final file = File('docs/content_review.csv');
    expect(
      file.readAsBytesSync(),
      utf8.encode(buildReviewCsv(json)),
      reason: 'dart run tool/export_review.dart ile yeniden üretin',
    );
    final units = (jsonDecode(json) as Map<String, dynamic>)['units'] as List;
    final words = [for (final u in units) ...((u as Map)['words'] as List)];
    final lines = file.readAsStringSync().trimRight().split('\r\n');
    expect(lines, hasLength(words.length + 1));
  });
}
