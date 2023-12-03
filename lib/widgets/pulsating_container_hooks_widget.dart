import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// same widget as PulsatingContainer but using flutter_hooks
class PulsatingContainer extends HookWidget {
  final Color color;
  const PulsatingContainer({
    this.color = Colors.red,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0.0,
      upperBound: 0.3,
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(animationController.value),
            spreadRadius: 4,
            blurRadius: 5,
          ),
        ],
      ),
    );
  }
}
