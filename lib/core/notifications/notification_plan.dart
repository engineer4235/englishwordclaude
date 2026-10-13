/// Saat:dakika (ör. "20:00").
class ClockTime {
  const ClockTime(this.hour, this.minute);

  /// "HH:mm" biçimini çözer; geçersizse `null`.
  static ClockTime? tryParse(String? text) {
    final parts = text?.split(':');
    if (parts == null || parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) {
      return null;
    }
    return ClockTime(h, m);
  }

  final int hour;
  final int minute;

  int get minutes => hour * 60 + minute;

  @override
  bool operator ==(Object other) =>
      other is ClockTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

/// Sessiz saatler (FR-102). Gece yarısını aşabilir (22:00–08:00).
class QuietHours {
  const QuietHours(this.start, this.end);

  final ClockTime start;
  final ClockTime end;

  bool contains(ClockTime t) {
    final s = start.minutes;
    final e = end.minutes;
    final x = t.minutes;
    if (s == e) return false;
    return s < e ? x >= s && x < e : x >= s || x < e;
  }
}

/// Planlanacak bildirimler.
class NotificationPlan {
  const NotificationPlan({this.dailyReminder, this.streakWarningAt});

  /// Her gün bu saatte hatırlatma (FR-100); `null` ise yok.
  final ClockTime? dailyReminder;

  /// Bugün için seri uyarısı zamanı (FR-101); `null` ise yok.
  final DateTime? streakWarningAt;

  @override
  bool operator ==(Object other) =>
      other is NotificationPlan &&
      other.dailyReminder == dailyReminder &&
      other.streakWarningAt == streakWarningAt;

  @override
  int get hashCode => Object.hash(dailyReminder, streakWarningAt);
}

/// Akşam seri uyarısının saati (FR-101).
const streakWarningTime = ClockTime(20, 30);

/// Ayarlara ve bugünkü duruma göre bildirim planı (FR-100..102).
///
/// Hatırlatma sessiz saate denk gelirse sessiz saatin bitişine kaydırılır.
/// Seri uyarısı yalnızca seri varken, bugünkü hedef tamamlanmamışken ve
/// uyarı saati henüz geçmemişken planlanır; sessiz saatteyse atlanır.
NotificationPlan planNotifications({
  required DateTime now,
  required bool reminderEnabled,
  required String? reminderTime,
  required bool streakWarningEnabled,
  required int streak,
  required bool goalMetToday,
  QuietHours? quietHours,
}) {
  ClockTime? reminder;
  final time = ClockTime.tryParse(reminderTime);
  if (reminderEnabled && time != null) {
    reminder = quietHours != null && quietHours.contains(time)
        ? quietHours.end
        : time;
  }

  DateTime? warning;
  if (streakWarningEnabled && streak > 0 && !goalMetToday) {
    final at = DateTime(
      now.year,
      now.month,
      now.day,
      streakWarningTime.hour,
      streakWarningTime.minute,
    );
    final quiet = quietHours?.contains(streakWarningTime) ?? false;
    if (at.isAfter(now) && !quiet) warning = at;
  }

  return NotificationPlan(dailyReminder: reminder, streakWarningAt: warning);
}
