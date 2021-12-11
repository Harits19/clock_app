import 'package:clock_app/base/base_constanta.dart';
import 'package:clock_app/base/base_function.dart';
import 'package:clock_app/ui/clock/views/gesture_detector_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmTimeView extends StatefulWidget {
  const AlarmTimeView({Key? key}) : super(key: key);

  @override
  _AlarmTimeViewState createState() => _AlarmTimeViewState();
}

class _AlarmTimeViewState extends State<AlarmTimeView> {
  TimeOfDay alarmTime = const TimeOfDay(hour: 0, minute: 0);
  bool isAlarmActive = false;

  saveAlarmTimeToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(alarmTimeKey, alarmTime.format(context));
  }

  saveIsAlarmActive() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isAlarmActiveKey, isAlarmActive);
  }

  getIsAlarmActive() async {
    final prefs = await SharedPreferences.getInstance();
    isAlarmActive = prefs.getBool(isAlarmActiveKey) ?? false;
    setState(() {});
  }

  getAlarmTimeFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final tempAlarmTime = stringToTimeOfDay(prefs.getString(alarmTimeKey));
    if (tempAlarmTime == null) return;
    alarmTime = tempAlarmTime;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAlarmTimeFromLocal();
    getIsAlarmActive();
  }

  @override
  Widget build(BuildContext context) {
    // getAlarmTimeFromLocal();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetectorWidget(
          isMultipleSensitivity: false,
          onUpdate: (val) {
            // log(val.toString());
            if (val == 60 && (alarmTime.hour + 1) < 24) {
              alarmTime = alarmTime.add(hour: 1);
            } else if (val == -60 && (alarmTime.hour - 1) >= 0) {
              alarmTime = alarmTime.add(hour: -1);
            } else if (val == 1 && (alarmTime.minute + 1) < 60) {
              alarmTime = alarmTime.add(minute: 1);
            } else if (val == -1 && (alarmTime.minute - 1) >= 0) {
              alarmTime = alarmTime.add(minute: -1);
            }
            setState(() {});
          },
          onDragEnd: saveAlarmTimeToLocal,
          child: Container(
            color: Colors.blue,
            child: Text(
              alarmTime.format(context),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Switch(
          value: isAlarmActive,
          onChanged: (isActive) {
            isAlarmActive = isActive;
            setState(() {});
            saveIsAlarmActive();
          },
        )
      ],
    );
  }
}
