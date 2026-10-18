import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

/// NFR-07: Ekran okuyucu etiketleri, dokunma alanı, renk kontrastı (WCAG AA)
/// ve sistem yazı boyutu. Her ekran küçük bir telefon boyutunda, açık ve
/// koyu temada denetlenir.
void main() {
  Future<void> tapNav(WidgetTester tester, String tab) async {
    await tester.tap(
      find.descendant(of: find.byType(NavigationBar), matching: find.text(tab)),
    );
    await tester.pumpAndSettle();
  }

  /// [finder] ile bulunan ilk öğeye dokunur; henüz oluşturulmamışsa (örneğin
  /// büyük yazıda ekranın altında kaldıysa) önce dikey listeyi kaydırır.
  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    final vertical = find.byWidgetPredicate(
      (w) =>
          w is Scrollable &&
          axisDirectionToAxis(w.axisDirection) == Axis.vertical,
    );
    for (var i = 0; i < 30 && finder.evaluate().isEmpty; i++) {
      await tester.drag(vertical.first, const Offset(0, -200));
      await tester.pumpAndSettle();
    }
    final target = finder.first;
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  final screens = <String, Future<void> Function(WidgetTester)>{
    'Ana Sayfa': (t) async {},
    'Harita': (t) => tapNav(t, 'Harita'),
    'Kelimelerim': (t) => tapNav(t, 'Kelimelerim'),
    'İstatistik': (t) => tapNav(t, 'İstatistik'),
    'Profil': (t) => tapNav(t, 'Profil'),
    'Ünite': (t) async {
      await tapNav(t, 'Harita');
      await tapAndSettle(t, find.text('Aile'));
    },
    'Sınav': (t) async {
      await tapNav(t, 'Harita');
      await tapAndSettle(t, find.text('Aile'));
      await tapAndSettle(t, find.byTooltip('Ünite sınavı'));
    },
    'Sınav geri bildirimi': (t) async {
      await tapNav(t, 'Harita');
      await tapAndSettle(t, find.text('Aile'));
      await tapAndSettle(t, find.byTooltip('Ünite sınavı'));
      await tapAndSettle(t, find.byType(OutlinedButton));
    },
    'Kelime kartı': (t) async {
      await tapNav(t, 'Kelimelerim');
      await tapAndSettle(
        t,
        find.byWidgetPredicate(
          (w) => w is ListTile && '${w.key}'.contains("'word-"),
        ),
      );
    },
    'Yeni kelimeler': (t) async {
      await tapAndSettle(t, find.text('Yeni kelimeler'));
    },
    'Alıştırma': (t) async {
      await tapNav(t, 'Harita');
      await tapAndSettle(t, find.text('Aile'));
      while (find.text('Alıştırmaya başla').evaluate().isEmpty) {
        await tapAndSettle(t, find.text('Sonraki'));
      }
      await tapAndSettle(t, find.text('Alıştırmaya başla'));
    },
    'Listelerim': (t) async {
      await tapNav(t, 'Kelimelerim');
      await tapAndSettle(t, find.byKey(const ValueKey('open-lists')));
    },
    'Kelime ekleme': (t) async {
      await tapNav(t, 'Kelimelerim');
      await tapAndSettle(t, find.byKey(const ValueKey('add-word')));
    },
    'Seviye tespit': (t) async {
      await tapNav(t, 'Profil');
      await tapAndSettle(t, find.byKey(const ValueKey('retake-placement')));
    },
    'Seviye tespit sorusu': (t) async {
      await tapNav(t, 'Profil');
      await tapAndSettle(t, find.byKey(const ValueKey('retake-placement')));
      await tapAndSettle(t, find.byKey(const ValueKey('placement-start')));
    },
    'Seviye tespit sonucu': (t) async {
      await tapNav(t, 'Profil');
      await tapAndSettle(t, find.byKey(const ValueKey('retake-placement')));
      await tapAndSettle(t, find.byKey(const ValueKey('placement-start')));
      while (find.byKey(const ValueKey('dont-know')).evaluate().isNotEmpty) {
        await tapAndSettle(t, find.byKey(const ValueKey('dont-know')));
      }
    },
    'Tanıtım başlangıç': (t) async {
      await tapAndSettle(t, find.byKey(const ValueKey('skip')));
      for (var i = 0; i < 3; i++) {
        await tapAndSettle(t, find.byKey(const ValueKey('next')));
      }
    },
    'Tanıtım': (t) async {},
    'Tanıtım hedef': (t) async {
      await tapAndSettle(t, find.byKey(const ValueKey('skip')));
    },
  };

  Future<void> open(
    WidgetTester tester,
    Future<void> Function(WidgetTester) go, {
    Brightness brightness = Brightness.light,
    double textScale = 1,
    bool onboarded = true,
  }) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    tester.platformDispatcher.platformBrightnessTestValue = brightness;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db, onboarded: onboarded));
    await tester.pumpAndSettle();
    await go(tester);
  }

  final guidelines = {
    'ekran okuyucu etiketi': labeledTapTargetGuideline,
    'Android dokunma alanı': androidTapTargetGuideline,
    'iOS dokunma alanı': iOSTapTargetGuideline,
    'renk kontrastı': textContrastGuideline,
  };

  for (final screen in screens.entries) {
    group(screen.key, () {
      for (final brightness in Brightness.values) {
        for (final g in guidelines.entries) {
          testWidgets('${g.key} (${brightness.name})', (tester) async {
            final handle = tester.ensureSemantics();
            await open(
              tester,
              screen.value,
              brightness: brightness,
              onboarded: !screen.key.startsWith('Tanıtım'),
            );
            await expectLater(tester, meetsGuideline(g.value));
            handle.dispose();
          });
        }
      }

      testWidgets('2 kat yazı boyutunda taşma yok', (tester) async {
        // Taşma olursa çerçeve hatası testi ayrıntısıyla düşürür.
        await open(
          tester,
          screen.value,
          textScale: 2,
          onboarded: !screen.key.startsWith('Tanıtım'),
        );
      });
    });
  }
}
