import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool enabled = true;

  static Future<void> init() async {
    if (!enabled) return;
    try {
      tz_data.initializeTimeZones();

      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);

      await _plugin.initialize(initSettings);
    } catch (_) {
      // Silently fail if in headless environment
    }
  }

  static Future<void> scheduleDailyReminder({required bool enabled}) async {
    if (!NotificationService.enabled) return;
    try {
      if (!enabled) {
        await _plugin.cancel(0);
        return;
      }

      const androidDetails = AndroidNotificationDetails(
        'daily_reminder',
        'Daily Training Reminder',
        channelDescription: 'Reminds you to complete your morning routine',
        importance: Importance.high,
        priority: Priority.high,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      await _plugin.zonedSchedule(
        0,
        'THE INSTRUMENT',
        'Time for your morning routine. 112 minutes to sharpen the craft.',
        _nextInstanceOf7AM(),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {
      // Silently handle if notifications are unavailable
    }
  }

  static tz.TZDateTime _nextInstanceOf7AM() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 7);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
