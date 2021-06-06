import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

final BehaviorSubject<NotificationClass> didReceiveLocalNotifSubject =
    BehaviorSubject<NotificationClass>();
final BehaviorSubject<String> selectNotifSubject = BehaviorSubject<String>();
const String PLANNER_NOTIFICATION_NAME = 'planner';
const String PLANNER_NOTIFICATION_ID = 'planner01';
const String PLANNER_NOTIFICATION_DESC =
    'Scheduled notifications for planner tasks in life and success';
const String PLANNER_COMPLETED = 'planner_completed';

Future<void> scheduleNotification(
    {FlutterLocalNotificationsPlugin plugin,
    int id,
    String title = 'LaS Planner',
    String body,
    DateTime scheduledTime}) async {
  var payload = {'type': PLANNER_COMPLETED, 'id': id};
  var androidSpecifics = AndroidNotificationDetails(
    PLANNER_NOTIFICATION_ID,
    PLANNER_NOTIFICATION_NAME,
    PLANNER_NOTIFICATION_DESC,
    icon: 'icon',
    enableVibration: true,
    playSound: true,
    importance: Importance.High,
  );
  var iosSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics =
      NotificationDetails(androidSpecifics, iosSpecifics);
  await plugin.schedule(
      id, title, body, scheduledTime, platformChannelSpecifics,
      androidAllowWhileIdle: true, payload: jsonEncode(payload));
}

class NotificationClass {
  final int id;
  final String title;
  final String body;
  final String payload;

  NotificationClass({
    this.id,
    this.body,
    this.payload,
    this.title,
  });
}
