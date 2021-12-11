import 'dart:developer';
import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/base/base_constanta.dart';
import 'package:clock_app/base/base_function.dart';
import 'package:clock_app/utils/local_notification_util.dart';
import 'package:clock_app/utils/prefs_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

runAlarmManager() async {
  await AndroidAlarmManager.periodic(
    const Duration(minutes: 1),
    alarmManagerId, //Different ID for each alarm
    runPeriodicTask,
    wakeup: true, //the device will be woken up when the alarm fires
    startAt: DateTime.now(),
    exact: true,
    allowWhileIdle: true,
  );
}

void runPeriodicTask() async {
  checkIsTimeToRunAlarm();
}

checkIsTimeToRunAlarm() async {
  log("run check isTimeAlarm");
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  final alarmTime = stringToTimeOfDay(prefs.getString(alarmTimeKey));
  final configMinute = prefs.getInt(configMinuteKey);
  final isActive = prefs.getBool(isAlarmActiveKey);

  final updatedDateNow =
      DateTime.now().add(Duration(minutes: configMinute ?? 0));
  final now = TimeOfDay.fromDateTime(updatedDateNow);
  log("time now: $now, alarm time :$alarmTime, ");
  if (alarmTime == null) return;
  if (timeOfDayToDouble(now) == timeOfDayToDouble(alarmTime) &&
      isActive == true) {
    showNotification();
  }
}
