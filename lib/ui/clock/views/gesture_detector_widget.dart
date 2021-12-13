import 'package:flutter/material.dart';

class GestureDetectorWidget extends StatefulWidget {
  const GestureDetectorWidget({
    Key? key,
    this.child,
    required this.onDragEnd,
    required this.onDragX,
    required this.onDragY,
  }) : super(key: key);
  final Widget? child;
  final VoidCallback onDragEnd;
  final ValueChanged<double> onDragX;
  final ValueChanged<double> onDragY;

  @override
  _GestureDetectorWidgetState createState() => _GestureDetectorWidgetState();
}

class _GestureDetectorWidgetState extends State<GestureDetectorWidget> {
  Axis? axisActive;

  onDragEnd(details) {
    setAxisActive(null);
    widget.onDragEnd();
  }

  setAxisActive(Axis? axis) {
    axisActive = axis;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: onDragEnd,
      onVerticalDragEnd: onDragEnd,
      onHorizontalDragStart: (details) {
        setAxisActive(Axis.horizontal);
      },
      onVerticalDragStart: (details) {
        setAxisActive(Axis.vertical);
      },
      onHorizontalDragUpdate: (details) {
        if (axisActive != Axis.horizontal) return;
        widget.onDragX(details.delta.dx);
      },
      onVerticalDragUpdate: (details) {
        if (axisActive != Axis.vertical) return;
        widget.onDragY(details.delta.dy);
      },
      child: widget.child,
    );
  }
}
