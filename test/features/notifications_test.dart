import 'package:drift/drift.dart' show Value;
import 'package:english_word_learning/core/notifications/notification_plan.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  Future<void> bigScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('açılışta bildirim planı kurulur, sessiz saat uygulanır '
      '(FR-100, FR-102)', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    await ProfileRepository(db).update(
      const UserProfileCompanion(
        notifyTime: Value('07:00'),
        quietHoursEnabled: Value(true),
      ),
    );
    final notifications = FakeNotifications();
    await tester.pumpWidget(testApp(db, notifications: notifications));
    await tester.pumpAndSettle();

    expect(notifications.plans, isNotEmpty);
    expect(notifications.plans.last.dailyReminder, const ClockTime(8, 0));
  });

  testWidgets('hatırlatma açılınca bildirim izni istenir (FR-04)', (
    tester,
  ) async {
    await bigScreen(tester);
    final db = memoryDatabase();
    addTearDown(db.close);
    final notifications = FakeNotifications()..grant = false;
    await tester.pumpWidget(testApp(db, notifications: notifications));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('setting-reminder')));
    await tester.pumpAndSettle();
    expect(notifications.permissionRequests, 0, reason: 'kapatırken sorulmaz');
    await tester.tap(find.byKey(const ValueKey('setting-reminder')));
    await tester.pumpAndSettle();

    expect(notifications.permissionRequests, 1);
    expect(find.textContaining('Bildirim izni verilmedi'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('setting-quiet')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('setting-quiet-start')), findsOneWidget);
    expect((await db.ensureProfile()).quietHoursEnabled, isTrue);
  });

  testWidgets('tanıtımda saat seçilince izin istenir (FR-04)', (tester) async {
    await bigScreen(tester);
    final db = memoryDatabase();
    addTearDown(db.close);
    final notifications = FakeNotifications();
    await tester.pumpWidget(
      testApp(db, onboarded: false, notifications: notifications),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('skip')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('next')));
    await tester.pumpAndSettle();
    expect(notifications.permissionRequests, 0);
    await tester.tap(find.byKey(const ValueKey('time-08:00')));
    await tester.tap(find.byKey(const ValueKey('next')));
    await tester.pumpAndSettle();

    expect(notifications.permissionRequests, 1);
  });
}
