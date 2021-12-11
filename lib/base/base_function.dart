import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final hhMmSs = DateFormat("HH:mm:ss");
final hhMm = DateFormat("HH:mm");
// final alarmFormat = TimeOfDayFormat;

const oneSecond = Duration(seconds: 1);

String durationToString(int minutes) {
  var d = Duration(minutes: minutes);
  List<String> parts = d.toString().split(':');
  return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
}

TimeOfDay? stringToTimeOfDay(String? s) {
  if (s?.isEmpty ?? true) return null;
  return TimeOfDay(
      hour: int.parse(s!.split(":")[0]), minute: int.parse(s.split(":")[1]));
}

double timeOfDayToDouble(TimeOfDay myTime) =>
    myTime.hour + myTime.minute / 60.0;

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay add({int hour = 0, int minute = 0}) {
    return replacing(hour: this.hour + hour, minute: this.minute + minute);
  }
}
