import 'dart:io';

import 'package:drift/native.dart';
import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/repositories/study_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

/// NFR-03 ve REL-2: Öğrenme, tekrar, sınav ve seviye tespiti internetsiz
/// çalışır; ders ortasında kapanan uygulamada ilerleme korunur.
///
/// Kontrol listesi:
/// 1. Bağımlılıklarda ağ paketi yok, kodda ağ çağrısı yok.
/// 2. "Uçak modunda" (her bağlantı denemesi hata verir ve sayılır) ders,
///    tekrar, ünite sınavı ve seviye tespit sınavı sonuna kadar yapılır.
/// 3. Ders ortasında uygulama kapanıp açılınca verilen cevaplar, XP ve
///    ünite durumu yerindedir.
void main() {
  test('bağımlılıklarda ve kodda ağ erişimi yok (NFR-03)', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final deps = pubspec.substring(
      pubspec.indexOf('dependencies:'),
      pubspec.indexOf('dev_dependencies:'),
    );
    const network = [
      'http:',
      'dio:',
      'firebase',
      'supabase',
      'connectivity',
      'web_socket',
      'grpc',
      'graphql',
    ];
    for (final package in network) {
      expect(deps.contains(package), isFalse, reason: package);
    }

    final calls = RegExp(
      r'HttpClient|Socket\.|WebSocket|package:http/|package:dio/|NetworkImage|Image\.network',
    );
    final offenders = [
      for (final f in Directory('lib').listSync(recursive: true))
        if (f is File &&
            f.path.endsWith('.dart') &&
            calls.hasMatch(f.readAsStringSync()))
          f.path,
    ];
    expect(offenders, isEmpty);
  });

  testWidgets('uçak modunda ders, tekrar ve sınavlar tamamlanır (REL-2)', (
    tester,
  ) async {
    _bigScreen(tester);
    final network = _Airplane()..install();
    addTearDown(network.uninstall);
    final db = memoryDatabase();
    addTearDown(db.close);

    // İki gün önce çalışılmış iki kelime: bugün tekrarları gelmiş olur.
    await ContentSeeder(db).seedIfEmpty(seedJson);
    final words = await db.select(db.words).get();
    final past = DateTime.now().subtract(const Duration(days: 2));
    for (final w in words.take(2)) {
      await StudyRepository(db, clock: () => past).recordAnswer(
        wordId: w.id,
        quality: 5,
        correct: true,
        exerciseType: 'mc_en_tr',
        responseMs: 1000,
      );
    }

    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();

    // Tekrar oturumu.
    await _tap(tester, find.text('Tekrarlara başla'));
    await _finishSession(tester);
    await _tap(tester, find.text('Ana sayfaya dön'));

    // Yeni kelimeler dersi.
    await _tap(tester, find.text('Yeni kelimeler'));
    await _openPractice(tester);
    await _finishSession(tester);
    await _tap(tester, find.text('Haritaya dön'));

    // Ünite sınavı.
    await _tap(tester, find.text('Aile'));
    await _tap(tester, find.byTooltip('Ünite sınavı'));
    await _finishSession(tester);
    await _tap(tester, find.text('Haritaya dön'));

    // Seviye tespit sınavı.
    await _tap(tester, find.text('Profil'));
    await _tap(tester, find.byKey(const ValueKey('retake-placement')));
    await _tap(tester, find.byKey(const ValueKey('placement-start')));
    var asked = 0;
    while (find.byKey(const ValueKey('dont-know')).evaluate().isNotEmpty) {
      await _tap(tester, find.byKey(const ValueKey('dont-know')));
      expect(++asked, lessThanOrEqualTo(30));
    }
    expect(find.byKey(const ValueKey('placement-accept')), findsOneWidget);

    expect(network.attempts, isEmpty, reason: 'ağa çıkılmamalı');
    expect(
      (await db.select(db.reviewLogs).get()).length,
      greaterThan(2),
      reason: 'cevaplar yerel veritabanına yazıldı',
    );
  });

  testWidgets('ders ortasında kapanan uygulama ilerlemeyi korur (REL-2)', (
    tester,
  ) async {
    _bigScreen(tester);
    final dir = Directory.systemTemp.createTempSync('ewl_rel2_');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/app.sqlite');

    var db = AppDatabase(NativeDatabase(file));
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Yeni kelimeler'));
    await _openPractice(tester);
    for (var i = 0; i < 3; i++) {
      await _answerOne(tester);
    }
    final logs = (await db.select(db.reviewLogs).get()).length;
    final xp = (await db.ensureProfile()).totalXp;
    expect(logs, greaterThan(0));

    // Uygulama ders bitmeden kapanır; bellekte hiçbir şey kalmaz.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await db.close();

    db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);
    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();

    expect(await db.select(db.reviewLogs).get(), hasLength(logs));
    expect(await db.select(db.reviewCards).get(), isNotEmpty);
    expect((await db.ensureProfile()).totalXp, xp);
    expect(find.text('$xp XP'), findsOneWidget);
    expect(find.text('Sıradaki ünite: Aile'), findsOneWidget);
  });
}

void _bigScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  expect(finder, findsWidgets);
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

/// Ünite ekranındaki kelime kartlarını geçip alıştırmayı açar.
Future<void> _openPractice(WidgetTester tester) async {
  var cards = 0;
  while (find.text('Alıştırmaya başla').evaluate().isEmpty) {
    await _tap(tester, find.text('Sonraki'));
    expect(++cards, lessThan(40));
  }
  await _tap(tester, find.text('Alıştırmaya başla'));
}

bool _shown(String key) => find.byKey(Key(key)).evaluate().isNotEmpty;

/// Ekrandaki alıştırmayı (doğru ya da yanlış) cevaplar ve devam eder.
Future<void> _answerOne(WidgetTester tester) async {
  if (_shown('exercise-matching')) {
    // Süre dolana kadar beklenir; eşleşmeyenler yanlış sayılır.
    for (var i = 0; i <= 60; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
  } else if (_shown('exercise-typing')) {
    await tester.enterText(find.byKey(const Key('typing-field')), 'x');
    await tester.testTextInput.receiveAction(TextInputAction.done);
  } else if (_shown('exercise-scramble')) {
    var i = 0;
    while (find.byKey(Key('letter-$i')).evaluate().isNotEmpty) {
      await tester.ensureVisible(find.byKey(Key('letter-$i')));
      await tester.tap(find.byKey(Key('letter-$i')));
      await tester.pump();
      i++;
    }
  } else {
    final exercise = find.byWidgetPredicate(
      (w) =>
          w.key is ValueKey<String> &&
          (w.key! as ValueKey<String>).value.startsWith('exercise-'),
    );
    expect(exercise, findsOneWidget);
    final option = find
        .descendant(of: exercise, matching: find.byType(OutlinedButton))
        .first;
    await tester.ensureVisible(option);
    await tester.tap(option);
  }
  await tester.pumpAndSettle();
  final next = find.byKey(const Key('continue'));
  await tester.ensureVisible(next);
  await tester.tap(next);
  await tester.pumpAndSettle();
}

/// Oturumu sonuç ekranına kadar götürür.
Future<void> _finishSession(WidgetTester tester) async {
  var answered = 0;
  while (!_shown('score')) {
    await _answerOne(tester);
    expect(++answered, lessThan(80));
  }
}

/// Her bağlantı denemesini kaydeder ve hata verir.
class _Airplane extends HttpOverrides {
  final attempts = <String>[];
  HttpOverrides? _previous;

  void install() {
    _previous = HttpOverrides.current;
    HttpOverrides.global = this;
  }

  void uninstall() => HttpOverrides.global = _previous;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    attempts.add('HttpClient');
    throw const SocketException('Uçak modu');
  }
}
