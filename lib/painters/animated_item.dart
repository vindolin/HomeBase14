import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:homer/models/mqtt_devices.dart';

class ItemPainter extends CustomPainter {
  final double value;
  ItemPainter(this.value);

  final itemPaint = Paint()..color = Colors.orange;

  @override
  void paint(Canvas canvas, Size size) {
    print(value);
    // draw a circle with a size depending on the value
    double radius = size.width / 10 * value / 2;
    canvas.drawCircle(
      Offset(
        size.width / 2,
        size.height / 2,
      ),
      radius,
      itemPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ItemPainter oldDelegate) => oldDelegate.value != value;
}

class AnimatedItem extends HookWidget {
  final CurtainDevice device;
  final Duration duration = const Duration(milliseconds: 500);

  const AnimatedItem(this.device, {super.key});

  @override
  Widget build(BuildContext context) {
    double value = device.position / 10;
    print('value: $value');
    final animationController = useAnimationController(
      initialValue: value,
      duration: const Duration(milliseconds: 500),
      lowerBound: 0.0,
      upperBound: 10.0,
    );
    useEffect(() {
      if (value != animationController.value) {
        animationController.animateTo(value);
      }
      return null;
    }, [device.position]);

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: ItemPainter(animationController.value),
          size: const Size(40, 40),
        );
      },
    );
  }
}
