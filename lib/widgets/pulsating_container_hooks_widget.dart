import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
        Tween(
          begin: 0.0,
          end: 1.0,
        ),
      ),
    );
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(animationController.value),
            spreadRadius: 3,
            blurRadius: 3,
          ),
        ],
      ),
    );
  }
}
