import 'package:english_word_learning/core/notifications/notification_plan.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final morning = DateTime(2026, 10, 13, 9);
  const quiet = QuietHours(ClockTime(22, 0), ClockTime(8, 0));

  NotificationPlan plan({
    DateTime? now,
    bool reminder = true,
    String? time = '20:00',
    bool warning = true,
    int streak = 3,
    bool goalMet = false,
    QuietHours? quietHours,
  }) => planNotifications(
    now: now ?? morning,
    reminderEnabled: reminder,
    reminderTime: time,
    streakWarningEnabled: warning,
    streak: streak,
    goalMetToday: goalMet,
    quietHours: quietHours,
  );

  test('saat çözümleme', () {
    expect(ClockTime.tryParse('07:05'), const ClockTime(7, 5));
    expect(ClockTime.tryParse('7:5').toString(), '07:05');
    expect(ClockTime.tryParse('25:00'), isNull);
    expect(ClockTime.tryParse(null), isNull);
  });

  test('sessiz saatler gece yarısını aşabilir (FR-102)', () {
    expect(quiet.contains(const ClockTime(23, 0)), isTrue);
    expect(quiet.contains(const ClockTime(7, 59)), isTrue);
    expect(quiet.contains(const ClockTime(8, 0)), isFalse);
    expect(quiet.contains(const ClockTime(12, 0)), isFalse);
    const day = QuietHours(ClockTime(13, 0), ClockTime(14, 0));
    expect(day.contains(const ClockTime(13, 30)), isTrue);
    expect(day.contains(const ClockTime(14, 30)), isFalse);
  });

  test('günlük hatırlatma seçilen saatte kurulur (FR-100)', () {
    expect(plan().dailyReminder, const ClockTime(20, 0));
    expect(plan(reminder: false).dailyReminder, isNull);
    expect(plan(time: null).dailyReminder, isNull);
  });

  test('sessiz saate denk gelen hatırlatma bitişe kaydırılır', () {
    expect(
      plan(time: '07:00', quietHours: quiet).dailyReminder,
      const ClockTime(8, 0),
    );
    expect(
      plan(time: '20:00', quietHours: quiet).dailyReminder,
      const ClockTime(20, 0),
    );
  });

  test('seri uyarısı yalnız hedef tamamlanmadıysa kurulur (FR-101)', () {
    expect(plan().streakWarningAt, DateTime(2026, 10, 13, 20, 30));
    expect(plan(goalMet: true).streakWarningAt, isNull);
    expect(plan(streak: 0).streakWarningAt, isNull);
    expect(plan(warning: false).streakWarningAt, isNull);
    expect(
      plan(now: DateTime(2026, 10, 13, 21)).streakWarningAt,
      isNull,
      reason: 'uyarı saati geçti',
    );
    const evening = QuietHours(ClockTime(20, 0), ClockTime(23, 0));
    expect(plan(quietHours: evening).streakWarningAt, isNull);
  });
}
