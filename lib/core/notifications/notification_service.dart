import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'notification_plan.dart';

/// Bildirim metinleri (yerelleştirilmiş).
class NotificationTexts {
  const NotificationTexts({
    required this.reminderTitle,
    required this.reminderBody,
    required this.streakTitle,
    required this.streakBody,
  });

  final String reminderTitle;
  final String reminderBody;
  final String streakTitle;
  final String streakBody;
}

/// Yerel bildirimler (FR-100..102).
abstract interface class NotificationService {
  /// Bildirim izni ister (FR-04). İzin verildiyse `true`.
  Future<bool> requestPermission();

  /// Önceki planı iptal edip yenisini kurar.
  Future<void> apply(NotificationPlan plan, NotificationTexts texts);
}

class LocalNotificationService implements NotificationService {
  static const _reminderId = 1;
  static const _streakId = 2;

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  Future<void> _init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    final zone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(zone.identifier));
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _ready = true;
  }

  @override
  Future<bool> requestPermission() async {
    try {
      await _init();
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (android != null) {
        return await android.requestNotificationsPermission() ?? false;
      }
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await ios?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    } catch (e) {
      debugPrint('Bildirim izni alınamadı: $e');
      return false;
    }
  }

  @override
  Future<void> apply(NotificationPlan plan, NotificationTexts texts) async {
    try {
      await _init();
      await _plugin.cancel(id: _reminderId);
      await _plugin.cancel(id: _streakId);

      final reminder = plan.dailyReminder;
      if (reminder != null) {
        final now = tz.TZDateTime.now(tz.local);
        var at = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day,
          reminder.hour,
          reminder.minute,
        );
        if (!at.isAfter(now)) at = at.add(const Duration(days: 1));
        await _plugin.zonedSchedule(
          id: _reminderId,
          scheduledDate: at,
          notificationDetails: _details('daily_reminder', texts.reminderTitle),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          title: texts.reminderTitle,
          body: texts.reminderBody,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }

      final warning = plan.streakWarningAt;
      if (warning != null) {
        await _plugin.zonedSchedule(
          id: _streakId,
          scheduledDate: tz.TZDateTime.from(warning, tz.local),
          notificationDetails: _details('streak_warning', texts.streakTitle),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          title: texts.streakTitle,
          body: texts.streakBody,
        );
      }
    } catch (e) {
      // Bildirim eklentisi olmayan ortamlarda (test, web) sessizce geçilir.
      debugPrint('Bildirimler planlanamadı: $e');
    }
  }

  NotificationDetails _details(String channelId, String channelName) =>
      NotificationDetails(
        android: AndroidNotificationDetails(channelId, channelName),
        iOS: const DarwinNotificationDetails(),
      );
}

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => LocalNotificationService(),
);
