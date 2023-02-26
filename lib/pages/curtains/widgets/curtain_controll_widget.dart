import 'package:flutter/material.dart';
import '/widgets/vertical_slider_widget.dart';

class CurtainControll extends StatelessWidget {
  final double percentage;
  final Function setValueChangedFunc;
  final Function setValueEndFunc;
  final VoidCallback openFunc;
  final VoidCallback closeFunc;
  final VoidCallback stopFunc;
  final bool invert;
  const CurtainControll(
      this.percentage, this.setValueChangedFunc, this.setValueEndFunc, this.openFunc, this.closeFunc, this.stopFunc,
      {this.invert = false, super.key});

  double inverted(double value) {
    return invert ? 100.0 - value : value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      VerticalSlider(
        percentage,
        setValueChangedFunc,
        setValueEndFunc,
        invert: true,
      ),
      Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        FloatingActionButton(
          onPressed: openFunc,
          heroTag: null,
          child: const Icon(Icons.arrow_upward),
        ),
        FloatingActionButton(
          onPressed: stopFunc,
          heroTag: null,
          child: const Icon(Icons.pause),
        ),
        FloatingActionButton(
          onPressed: closeFunc,
          heroTag: null,
          child: const Icon(Icons.arrow_downward),
        ),
      ]),
    ]);
  }
}
