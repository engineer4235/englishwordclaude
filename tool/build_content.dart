// İçerik derleme aracı (CNT-5, EWL-105).
//
// `content/` klasöründeki düzenlenebilir kaynak dosyalarından uygulamanın
// yüklediği `assets/content/seed_content.json` paketini üretir:
//
//   dart run tool/build_content.dart          # paketi yazar
//   dart run tool/build_content.dart --check  # paket güncel değilse hata verir
//
// Kaynak biçimi `content/README.md` dosyasında anlatılır.
import 'dart:convert';
import 'dart:io';

const contentDir = 'content';
const outputPath = 'assets/content/seed_content.json';
const _posValues = {
  'noun',
  'verb',
  'adjective',
  'adverb',
  'number',
  'interjection',
};
const _relationTypes = {'synonym', 'antonym', 'family'};

/// Kaynak dosyadaki bir hata; dosya adı ve satır numarasını taşır.
class ContentError implements Exception {
  ContentError(this.file, this.line, this.message);

  final String file;
  final int line;
  final String message;

  @override
  String toString() => '$file:$line: $message';
}

/// [dir] altındaki kaynaklardan içerik paketini üretir ve JSON metnini döner.
String buildContent(Directory dir) {
  final meta = jsonDecode(
    File('${dir.path}/meta.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final levels = (meta['levels'] as List).cast<Map<String, dynamic>>();
  final units = <Map<String, dynamic>>[];
  final lemmas = <String, String>{};

  for (final level in levels) {
    final code = level['code'] as String;
    final file = File('${dir.path}/$code.txt');
    if (!file.existsSync()) continue;
    final name = '$code.txt';
    Map<String, dynamic>? unit;
    for (final (i, raw) in file.readAsLinesSync().indexed) {
      final line = raw.trimRight();
      final n = i + 1;
      if (line.isEmpty || line.startsWith('# ')) continue;
      if (line.startsWith('## ')) {
        final parts = line.substring(3).split('|').map((p) => p.trim());
        final [title, theme, icon] = parts.length == 3
            ? parts.toList()
            : throw ContentError(
                name,
                n,
                'ünite satırı: ## başlık | tema | simge',
              );
        unit = {
          'level': code,
          'title': title,
          'theme': theme,
          'icon': icon.isEmpty ? null : icon,
          'words': <Map<String, dynamic>>[],
        };
        units.add(unit);
        continue;
      }
      if (unit == null) throw ContentError(name, n, 'kelime üniteden önce');
      final f = line.split('|');
      if (f.length < 8 || f.length.isOdd) {
        throw ContentError(
          name,
          n,
          'kelime satırı: kelime|okunuş|tür|anlam|örnek|çeviri|örnek|çeviri',
        );
      }
      if ([
        for (final (k, x) in f.indexed)
          if (k != 1) x,
      ].any((x) => x.trim().isEmpty)) {
        throw ContentError(name, n, 'boş alan');
      }
      if (!_posValues.contains(f[2])) {
        throw ContentError(name, n, 'bilinmeyen sözcük türü: ${f[2]}');
      }
      final key = f[0].toLowerCase();
      if (lemmas[key] case final other?) {
        throw ContentError(name, n, '"${f[0]}" zaten var ($other)');
      }
      lemmas[key] = '$name:$n';
      (unit['words'] as List).add({
        'lemma': f[0],
        'ipa': f[1].isEmpty ? null : f[1],
        'pos': f[2],
        'tr': f[3],
        'examples': [
          for (var k = 4; k < f.length; k += 2) [f[k], f[k + 1]],
        ],
      });
    }
  }

  final relations = <List<String>>[];
  final relFile = File('${dir.path}/relations.txt');
  if (relFile.existsSync()) {
    for (final (i, raw) in relFile.readAsLinesSync().indexed) {
      final line = raw.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      final f = line.split('|');
      if (f.length != 3 || !_relationTypes.contains(f[2])) {
        throw ContentError('relations.txt', i + 1, 'kelime1|kelime2|tür');
      }
      for (final lemma in f.take(2)) {
        if (!lemmas.containsKey(lemma.toLowerCase())) {
          throw ContentError(
            'relations.txt',
            i + 1,
            'bilinmeyen kelime: $lemma',
          );
        }
      }
      relations.add(f);
    }
  }

  final content = {...meta, 'units': units, 'relations': relations};
  return '${const JsonEncoder.withIndent('  ').convert(content)}\n';
}

void main(List<String> args) {
  final String json;
  try {
    json = buildContent(Directory(contentDir));
  } on ContentError catch (e) {
    stderr.writeln(e);
    exit(1);
  }
  final out = File(outputPath);
  if (args.contains('--check')) {
    if (!out.existsSync() || out.readAsStringSync() != json) {
      stderr.writeln(
        '$outputPath güncel değil: dart run tool/build_content.dart çalıştırın.',
      );
      exit(1);
    }
    stdout.writeln('İçerik paketi güncel.');
    return;
  }
  out.writeAsStringSync(json);
  stdout.writeln('$outputPath yazıldı.');
}
