import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PulsatingIcon extends HookWidget {
  final Color color;
  final IconData iconData;
  const PulsatingIcon({
    super.key,
    required this.iconData,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0.5,
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
      size: 36,
    );
  }
}
