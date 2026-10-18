import 'dart:convert';

import 'legal_texts.dart';

/// Yasal metinlerin (gizlilik politikası, KVKK aydınlatma metni) basit
/// biçimi (REL-3). Aynı kaynak (legal_texts.dart) hem uygulamada gösterilir
/// hem de `tool/gen_legal_pages.dart` ile web sayfasına dönüştürülür.
///
/// Biçim: `# ` başlık, `## ` bölüm başlığı, `- ` madde; boş satırla ayrılan
/// diğer satırlar paragraftır (paragraf içindeki satır sonları korunur).
sealed class LegalBlock {
  const LegalBlock(this.text);

  final String text;
}

class LegalTitle extends LegalBlock {
  const LegalTitle(super.text);
}

class LegalHeading extends LegalBlock {
  const LegalHeading(super.text);
}

class LegalParagraph extends LegalBlock {
  const LegalParagraph(super.text);
}

class LegalBullet extends LegalBlock {
  const LegalBullet(super.text);
}

/// Uygulamadaki yasal metinler.
enum LegalDocument {
  privacy(privacyPolicyTr, 'gizlilik.html'),
  kvkk(kvkkNoticeTr, 'kvkk.html');

  const LegalDocument(this.source, this.webPage);

  /// Metnin kaynağı (bkz. legal_texts.dart).
  final String source;

  /// Ayrıştırılmış metin.
  List<LegalBlock> get blocks => parseLegal(source);

  /// GitHub Pages'te (`docs/`) yayınlanan sayfanın adı.
  final String webPage;

  /// Mağaza sayfasında ve uygulamada gösterilen herkese açık adres.
  String get url => '$webBase/$webPage';

  static const webBase = 'https://engineer4235.github.io/englishwordclaude';
}

List<LegalBlock> parseLegal(String source) {
  final blocks = <LegalBlock>[];
  final paragraph = <String>[];
  void flush() {
    if (paragraph.isEmpty) return;
    blocks.add(LegalParagraph(paragraph.join('\n')));
    paragraph.clear();
  }

  for (final raw in const LineSplitter().convert(source)) {
    final line = raw.trimRight();
    if (line.trim().isEmpty) {
      flush();
    } else if (line.startsWith('## ')) {
      flush();
      blocks.add(LegalHeading(line.substring(3).trim()));
    } else if (line.startsWith('# ')) {
      flush();
      blocks.add(LegalTitle(line.substring(2).trim()));
    } else if (line.startsWith('- ')) {
      flush();
      blocks.add(LegalBullet(line.substring(2).trim()));
    } else {
      paragraph.add(line.trim());
    }
  }
  flush();
  return blocks;
}

/// Bağımsız, sade bir HTML sayfası üretir (GitHub Pages için).
String legalToHtml(List<LegalBlock> blocks, {String lang = 'tr'}) {
  const escape = HtmlEscape(HtmlEscapeMode.element);
  String text(String s) => escape.convert(s).replaceAll('\n', '<br>\n');
  final title = blocks.whereType<LegalTitle>().firstOrNull?.text ?? '';
  final body = StringBuffer();
  var inList = false;
  for (final block in blocks) {
    if (block is LegalBullet && !inList) {
      body.writeln('<ul>');
      inList = true;
    } else if (block is! LegalBullet && inList) {
      body.writeln('</ul>');
      inList = false;
    }
    body.writeln(switch (block) {
      LegalTitle() => '<h1>${text(block.text)}</h1>',
      LegalHeading() => '<h2>${text(block.text)}</h2>',
      LegalBullet() => '<li>${text(block.text)}</li>',
      LegalParagraph() => '<p>${text(block.text)}</p>',
    });
  }
  if (inList) body.writeln('</ul>');
  return '''<!doctype html>
<html lang="$lang">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${text(title)} · Learn English at Home</title>
<style>
:root { color-scheme: light dark; --accent: #6C3CE9; }
body { font-family: system-ui, -apple-system, "Segoe UI", sans-serif; line-height: 1.6;
  max-width: 720px; margin: 0 auto; padding: 24px 16px 48px; }
h1 { color: var(--accent); line-height: 1.25; }
h2 { margin-top: 2em; }
@media (prefers-color-scheme: dark) { :root { --accent: #B9A2FF; } }
</style>
</head>
<body>
<!-- Bu dosya lib/core/legal/legal_texts.dart kaynağından üretilir:
     dart run tool/gen_legal_pages.dart -->
$body</body>
</html>
''';
}
