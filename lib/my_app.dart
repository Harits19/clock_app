import 'package:clock_app/ui/chart/chart_page.dart';
import 'package:clock_app/ui/clock/clock_page.dart';
import 'package:clock_app/utils/local_notification_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: <String, WidgetBuilder>{
        ClockPage.routeName: (_) => ClockPage(),
        ChartPage.routeName: (_) => const ChartPage(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
