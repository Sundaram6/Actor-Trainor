import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static bool enabled = true;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (!enabled) return;
    if (_initialized) return;

    try {
      tz.initializeTimeZones();

      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _plugin.initialize(initSettings);
      _initialized = true;
    } catch (_) {
      // Silently ignore if in headless or test environment
    }
  }

  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    if (!enabled) return;
    try {
      await init();

      const androidDetails = AndroidNotificationDetails(
        'daily_reminder_channel',
        'Daily Reminder',
        channelDescription: 'Morning routine reminder',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      );
      const iosDetails = DarwinNotificationDetails();
      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _plugin.zonedSchedule(
        0,
        'The Instrument',
        'Your morning routine is waiting. Breathe first.',
        _nextInstanceOfTime(hour, minute),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {
      // Silently handle if notifications are unavailable
    }
  }

  Future<void> cancelReminder() async {
    if (!enabled) return;
    try {
      await _plugin.cancel(0);
    } catch (_) {}
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
