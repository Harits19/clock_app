import 'package:clock_app/my_app.dart';
import 'package:clock_app/utils/alarm_manager_util.dart';
import 'package:clock_app/utils/local_notification_util.dart';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  await initLocalNotification();
  runApp(const MyApp());
  await runAlarmManager();
}
