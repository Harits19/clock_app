import 'package:flutter/material.dart';

TimeOfDay? stringToTimeOfDay(String? s) {
  if (s?.isEmpty ?? true) return null;
  return TimeOfDay(
      hour: int.parse(s!.split(":")[0]), minute: int.parse(s.split(":")[1]));
}

double timeOfDayToDouble(TimeOfDay myTime) =>
    myTime.hour + myTime.minute / 60.0;

int timeToMinute(TimeOfDay timeOfDay) {
  return (timeOfDay.hour * 60) + (timeOfDay.minute);
}

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay add({int hour = 0, int minute = 0}) {
    return replacing(hour: this.hour + hour, minute: this.minute + minute);
  }
}
