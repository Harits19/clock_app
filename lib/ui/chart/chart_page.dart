import 'dart:convert';
import 'dart:developer';

import 'package:clock_app/base/base_constanta.dart';
import 'package:clock_app/base/base_function.dart';
import 'package:clock_app/models/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  static const routeName = "/ChartPage";

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<AlarmModel> listAlarm = <AlarmModel>[];
  int? highestPeriod;

  @override
  void initState() {
    super.initState();
    saveTimePeriodOnClick();
  }

  saveTimePeriodOnClick() async {
    final now = TimeOfDay.now();
    log("open notif at $now");
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final alarmTime = stringToTimeOfDay(prefs.getString(alarmTimeKey));
    if (alarmTime == null) return;
    final period = timeToMinute(now) - timeToMinute(alarmTime);
    log("time to click notif $period");

    final listAlarmFromLocal = (prefs.getString(alarmTimeChartDataKey));
    if (listAlarmFromLocal?.isNotEmpty ?? false) {
      final listAlarmDecode = jsonDecode(listAlarmFromLocal!);
      listAlarm = listAlarmDecode!
          .map((e) => AlarmModel.fromJson(e))
          .toList()
          .cast<AlarmModel>();
    }

    listAlarm.add(AlarmModel(
      id: (listAlarm.isEmpty) ? 0 : listAlarm.last.id + 1,
      alarmTime: alarmTime.format(context),
      pressTimePeriod: period,
    ));
    final listAlarmEncode = jsonEncode(listAlarm);
    await prefs.setString(alarmTimeChartDataKey, listAlarmEncode);
    listAlarm = List.from(listAlarm);

    final listAlarmTemp = List.from(listAlarm).cast<AlarmModel>();
    listAlarmTemp
        .sort((a, b) => a.pressTimePeriod.compareTo(b.pressTimePeriod));
    highestPeriod = (listAlarmTemp.last.pressTimePeriod);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          color: Colors.grey,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if ((highestPeriod ?? 0) > 0)
                      ...List.generate(
                              highestPeriod!,
                              (index) =>
                                  Expanded(child: Text((index + 1).toString())))
                          .reversed,
                    const Expanded(
                      child: Text(""),
                    )
                  ],
                ),
                ...listAlarm.map(
                  (e) {
                    final flexWidget =
                        ((highestPeriod ?? 0) - e.pressTimePeriod);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (flexWidget > 0)
                            Spacer(
                              flex: flexWidget,
                            ),
                          Expanded(
                            flex: e.pressTimePeriod,
                            child: Container(
                              color: Colors.yellow,
                              child: Text(
                                " " + e.pressTimePeriod.toString() + " menit ",
                              ),
                            ),
                          ),
                          Text(e.alarmTime),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
