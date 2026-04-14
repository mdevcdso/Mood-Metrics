import "package:flutter_local_notifications/flutter_local_notifications.dart";
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart';

class NotificationsService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  // init plugin avec configs iOS et Android
  Future<void> init() async {
    initializeTimeZones();

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

  // programmation d'une notif quotidienne selon heure choisie
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // reset toutes les notifs programmées
  Future<void> cancelAllNotifs() async {
    await _plugin.cancelAll();
  }

  // calcule le prochain moment où il sera l'heure choisie
  TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = TZDateTime.now(local);
    var scheduled = TZDateTime(local, now.year, now.month, now.day,
        hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}