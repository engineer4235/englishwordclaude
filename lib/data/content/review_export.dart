import 'dart:convert';

/// Çevirilerin editör tarafından kontrolü için içerik paketini CSV tablosuna
/// dönüştürür (CNT-7).
///
/// Her satır bir kelimedir. Editör "Düzeltme" ve "Not" sütunlarını doldurur.
/// Dosya Excel'de Türkçe karakterlerin doğru görünmesi için UTF-8 BOM ile
/// başlar.
String buildReviewCsv(String contentJson) {
  final data = jsonDecode(contentJson) as Map<String, dynamic>;
  final rows = <List<String>>[
    reviewCsvHeader,
    for (final unit in (data['units'] as List).cast<Map<String, dynamic>>())
      for (final word in (unit['words'] as List).cast<Map<String, dynamic>>())
        _row(unit, word),
  ];
  return '﻿${rows.map(_line).join('\r\n')}\r\n';
}

/// CSV başlık satırı.
const reviewCsvHeader = [
  'Seviye',
  'Ünite',
  'Kelime',
  'Okunuş',
  'Tür',
  'Anlam',
  'Örnek 1 (EN)',
  'Örnek 1 (TR)',
  'Örnek 2 (EN)',
  'Örnek 2 (TR)',
  'Düzeltme',
  'Not',
];

List<String> _row(Map<String, dynamic> unit, Map<String, dynamic> word) {
  final examples = (word['examples'] as List? ?? const [])
      .cast<List<dynamic>>();
  String example(int i, int part) =>
      i < examples.length ? examples[i][part] as String : '';
  return [
    unit['level'] as String,
    unit['title'] as String,
    word['lemma'] as String,
    word['ipa'] as String? ?? '',
    word['pos'] as String? ?? '',
    word['tr'] as String,
    example(0, 0),
    example(0, 1),
    example(1, 0),
    example(1, 1),
    '',
    '',
  ];
}

String _line(List<String> cells) => cells.map(_escape).join(',');

String _escape(String value) {
  final needsQuotes =
      value.contains(',') ||
      value.contains('"') ||
      value.contains('\n') ||
      value.contains('\r');
  if (!needsQuotes) return value;
  return '"${value.replaceAll('"', '""')}"';
}
