import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final hhMmSs = DateFormat("HH:mm:ss");

TimeOfDay? stringToTimeOfDay(String? s) {
  if (s?.isEmpty ?? true) return null;
  return TimeOfDay(
      hour: int.parse(s!.split(":")[0]), minute: int.parse(s.split(":")[1]));
}

String timeOfDayToString(TimeOfDay timeOfDay) {
  return "${timeOfDay.hour}:${timeOfDay.minute}";
}

double timeOfDayToDouble(TimeOfDay myTime) =>
    myTime.hour + myTime.minute / 60.0;

int timeToMinute(TimeOfDay timeOfDay) {
  return (timeOfDay.hour * 60) + (timeOfDay.minute);
}

int timeToSecond(TimeOfDay timeOfDay) {
  return (timeOfDay.hour * 60 * 60) + (timeOfDay.minute * 60);
}

int dateTimeToSecond(DateTime dateTime) {
  return (dateTime.hour * 60 * 60) + (dateTime.minute * 60) + (dateTime.second);
}

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay add({int hour = 0, int minute = 0}) {
    return replacing(hour: this.hour + hour, minute: this.minute + minute);
  }
}
