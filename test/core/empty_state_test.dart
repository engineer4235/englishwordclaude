import 'package:english_word_learning/core/theme/app_theme.dart';
import 'package:english_word_learning/core/widgets/empty_state.dart';
import 'package:english_word_learning/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// EWL-336: Boş ve hata durumları, sayfa geçişleri.
void main() {
  Widget app(
    Widget Function(BuildContext) build, {
    Brightness brightness = Brightness.light,
    double textScale = 1,
  }) => MaterialApp(
    theme: brightness == Brightness.light ? AppTheme.light() : AppTheme.dark(),
    locale: const Locale('tr'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(body: Builder(builder: build)),
      ),
    ),
  );

  testWidgets('başlık, açıklama ve eylem düğmesi gösterilir', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      app(
        (_) => EmptyState(
          icon: Icons.search_off_rounded,
          title: 'Sonuç yok',
          message: 'Filtreleri değiştir',
          actionLabel: 'Temizle',
          actionKey: const ValueKey('act'),
          onAction: () => tapped++,
        ),
      ),
    );
    expect(find.text('Sonuç yok'), findsOneWidget);
    expect(find.text('Filtreleri değiştir'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('act')));
    expect(tapped, 1);
  });

  testWidgets('hata durumu yeniden deneme düğmesi sunar', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      app((c) => EmptyState.error(c, onRetry: () => retried = true)),
    );
    expect(
      find.text('İçerik yüklenemedi. Lütfen tekrar deneyin.'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('retry')));
    expect(retried, isTrue);
  });

  for (final brightness in Brightness.values) {
    testWidgets('kontrast ve dokunma alanı (${brightness.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        app((c) => EmptyState.error(c, onRetry: () {}), brightness: brightness),
      );
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });
  }

  testWidgets('2 kat yazıda ve kısa ekranda taşma yok', (tester) async {
    tester.view.physicalSize = const Size(720, 900);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      app(
        (_) => const EmptyState(
          icon: Icons.menu_book_rounded,
          title: 'Bu ünitede henüz kelime yok.',
          message:
              'Kelimeleri kendi listelerinde toplamak için yeni bir '
              'liste oluştur.',
        ),
        textScale: 2,
      ),
    );
    expect(tester.takeException(), isNull);
  });

  test('Android sayfa geçişi tanımlı', () {
    final builders = AppTheme.light().pageTransitionsTheme.builders;
    expect(
      builders[TargetPlatform.android],
      isA<FadeForwardsPageTransitionsBuilder>(),
    );
    expect(
      builders[TargetPlatform.iOS].runtimeType,
      const PageTransitionsTheme().builders[TargetPlatform.iOS].runtimeType,
    );
  });
}
