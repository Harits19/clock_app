import 'package:flutter/material.dart';

class GestureDetectorWidget extends StatefulWidget {
  const GestureDetectorWidget({
    Key? key,
    this.child,
    required this.onDragEnd,
    required this.onUpdate,
    this.onDragX,
    this.onDragy,
    this.isMultipleSensitivity = true,
  }) : super(key: key);
  final Widget? child;
  final VoidCallback onDragEnd;
  final ValueChanged<int> onUpdate;
  final ValueChanged<int>? onDragX;
  final ValueChanged<int>? onDragy;

  final bool isMultipleSensitivity;

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

  updateValue(double val) {
    int defaultSensitivity = 1;
    int multiple = 1;

    if (axisActive == Axis.vertical) {
      multiple = 60;
      if (widget.isMultipleSensitivity) defaultSensitivity = 4;
    }
    if (val > defaultSensitivity) widget.onUpdate(1 * multiple);
    if (val < -defaultSensitivity) widget.onUpdate(-1 * multiple);
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
        updateValue(details.delta.dx);
      },
      onVerticalDragUpdate: (details) {
        if (axisActive != Axis.vertical) return;
        updateValue(details.delta.dy);
      },
      child: widget.child,
    );
  }
}
