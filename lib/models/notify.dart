// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Nontify {
  static final _notification = FlutterLocalNotificationsPlugin();
  static Future details() async {
    return NotificationDetails(
        iOS: IOSNotificationDetails(),
        android: AndroidNotificationDetails("id", "name", "desc",
            importance: Importance.max));
  }

  static Future showNotifiaction({id, title, content}) async {
    _notification.show(id, title, content, await details(),
        payload: "good.abs");
  }

  static Future Schedule(
      {id, title, content, required DateTime scheduledate}) async {
    _notification.zonedSchedule(id, title, content,
        tz.TZDateTime.from(scheduledate, tz.local), await details(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  static Future cancle_notifiacation(int id) async {
    FlutterLocalNotificationsPlugin obj = FlutterLocalNotificationsPlugin();
    obj.cancel(id);
  }


  static Future init() async {
    final andoid = AndroidInitializationSettings("@mipmap/ic_launcher");
    final ios = IOSInitializationSettings();
    final setting = InitializationSettings(iOS: ios, android: andoid);
    await _notification.initialize(setting);
    tz.initializeTimeZones();
  }
}
