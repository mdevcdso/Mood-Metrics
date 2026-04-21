import "package:flutter_local_notifications/flutter_local_notifications.dart";
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationsService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    initializeTimeZones();

    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    setLocalLocation(getLocation(timeZoneName));

    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
  }

  Future<void> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
  }

  Future<void> scheduleDailyReminder(int hour, int minute) async {
    await _plugin.zonedSchedule(
      0,
      'Mood & Metrics',
      'N\'oublie pas de remplir ton journal du jour !',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Rappel quotidien',
          channelDescription: 'Notification de rappel quotidien',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAllNotifs() async {
    await _plugin.cancelAll();
  }

  TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = TZDateTime.now(local);
    var scheduled = TZDateTime(local, now.year, now.month, now.day,
        hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  Future<void> showTestNotification() async {
    await _plugin.show(
      99,
      'Mood & Metrics',
      'Les notifications fonctionnent !',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Rappel quotidien',
          channelDescription: 'Notification de rappel quotidien',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}