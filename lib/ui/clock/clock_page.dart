import 'dart:async';
import 'dart:developer';
import 'package:clock_app/base/base_constanta.dart';
import 'package:clock_app/base/base_function.dart';
import 'package:clock_app/ui/clock/views/flutter_analog_clock_painter_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({Key? key}) : super(key: key);

  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> with WidgetsBindingObserver {
  AppLifecycleState? lastLifecycleState;

  late DateTime currentTime;
  bool isAlarmActive = false;
  int configMinute = 0;
  Axis? axisActive;

  updateCurrentTime() {
    Timer.periodic(oneSecond, (time) {
      currentTime = currentTime.add(oneSecond);
      setState(() {});
    });
  }

  updateConfigMinute(double val) {
    log(val.toInt().toString());
    int defaultPlusMinus = 1;
    int multiple = 1;
    if (axisActive == Axis.vertical) {
      defaultPlusMinus = 4;
      multiple = 60;
    }
    if (val > defaultPlusMinus) configMinute += (1 * multiple);
    if (val < -defaultPlusMinus) configMinute += (-1 * multiple);
    setState(() {});
  }

  setAxisActive(Axis? axis) {
    axisActive = axis;
    setState(() {});
  }

  getCurrentTimeFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    configMinute = prefs.getInt(configMinuteKey) ?? 0;
    updateCurrentTimeWithConfigMinute();
    setState(() {});
  }

  saveConfigTimeToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(configMinuteKey, configMinute);
  }

  initStateAsycn() async {
    WidgetsBinding.instance!.addObserver(this);
    currentTime = DateTime.now();
    await getCurrentTimeFromLocal();
    updateCurrentTime();
  }

  updateCurrentTimeWithConfigMinute() {
    currentTime = DateTime.now().add(
      Duration(
        minutes: configMinute,
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initStateAsycn();
  }

  @override
  void dispose() {
    saveConfigTimeToLocal();
    WidgetsBinding.instance!.removeObserver(this);
    log("calledDispose");
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    lastLifecycleState = state;
    setState(() {});
    if (state == AppLifecycleState.inactive) {
      saveConfigTimeToLocal();
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO implement gesture for set alarm,
    //Trigger a system notification message and play a custom 2-second ringtone, when the
    // alarm is supposed to ring. (Without having to open the notification.)
    // ● When a notification is opened by the user, display a vertical bar chart of how long the
    // user takes to open each alarm notification in the past. (Y-axis should be how many
    // seconds taken each time, and X-axis should be each alarm bell that rang).

    return WillPopScope(
      onWillPop: () async {
        await saveConfigTimeToLocal();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  flex: 5,
                  child: GestureDetector(
                      onHorizontalDragStart: (details) {
                        setAxisActive(Axis.horizontal);
                      },
                      onVerticalDragStart: (details) {
                        setAxisActive(Axis.vertical);
                      },
                      onHorizontalDragEnd: (details) {
                        setAxisActive(null);
                      },
                      onVerticalDragEnd: (details) {
                        setAxisActive(null);
                      },
                      onHorizontalDragUpdate: (details) {
                        if (axisActive != Axis.horizontal) return;
                        updateConfigMinute(details.delta.dx);
                        updateCurrentTimeWithConfigMinute();
                      },
                      onVerticalDragUpdate: (details) {
                        if (axisActive != Axis.vertical) return;
                        updateConfigMinute(details.delta.dy);
                        updateCurrentTimeWithConfigMinute();
                      },
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: FlutterAnalogClockPainterWidget(currentTime),
                        ),
                      ))),
              Flexible(
                child: Text(
                  "Perbedaan dengan waktu asli :  ${durationToString(configMinute)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  // color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          "00:00 AM",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: 1.5,
                        child: Switch(
                          value: isAlarmActive,
                          onChanged: (val) {
                            isAlarmActive = val;
                            setState(() {});
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
