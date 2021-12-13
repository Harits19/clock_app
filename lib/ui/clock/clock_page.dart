import 'dart:developer';

import 'package:clock_app/base/base_constanta.dart';
import 'package:clock_app/base/base_function.dart';
import 'package:clock_app/ui/chart/chart_page.dart';
import 'package:clock_app/ui/clock/views/flutter_analog_clock_painter_widget.dart';
import 'package:clock_app/ui/clock/views/gesture_detector_widget.dart';
import 'package:clock_app/utils/local_notification_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({Key? key}) : super(key: key);
  static const routeName = "/ClockPage";

  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  TimeOfDay alarmTime = const TimeOfDay(hour: 0, minute: 0);
  bool isAlarmActive = false;

  @override
  void initState() {
    super.initState();
    _configureSelectNotificationSubject();
    getAlarmTimeFromLocal();
    getIsAlarmActive();
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      await Navigator.pushNamed(context, ChartPage.routeName);
    });
  }

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
  Widget build(BuildContext context) {
    // getAlarmTimeFromLocal();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: GestureDetectorWidget(
                  onDragX: (val) {
                    if (val >= 1 && (alarmTime.minute + 1) < 60) {
                      alarmTime = alarmTime.add(minute: 1);
                    } else if (val <= -1 && (alarmTime.minute - 1) >= 0) {
                      alarmTime = alarmTime.add(minute: -1);
                    }
                    setState(() {});
                  },
                  onDragY: (val) {
                    const defaulSensitivity = 6;
                    if (val >= defaulSensitivity && (alarmTime.hour + 1) < 24) {
                      alarmTime = alarmTime.add(hour: 1);
                    } else if (val <= -defaulSensitivity &&
                        (alarmTime.hour - 1) >= 0) {
                      alarmTime = alarmTime.add(hour: -1);
                    }
                    setState(() {});
                  },
                  onDragEnd: saveAlarmTimeToLocal,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: CustomPaint(
                      painter: FlutterAnalogClockPainterWidget(alarmTime),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: Colors.blue,
                    child: Text(
                      alarmTime.format(context),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
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
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       showNotification();
                  //       return;
                  //       final alarmModel = AlarmModel(
                  //         id: 1,
                  //         alarmTime: "alarmTime",
                  //         pressTimePeriod: 1,
                  //       );
                  //       final alarmModelJson = jsonEncode(alarmModel);
                  //       log(alarmModel.toJson().toString());
                  //       final alarmModelDecode = jsonDecode(alarmModelJson);
                  //       log(alarmModelDecode.toString());
                  //       final alarmModelObject = AlarmModel.fromJson(alarmModelDecode);
                  //       log(alarmModelObject.alarmTime);
                  //     },
                  //     child: Text("Test")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
