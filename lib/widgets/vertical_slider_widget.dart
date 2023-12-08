import 'package:flutter/material.dart';
import 'package:format/format.dart';

import 'slider_widget.dart';

/// widget that turns a horizontal slider on its side
class VerticalSlider extends StatelessWidget {
  final double percentage;
  final Function setValueEnd;
  final bool invert;
  final int? divisions;

  const VerticalSlider(
    this.percentage,
    this.setValueEnd, {
    this.invert = false,
    this.divisions,
    super.key,
  });

  double inverted(double value) {
    return invert ? 100.0 - value : value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: RotatedBox(
              quarterTurns: 1,
              child: SliderWidget(
                value: inverted(percentage),
                max: 100,
                divisions: divisions,
                label: percentage.round().toString(),
                onChangeEnd: (double value) => setValueEnd(inverted(value)),
              ),
            ),
          ),
          Text(
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            format('{:.0f}%', percentage),
          ),
        ],
      ),
    );
  }
}
