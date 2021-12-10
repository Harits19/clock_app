import 'dart:async';
import 'dart:developer';
import 'package:clock_app/base/base_constanta.dart';
import 'package:clock_app/base/base_function.dart';
import 'package:clock_app/ui/clock/views/alarm_time_view.dart';
import 'package:clock_app/ui/clock/views/clock_analog_view.dart';
import 'package:clock_app/ui/clock/views/flutter_analog_clock_painter_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({Key? key}) : super(key: key);

  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  @override
  Widget build(BuildContext context) {
    //TODO implement gesture for set alarm,
    //Trigger a system notification message and play a custom 2-second ringtone, when the
    // alarm is supposed to ring. (Without having to open the notification.)
    // ● When a notification is opened by the user, display a vertical bar chart of how long the
    // user takes to open each alarm notification in the past. (Y-axis should be how many
    // seconds taken each time, and X-axis should be each alarm bell that rang).

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(flex: 5, child: ClockAnalogView()),
              Expanded(flex: 5, child: AlarmTimeView()),
            ],
          ),
        ),
      ),
    );
  }
}
