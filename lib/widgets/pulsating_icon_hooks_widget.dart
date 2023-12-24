import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PulsatingIcon extends HookWidget {
  final Color color;
  final IconData iconData;
  final double size;
  final int durationSeconds;
  final double lowerBound;
  final double? initialValue;

  const PulsatingIcon({
    super.key,
    required this.iconData,
    required this.color,
    required this.size,
    this.durationSeconds = 1000,
    this.lowerBound = 0.5,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      initialValue: initialValue ?? lowerBound,
      duration: Duration(milliseconds: durationSeconds),
      lowerBound: lowerBound,
      upperBound: 1.0,
    );

    useEffect(() {
      animationController.repeat(reverse: true);
      return null;
    }, const []);

    useAnimation(
      animationController.drive(
        ColorTween(),
      ),
    );

    return Icon(
      iconData,
      color: color.withOpacity(animationController.value),
      size: size,
    );
  }
}
