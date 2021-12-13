import 'dart:developer';

import 'package:clock_app/ui/chart/chart_page.dart';
import 'package:clock_app/ui/clock/clock_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

late final NotificationAppLaunchDetails? notificationAppLaunchDetails;
String initialRoute = ClockPage.routeName;

initLocalNotification() async {
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    initialRoute = ChartPage.routeName;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (payload) {
      selectNotificationSubject.add(payload);
    },
  );
}

Future<void> showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    sound: RawResourceAndroidNotificationSound('slow_spring_board'),
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'plain title',
    'plain body',
    platformChannelSpecifics,
    payload: 'item x',
  );
}

Future<void> scheduleDailyTenAMNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'daily scheduled notification title',
    'daily scheduled notification body',
    _nextInstanceOfTenAM(),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily notification channel id',
        'daily notification channel name',
        channelDescription: 'daily notification description',
        sound: RawResourceAndroidNotificationSound('slow_spring_board'),
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

tz.TZDateTime _nextInstanceOfTenAM() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, now.hour, now.minute + 1);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

Future<void> cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}
