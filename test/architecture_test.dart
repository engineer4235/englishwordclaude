import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// EWL-121 (NFR-10): Katmanlı mimari kuralları.
///
/// - `lib/domain`: saf Dart iş mantığı; yalnızca `dart:` kütüphanelerini ve
///   yine domain içindeki dosyaları içe aktarır (Flutter, paket, veri ya da
///   arayüz bağımlılığı yok).
/// - `lib/data`: arayüze (features, router, tema, ortak bileşenler) bağımlı
///   olmaz; Flutter'dan yalnızca `services` (varlık dosyası okuma) kullanılır.
/// - `lib/features`: veritabanına (Drift, `data/db`) doğrudan erişmez; veriyi
///   depolar ve sağlayıcılar üzerinden alır.
/// - `lib/core` (yönlendirici hariç): ekranlara bağımlı olmaz.
void main() {
  /// [dir] altındaki her Dart dosyasının içe aktardığı adresler; göreli
  /// adresler `lib/` köküne göre çözülür.
  Map<String, List<String>> importsUnder(String dir) {
    final root = Directory.current.absolute.uri.path;
    String relative(Uri uri) => uri.path.substring(root.length);
    final result = <String, List<String>>{};
    final pattern = RegExp(r'''^(?:import|export)\s+['"]([^'"]+)['"]''');
    for (final entity in Directory(dir).listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (entity.path.endsWith('.g.dart')) continue;
      final base = entity.absolute.uri;
      result[relative(base)] = [
        for (final line in entity.readAsLinesSync())
          if (pattern.firstMatch(line)?.group(1) case final target?)
            target.startsWith('package:') || target.startsWith('dart:')
                ? target
                : relative(base.resolve(target)),
      ];
    }
    return result;
  }

  List<String> violations(
    String dir,
    bool Function(String file, String import) forbidden,
  ) => [
    for (final MapEntry(key: file, value: imports) in importsUnder(dir).entries)
      for (final import in imports)
        if (forbidden(file, import)) '$file → $import',
  ];

  test('domain katmanı saf Dart', () {
    expect(
      violations(
        'lib/domain',
        (_, import) =>
            !import.startsWith('dart:') && !import.startsWith('lib/domain/'),
      ),
      isEmpty,
    );
  });

  test('veri katmanı arayüze bağımlı değil', () {
    const ui = [
      'lib/features/',
      'lib/core/router/',
      'lib/core/theme/',
      'lib/core/widgets/',
    ];
    expect(
      violations(
        'lib/data',
        (_, import) =>
            ui.any(import.startsWith) ||
            (import.startsWith('package:flutter/') &&
                import != 'package:flutter/services.dart'),
      ),
      isEmpty,
    );
  });

  test('ekranlar veritabanına doğrudan erişmez', () {
    // Profil ekranı ayarları Drift'in `UserProfileCompanion` nesnesiyle
    // kaydediyor; ayar deposu ayrılınca bu istisna kaldırılmalı.
    const allowed = {'lib/features/profile/presentation/profile_screen.dart'};
    expect(
      violations(
        'lib/features',
        (file, import) =>
            !allowed.contains(file) &&
            (import.startsWith('package:drift') ||
                import.startsWith('lib/data/db/')),
      ),
      isEmpty,
    );
  });

  test('ortak katman ekranlara bağımlı değil (yönlendirici hariç)', () {
    expect(
      violations(
        'lib/core',
        (file, import) =>
            !file.startsWith('lib/core/router/') &&
            import.startsWith('lib/features/'),
      ),
      isEmpty,
    );
  });
}
