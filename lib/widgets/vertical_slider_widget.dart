import 'package:flutter/material.dart';
import 'package:format/format.dart';

class VerticalSlider extends StatelessWidget {
  final double percentage;
  final Function setValueChanged;
  final Function setValueEnd;
  final bool invert;
  const VerticalSlider(this.percentage, this.setValueChanged, this.setValueEnd, {this.invert = false, super.key});

  double inverted(double value) {
    return invert ? 100.0 - value : value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RotatedBox(
            quarterTurns: 1,
            child: Slider(
              value: inverted(percentage),
              max: 100,
              divisions: 20,
              label: percentage.round().toString(),
              onChanged: (double value) => setValueChanged(inverted(value)),
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
    );
  }
}
