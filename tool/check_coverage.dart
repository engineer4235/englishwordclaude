// Birim test kapsamı denetimi (EWL-121, NFR-10).
//
// `flutter test --coverage` sonrasında `coverage/lcov.info` dosyasını okur ve
// iş mantığı katmanlarının (lib/domain, lib/data) satır kapsamını hesaplar.
// Oran eşiğin altındaysa çıkış kodu 1 olur; CI bu adımda durur.
//
//   dart run tool/check_coverage.dart            # eşik %70
//   dart run tool/check_coverage.dart --min 80
import 'dart:io';

/// Kapsama dahil edilen katmanlar.
const layers = ['lib/domain/', 'lib/data/'];

/// Üretilmiş ya da yalnızca bildirim içeren dosyalar (çalıştırılabilir mantık
/// yok): Drift kod üretimi ve tablo tanımları.
bool excluded(String path) =>
    path.endsWith('.g.dart') || path.endsWith('lib/data/db/tables.dart');

void main(List<String> args) {
  final minIndex = args.indexOf('--min');
  final min = minIndex >= 0 ? double.parse(args[minIndex + 1]) : 70.0;
  final file = File('coverage/lcov.info');
  if (!file.existsSync()) {
    stderr.writeln('coverage/lcov.info yok. Önce: flutter test --coverage');
    exit(2);
  }

  final hits = <String, (int, int)>{};
  String? current;
  for (final line in file.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      current = line.substring(3).replaceAll(r'\', '/');
      hits[current] = (0, 0);
    } else if (line.startsWith('DA:') && current != null) {
      final count = int.parse(line.substring(3).split(',')[1]);
      final (covered, total) = hits[current]!;
      hits[current] = (covered + (count > 0 ? 1 : 0), total + 1);
    }
  }

  var covered = 0;
  var total = 0;
  final rows = <(double, String)>[];
  for (final MapEntry(key: path, value: (c, t)) in hits.entries) {
    final layer = layers.any((l) => path.contains(l));
    if (!layer || excluded(path) || t == 0) continue;
    covered += c;
    total += t;
    rows.add((c / t * 100, path.substring(path.indexOf('lib/'))));
  }
  if (total == 0) {
    stderr.writeln('Kapsam verisinde domain/data dosyası bulunamadı.');
    exit(2);
  }

  rows.sort((a, b) => a.$1.compareTo(b.$1));
  for (final (percent, path) in rows.take(10)) {
    stdout.writeln('${percent.toStringAsFixed(1).padLeft(5)}%  $path');
  }
  final percent = covered / total * 100;
  stdout.writeln(
    'İş mantığı kapsamı (domain + data): ${percent.toStringAsFixed(1)}% '
    '($covered/$total satır), eşik %${min.toStringAsFixed(0)}',
  );
  if (percent < min) {
    stderr.writeln('Kapsam eşiğin altında.');
    exit(1);
  }
}
