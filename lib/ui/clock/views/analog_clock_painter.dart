import 'dart:math';
import 'dart:ui';

import 'package:clock_app/base/base_constanta.dart';
import 'package:flutter/material.dart';

class AnalogClockPainter extends CustomPainter {
  final TimeOfDay timeOfDay;
  AnalogClockPainter({
    this.timeOfDay = const TimeOfDay(
      hour: 0,
      minute: 0,
    ),
  });

  static double getRadians(double angle) {
    return angle * pi / 180;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.height / 2, size.width / 2);
    const borderWidth = 4.0;
    const totalTitikMenit = 60;
    const totalTitikJam = 12;
    const sudutLingkaran = 360;
    const sudutPerTitikMenit = sudutLingkaran / totalTitikMenit;
    const sudutPerTitikJam = sudutLingkaran / totalTitikJam;
    const widthTitikMenit = 8.0;
    const widthTitikJam = 16.0;
    const multiple = 3;

    // final kelilingLingkaran = 2 * pi * radius;

    canvas.translate(size.width / 2, size.height / 2);
    canvas.drawCircle(
      const Offset(0, 0),
      radius,
      Paint()
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke
        ..color = Colors.black,
    );
    canvas.drawCircle(Offset.zero, 8, Paint());
    final listTitikMenit = <Offset>[];
    List.generate(totalTitikMenit, (index) {
      final _sudutTitik = index * sudutPerTitikMenit;
      final _radius = radius - borderWidth * multiple;

      final x = cos(getRadians(_sudutTitik)) * _radius;
      final y = sin(getRadians(_sudutTitik)) * _radius;
      listTitikMenit.add(Offset(x, y));
    });
    canvas.drawPoints(
      PointMode.points,
      listTitikMenit,
      Paint()
        ..color = Colors.blue
        ..strokeWidth = widthTitikMenit
        ..strokeCap = StrokeCap.round,
    );

    final listTitikJam = <Offset>[];
    List.generate(totalTitikJam, (index) {
      final _sudutTitik = index * sudutPerTitikJam;
      final _radius = radius - borderWidth * multiple;

      final x = cos(getRadians(_sudutTitik)) * _radius;
      final y = sin(getRadians(_sudutTitik)) * _radius;
      listTitikJam.add(Offset(x, y));
    });
    canvas.drawPoints(
      PointMode.points,
      listTitikJam,
      Paint()
        ..color = Colors.green
        ..strokeWidth = widthTitikJam
        ..strokeCap = StrokeCap.round,
    );

    final minute = timeOfDay.minute;

    List.generate(totalTitikMenit, (index) {
      if (index == minute) {
        final _sudutTitik = index * sudutPerTitikMenit - 90;
        final _radius = radius - borderWidth * multiple - 16;

        final x = cos(getRadians(_sudutTitik)) * _radius;
        final y = sin(getRadians(_sudutTitik)) * _radius;
        canvas.drawLine(
          Offset.zero,
          Offset(x, y),
          Paint()..strokeWidth = 4,
        );
      }
    });

    int hour = timeOfDay.hour;
    if (hour > 12 && hour < 24) {
      hour -= 12;
    }
    List.generate(totalTitikJam, (index) {
      if (index == hour) {
        final _sudutTitik = index * sudutPerTitikJam - 90;
        final _radius = radius - borderWidth * multiple - 80;

        final x = cos(getRadians(_sudutTitik)) * _radius;
        final y = sin(getRadians(_sudutTitik)) * _radius;
        canvas.drawLine(
          Offset.zero,
          Offset(x, y),
          Paint()
            ..strokeWidth = 8
            ..color = Colors.green,
        );
      }
    });

    List.generate(totalTitikJam, (index) {
      canvas.save();

      final _sudutTitik = index * sudutPerTitikJam;
      final _radius = radius - borderWidth * multiple - 32;

      final x = cos(getRadians(_sudutTitik)) * _radius;
      final y = sin(getRadians(_sudutTitik)) * _radius;
      canvas.translate(x, y);
      final textPainter = TextPainter(
        text: TextSpan(
          text: hourTextView[index].toString(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();

      textPainter.paint(
          canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    });

    // final offset =
    //     Offset(50 - (textPainter.width / 2), 100 - (textPainter.height / 2));
    // textPainter.paint(canvas, offset);

    //
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
