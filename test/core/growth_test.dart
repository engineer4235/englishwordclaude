import 'package:english_word_learning/core/growth/review_prompt.dart';
import 'package:english_word_learning/core/growth/share_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

/// Büyüme: mağaza değerlendirme isteği ve paylaşım.
void main() {
  group('ReviewPolicy', () {
    final now = DateTime(2026, 10, 20, 12);

    test('yalnız mutlu anda sorulur', () {
      expect(
        ReviewPolicy.shouldAsk(happyMoment: false, now: now, askedCount: 0),
        isFalse,
      );
      expect(
        ReviewPolicy.shouldAsk(happyMoment: true, now: now, askedCount: 0),
        isTrue,
      );
    });

    test('iki istek arasında en az 60 gün geçer', () {
      bool ask(int days) => ReviewPolicy.shouldAsk(
        happyMoment: true,
        now: now,
        askedCount: 1,
        lastAsked: now.subtract(Duration(days: days)),
      );
      expect(ask(59), isFalse);
      expect(ask(60), isTrue);
    });

    test('en fazla 3 kez sorulur', () {
      expect(
        ReviewPolicy.shouldAsk(happyMoment: true, now: now, askedCount: 3),
        isFalse,
      );
    });

    test('mutlu an: sınav geçildi ya da seri rozeti kazanıldı', () {
      expect(isHappyMoment(passed: true), isTrue);
      expect(isHappyMoment(passed: false), isFalse);
      expect(isHappyMoment(newBadges: ['streak_7']), isTrue);
      expect(isHappyMoment(newBadges: ['first_word']), isFalse);
      expect(isHappyMoment(), isFalse);
    });
  });

  group('ReviewPrompter', () {
    test('istek kaydedilir; 60 gün dolmadan tekrar sorulmaz', () async {
      final db = memoryDatabase();
      addTearDown(db.close);
      final review = FakeReview();
      var now = DateTime(2026, 10, 20);
      final prompter = ReviewPrompter(db, review, () => now);

      expect(await prompter.maybeAsk(happyMoment: true), isTrue);
      expect(review.requests, 1);

      now = now.add(const Duration(days: 10));
      expect(await prompter.maybeAsk(happyMoment: true), isFalse);
      expect(review.requests, 1);

      now = now.add(const Duration(days: 60));
      expect(await prompter.maybeAsk(happyMoment: true), isTrue);
      expect(review.requests, 2);
      expect(await db.metaValue(ReviewPrompter.askCountKey), '2');
    });

    test('mutlu an değilse hiçbir şey yapılmaz', () async {
      final db = memoryDatabase();
      addTearDown(db.close);
      final review = FakeReview();
      final prompter = ReviewPrompter(db, review, DateTime.now);
      expect(await prompter.maybeAsk(happyMoment: false), isFalse);
      expect(review.requests, 0);
      expect(await db.metaValue(ReviewPrompter.lastAskedKey), isNull);
    });
  });

  test('Android paylaşımında Play bağlantısı verilir', () {
    expect(storeLink(TargetPlatform.android), playStoreUrl);
    expect(storeLink(TargetPlatform.iOS), websiteUrl);
  });

  testWidgets('günün kelimesi paylaşılır', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final share = FakeShare();

    await tester.pumpWidget(testApp(db, share: share));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('share-word')));
    await tester.pump();
    expect(share.shared, hasLength(1));
    expect(share.shared.single, startsWith('Günün kelimesi: '));
    expect(share.shared.single, contains('Learn English at Home'));
  });

  testWidgets('profilden uygulama paylaşılır', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final share = FakeShare();
    await tester.pumpWidget(testApp(db, share: share));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    final tile = find.byKey(const ValueKey('share-app'));
    await tester.scrollUntilVisible(
      tile,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Uygulamayı paylaş'), findsOneWidget);
    tester.widget<ListTile>(tile).onTap!();
    await tester.pump();
    expect(share.shared.single, contains('Learn English at Home'));
  });
}
