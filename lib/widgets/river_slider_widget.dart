import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODOs
// this is a wrapper for the actual RiverSliderX widget
// this only set's the key to the value of the slider because
// How do I set the key from the value?
class RiverSlider extends StatelessWidget {
  final double value;
  final double max;
  final Function? onChanged;
  final Function? onChangeEnd;

  final double? min;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? secondaryActiveColor;
  final int? divisions;
  final String? label;

  const RiverSlider({
    required this.value,
    // optional
    this.min = 0.0,
    this.max = 1.0,
    this.onChanged,
    this.onChangeEnd,
    this.activeColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.divisions,
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RiverSliderX(
      key: ValueKey<double>(value), // <-- this is the only difference, find a way to this directly
      value: value,
      min: min,
      max: max,
      onChanged: onChanged,
      onChangeEnd: onChangeEnd,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      secondaryActiveColor: secondaryActiveColor,
      divisions: divisions,
      label: label,
    );
  }
}

class RiverSliderX extends ConsumerStatefulWidget {
  final double value;
  final double max;
  final Function? onChanged;
  final Function? onChangeEnd;

  final double? min;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? secondaryActiveColor;
  final int? divisions;
  final String? label;

  const RiverSliderX({
    required this.value,
    // optional
    this.min = 0.0,
    this.max = 1.0,
    this.onChanged,
    this.onChangeEnd,
    this.activeColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.divisions,
    this.label,
    super.key,
  });

  @override
  ConsumerState<RiverSliderX> createState() => _RiverSliderXState();
}

class _RiverSliderXState extends ConsumerState<RiverSliderX> {
  double? currentValue;
  @override
  void initState() {
    currentValue = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: currentValue!,
      max: widget.max,
      label: widget.value.round().toString(),
      divisions: widget.divisions,
      onChanged: (double value) {
        setState(() {
          currentValue = value;
        });
      },
      onChangeEnd: (double value) {
        if (widget.onChangeEnd != null) widget.onChangeEnd!(currentValue);
      },
    );
  }
}
