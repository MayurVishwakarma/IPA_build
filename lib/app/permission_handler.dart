import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart';

import '../main.dart';

class PermissionHandler{
  static requestPermissionsOnStartup() async {
    final PermissionStatus notificationStatus =
        await Permission.notification.request();
    if (notificationStatus != PermissionStatus.granted) {
    } else if (notificationStatus.isDenied) {
      requestPermissionsOnStartup();
    }
    final PermissionStatus locationStatus = await Permission.location.request();
    if (locationStatus != PermissionStatus.granted) {
    } else if (locationStatus.isDenied) {
      requestPermissionsOnStartup();
    }
  }
  static Future<void> scheduleNotifications() async {
    print("scheduling notifications");
    initializeTimeZones();
    print(tz.local.currentTimeZone);
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails("test", "notification",
            priority: Priority.max, importance: Importance.high);
    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    // Schedule notifications at 10 AM and 6 PM every day
    await notificationsPlugin.zonedSchedule(
      0,
      'Good morning!',
      "Please remember to log in to start your workday",
      tz.TZDateTime.from(_nextInstanceOfTime(9, 50,0), tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    await notificationsPlugin.zonedSchedule(
      1,
      'Great job today!',
      "Don't forget to log out and enjoy the rest of your day",
      tz.TZDateTime.from(_nextInstanceOfTime(17, 50,0), tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static DateTime _nextInstanceOfTime(int hour, int minute,int seconds) {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day,hour,minute,seconds);
    if (scheduledDate.isBefore(now)) {
      print(scheduledDate.toString());
    }
    return scheduledDate;
  }

  static checkAllNotification()async{
    var list=await notificationsPlugin.pendingNotificationRequests();
    print(list);
    return list;
  }
}