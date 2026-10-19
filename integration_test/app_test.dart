import 'dart:io';

import 'package:english_word_learning/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Gerçek cihazda / emülatörde uçtan uca akış ve ölçümler:
///
/// - NFR-01: Soğuk açılış (ilk ekranın görünmesi) < 2 sn.
/// - NFR-06: Yeni kullanıcı ilk derse 90 sn içinde başlar.
/// - NFR-02: Ekran geçişleri < 100 ms tepki, animasyonlar 60 fps.
/// - NFR-11: Aynı test Android ve iOS'ta çalışır (CI: `device.yml`).
///
/// Çalıştırma (uygulama verisi temizken):
///
///     flutter test integration_test -d <cihaz>
///
/// Süre sınırları emülatörlerde yazılımla çizim yüzünden aşılabildiğinden
/// yalnız `--dart-define=STRICT_PERF=true` verildiğinde (gerçek cihaz)
/// zorunludur; aksi hâlde ölçümler raporlanır.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const strict = bool.fromEnvironment('STRICT_PERF');
  final report = <String, Object>{};

  /// [finder] görünene kadar kare çizer; [timeout] içinde görünmezse hata.
  Future<void> pumpUntil(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final end = DateTime.now().add(timeout);
    while (finder.evaluate().isEmpty) {
      if (DateTime.now().isAfter(end)) {
        final texts = [
          for (final e in find.byType(Text).evaluate())
            (e.widget as Text).data ?? '',
        ].where((t) => t.isNotEmpty).take(40).join(' | ');
        throw TestFailure('Görünmedi: $finder — Ekrandaki metinler: $texts');
      }
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  /// Ekranda gerçekten dokunulabilir olan öğeye dokunur. Tanıtım gibi
  /// sayfalı ekranlarda görünmeyen sayfaların öğeleri de ağaçta bulunduğundan
  /// yalnız isabet alan öğe aranır.
  Future<void> tap(WidgetTester tester, Finder finder) async {
    await pumpUntil(tester, finder);
    await tester.ensureVisible(finder.first);
    await tester.pumpAndSettle();
    final target = finder.hitTestable();
    await pumpUntil(tester, target);
    await tester.tap(target.first);
    await tester.pumpAndSettle();
    // Teşhis için her adımdan sonra ekrandaki metinler yazılır.
    final texts = [
      for (final e in find.byType(RichText).hitTestable().evaluate())
        (e.widget as RichText).text.toPlainText(),
    ].where((t) => t.trim().isNotEmpty).take(12).join(' | ');
    // ignore: avoid_print
    print('[adım] ${finder.describeMatch(Plurality.one)} -> $texts');
  }

  Finder nav(String label) => find.descendant(
    of: find.byType(NavigationBar),
    matching: find.text(label),
  );

  void check(String name, num value, num limit) {
    report[name] = value;
    // ignore: avoid_print
    print('$name: $value (sınır $limit)');
    if (strict) expect(value, lessThan(limit), reason: name);
  }

  testWidgets('ilk açılış, ilk ders ve ekran geçişleri', (tester) async {
    final total = Stopwatch()..start();
    await tester.pumpWidget(const ProviderScope(child: EnglishWordApp()));

    // İlk kurulumda tanıtım, daha önce kurulduysa ana sayfa açılır.
    final skip = find.byKey(const ValueKey('skip'));
    await pumpUntil(
      tester,
      find.byWidgetPredicate((w) {
        return w.key == const ValueKey('skip') || w is NavigationBar;
      }),
    );
    check('soguk_acilis_ms', total.elapsedMilliseconds, 2000);

    if (skip.evaluate().isNotEmpty) {
      // Tanıtım atlanır, hedef varsayılan, hatırlatma yok (izin penceresi
      // açılmasın), A1'den başlanır.
      await tap(tester, skip);
      await tap(tester, find.byKey(const ValueKey('next')));
      await tap(tester, find.byKey(const ValueKey('next')));
      await tap(tester, find.byKey(const ValueKey('time-none')));
      await tap(tester, find.byKey(const ValueKey('next')));
      await tap(tester, find.byKey(const ValueKey('start-a1')));
    }
    await tap(tester, find.text('Yeni kelimeler'));
    await pumpUntil(tester, find.text('mother'));
    check('ilk_derse_kadar_ms', total.elapsedMilliseconds, 90000);

    // Sekmeler arasında gezin: tepki süresi ve kare süreleri. Kelime ekranı
    // tam ekransa önce geri dönülür.
    if (nav('Harita').evaluate().isEmpty) {
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
    }
    var slowest = 0;
    await binding.watchPerformance(() async {
      for (final tab in [
        'Harita',
        'Kelimelerim',
        'İstatistik',
        'Profil',
        'Ana Sayfa',
      ]) {
        await pumpUntil(tester, nav(tab));
        final sw = Stopwatch()..start();
        await tester.tap(nav(tab));
        await tester.pump();
        sw.stop();
        if (sw.elapsedMilliseconds > slowest) slowest = sw.elapsedMilliseconds;
        await tester.pumpAndSettle();
      }
    }, reportKey: 'gecis_kareleri');
    check('en_yavas_gecis_ms', slowest, 100);

    final frames = binding.reportData?['gecis_kareleri'];
    if (frames is Map) {
      final build = frames['90th_percentile_frame_build_time_millis'];
      final raster = frames['90th_percentile_frame_rasterizer_time_millis'];
      if (build is num) check('kare_build_p90_ms', build, 16.7);
      if (raster is num) check('kare_raster_p90_ms', raster, 16.7);
    }
    binding.reportData = {...?binding.reportData, 'olcumler': report};
    // ignore: avoid_print
    print('Platform: ${Platform.operatingSystem} — ölçümler: $report');
  });
}
