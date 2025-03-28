import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notifications plugin
  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    print("Initializing notification plugin...");
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print("Notification tapped: ${response.payload}");
      },
    );
    print("Notification plugin initialized.");
  }

  // Request notification permissions for iOS
  static Future<void> requestPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'test_channel',
      'Test Channel',
      channelDescription: 'Channel for testing notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    print("Sending test notification...");
    await _notificationsPlugin.show(
      0,
      'Test Notification',
      'This is a test notification',
      notificationDetails,
    );
    print("Test notification sent.");
  }

  // Schedule daily notifications
  static Future<void> scheduleNotifications() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'daily_meal_channel',
      'Daily Meal Notifications',
      channelDescription: 'This channel is for meal reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // Schedule notification at 9:00 AM
    print("Scheduling 9:00 AM notification...");

    await _notificationsPlugin.zonedSchedule(
      1,
      'Meal Reminder',
      'Have you registered your meal?',
      _scheduleDailyNotification(9, 14), // 9:00 AM

      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    print("Scheduling 9:00 AM notification...");

    // Schedule notification at 1:00 PM
    await _notificationsPlugin.zonedSchedule(
      2,
      'Meal Reminder',
      'Do not forget to save your meal.',
      _scheduleDailyNotification(16, 0), // 1:00 PM
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    // Schedule notification at 8:00 PM
    await _notificationsPlugin.zonedSchedule(
      3,
      'Dinner Reminder',
      'Did you know that having dinner too late might affect your overall energy level?',
      _scheduleDailyNotification(20, 0), // 8:00 PM
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Helper method to calculate notification times
  static tz.TZDateTime _scheduleDailyNotification(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTime =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1)); // Next day
    }
    return scheduledTime;
  }
}
