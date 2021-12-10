import 'dart:async';

import 'package:clock_app/base/base_constanta.dart';
import 'package:clock_app/base/base_function.dart';
import 'package:clock_app/ui/clock/views/flutter_analog_clock_painter_widget.dart';
import 'package:clock_app/ui/clock/views/gesture_detector_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClockAnalogView extends StatefulWidget {
  const ClockAnalogView({Key? key}) : super(key: key);

  @override
  _ClockAnalogViewState createState() => _ClockAnalogViewState();
}

class _ClockAnalogViewState extends State<ClockAnalogView> {
  int configMinute = 0;
  late DateTime currentTime;

  saveConfigTimeToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(configMinuteKey, configMinute);
  }

  updateConfigMinute(int val) {
    configMinute += val;
    updateCurrentTimeWithConfigMinute();
    saveConfigTimeToLocal();
    setState(() {});
  }

  updateCurrentTimeWithConfigMinute() {
    currentTime = DateTime.now().add(
      Duration(
        minutes: configMinute,
      ),
    );
    setState(() {});
  }

  getConfigTimeFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    configMinute = prefs.getInt(configMinuteKey) ?? 0;
    updateCurrentTimeWithConfigMinute();
    setState(() {});
  }

  loopUpdateCurrentTime() {
    Timer.periodic(oneSecond, (time) {
      currentTime = currentTime.add(oneSecond);
      setState(() {});
    });
  }

  initStateAsycn() async {
    currentTime = DateTime.now();
    await getConfigTimeFromLocal();
    loopUpdateCurrentTime();
  }

  @override
  void initState() {
    super.initState();
    initStateAsycn();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: GestureDetectorWidget(
            onDragEnd: saveConfigTimeToLocal,
            onUpdate: updateConfigMinute,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CustomPaint(
                painter: FlutterAnalogClockPainterWidget(currentTime),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          "Waktu : ${hhMmSs.format(currentTime)}\nPerbedaan dengan waktu asli :  ${durationToString(configMinute)}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
