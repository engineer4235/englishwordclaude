/// Excel'de Türkçe karakterlerin doğru görünmesi için UTF-8 BOM ile
/// başlayan, satırları CRLF ile ayrılmış CSV metni üretir.
String csvDocument(List<List<String>> rows) =>
    '﻿${rows.map(csvLine).join('\r\n')}\r\n';

/// Hücreleri virgülle birleştirir; gerekenleri tırnak içine alır.
String csvLine(List<String> cells) => cells.map(csvEscape).join(',');

/// Virgül, tırnak veya satır sonu içeren değeri tırnak içine alır.
String csvEscape(String value) {
  final needsQuotes =
      value.contains(',') ||
      value.contains('"') ||
      value.contains('\n') ||
      value.contains('\r');
  if (!needsQuotes) return value;
  return '"${value.replaceAll('"', '""')}"';
}
