import 'dart:io';

import 'package:english_word_learning/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    // Tanıtım durumu veritabanından okunana kadar alt menü kısa süre
    // görünebilir; bu yüzden tanıtımın ya da ana sayfanın kendisi beklenir.
    final home = find.text('Yeni kelimeler');
    await pumpUntil(
      tester,
      find.byWidgetPredicate(
        (w) =>
            w.key == const ValueKey('skip') ||
            (w is Text && w.data == 'Yeni kelimeler'),
      ),
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
    await tap(tester, home);
    await pumpUntil(tester, find.text('mother'));
    check('ilk_derse_kadar_ms', total.elapsedMilliseconds, 90000);

    // Sekmeler arasında gezin: tepki süresi ve kare süreleri. Kelime ekranı
    // tam ekransa önce geri dönülür.
    if (nav('Harita').evaluate().isEmpty) {
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
    }
    var slowest = 0;
    // Kare süreleri motorun kendi ölçümünden (FrameTiming) toplanır; VM
    // servisi gerektirmez, her cihazda çalışır.
    final timings = <FrameTiming>[];
    void onTimings(List<FrameTiming> t) => timings.addAll(t);
    SchedulerBinding.instance.addTimingsCallback(onTimings);
    await (() async {
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
    })();
    SchedulerBinding.instance.removeTimingsCallback(onTimings);
    check('en_yavas_gecis_ms', slowest, 100);

    double p90(Iterable<Duration> d) {
      final ms = [for (final x in d) x.inMicroseconds / 1000]..sort();
      return ms.isEmpty ? 0 : ms[((ms.length - 1) * 0.9).round()];
    }

    report['kare_sayisi'] = timings.length;
    check('kare_build_p90_ms', p90(timings.map((t) => t.buildDuration)), 16.7);
    check(
      'kare_raster_p90_ms',
      p90(timings.map((t) => t.rasterDuration)),
      16.7,
    );
    binding.reportData = {...?binding.reportData, 'olcumler': report};
    // ignore: avoid_print
    print('Platform: ${Platform.operatingSystem} — ölçümler: $report');
  });
}
