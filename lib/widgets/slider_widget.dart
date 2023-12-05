import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// TODOs
// this is a wrapper for the actual RiverSliderConsumer widget
// this only set's the key to the value of the slider because
// How do I set the key from the value?
class SliderWidget extends StatelessWidget {
  final double value;
  final Function? onChanged;
  final Function? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Color? minColor;
  final Color? maxColor;
  final Color? inactiveColor;
  final double? secondaryTrackValue;
  final Color? secondaryActiveColor;

  const SliderWidget({
    required this.value,
    // optional
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.onChangeEnd,
    this.minColor,
    this.maxColor,
    this.inactiveColor,
    this.secondaryTrackValue,
    this.secondaryActiveColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RiverSliderHook(
      key: ValueKey<double>(value), // <-- this is the only difference, find a way to this directly
      value: value,
      onChanged: onChanged,
      onChangeEnd: onChangeEnd,
      min: min,
      max: max,
      divisions: divisions,
      label: label,
      minColor: minColor,
      maxColor: maxColor,
      inactiveColor: inactiveColor,
      secondaryTrackValue: secondaryTrackValue,
      secondaryActiveColor: secondaryActiveColor,
    );
  }
}

// Stateful widget version
class RiverSliderWrapped extends StatefulWidget {
  final double value;
  final Function? onChanged;
  final Function? onChangeEnd;

  final double min;
  final double max;
  final Color? minColor;
  final Color? maxColor;
  final Color? inactiveColor;
  final Color? secondaryActiveColor;
  final int? divisions;
  final String? label;

  const RiverSliderWrapped({
    required this.value,
    // optional
    this.onChanged,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.minColor,
    this.maxColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    super.key,
  });

  @override
  State<RiverSliderWrapped> createState() => _RiverSliderWrappedState();
}

class _RiverSliderWrappedState extends State<RiverSliderWrapped> {
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
      onChanged: (double value) {
        setState(() {
          currentValue = value;
        });
      },
      onChangeEnd: (double value) {
        if (widget.onChangeEnd != null) widget.onChangeEnd!(currentValue);
      },
      max: widget.max,
      divisions: widget.divisions,
      label: currentValue!.round().toString(),
      activeColor: Color.lerp(widget.minColor, widget.maxColor, currentValue! / widget.max),
      inactiveColor: widget.inactiveColor,
    );
  }
}

// same as above but using hooks
class RiverSliderHook extends HookWidget {
  final double value;
  final Function? onChanged;
  final Function? onChangeEnd;

  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Color? minColor;
  final Color? maxColor;
  final Color? inactiveColor;
  final double? secondaryTrackValue;
  final Color? secondaryActiveColor;

  const RiverSliderHook({
    required this.value,
    // optional
    this.onChanged,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.minColor,
    this.maxColor,
    this.inactiveColor,
    this.secondaryTrackValue,
    this.secondaryActiveColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentValue = useState(value);

    return Slider(
      value: currentValue.value,
      onChanged: (double value) {
        currentValue.value = value;
      },
      onChangeEnd: (double value) {
        if (onChangeEnd != null) onChangeEnd!(currentValue.value);
      },
      min: min,
      max: max,
      divisions: divisions,
      label: currentValue.value.round().toString(),
      activeColor: Color.lerp(minColor, maxColor, currentValue.value / max),
      inactiveColor: inactiveColor,
      secondaryTrackValue: secondaryTrackValue,
      secondaryActiveColor: secondaryActiveColor,
    );
  }
}
