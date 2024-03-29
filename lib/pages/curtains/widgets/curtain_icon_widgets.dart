import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '/models/mqtt_devices.dart';

/// custom painter that draws a curtain icon
abstract class CurtainPainterBase extends CustomPainter {
  final Brightness brightness;
  CurtainPainterBase(List<double> positions, this.brightness) : super(repaint: ValueNotifier(positions));
  // all sizes are computed relativ to the icon size of 36x36
  final baseSize = 36.0;

  void drawBlinds(
    double blindsMaxHeight,
    double topBarHeight,
    double bottomBarHeight,
    double blindsPadding,
    Canvas canvas,
    Size size,
  );

  Paint blindsPaint = Paint()..color = Colors.green;
  final transPaint = Paint()..color = Colors.transparent;
  final redPaint = Paint()..color = Colors.red;

  @override
  void paint(Canvas canvas, Size size) {
    final topBarHeight = size.height / baseSize * 4.0;
    final bottomBarHeight = size.height / baseSize * 3.0;
    final blindsPadding = size.width / baseSize * 1.0;
    final blindsMaxHeight = size.height - topBarHeight - bottomBarHeight;

    blindsPaint = Paint()..color = brightness == Brightness.dark ? Colors.white : Colors.black;
    final stripDistance = size.width / baseSize * 3.0;
    final stripWidth = size.width / baseSize * 0.3;

    // left strip
    canvas.drawRect(
      Rect.fromLTRB(stripDistance, 0, stripDistance + stripWidth, size.height),
      blindsPaint,
    );
    // right strip
    canvas.drawRect(
      Rect.fromLTRB(size.width - stripDistance, 0, size.width - stripDistance - stripWidth, size.height),
      blindsPaint,
    );
    // top bar
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, topBarHeight),
      blindsPaint,
    );
    // bottom bar
    canvas.drawRect(
      Rect.fromLTRB(0, size.height - bottomBarHeight, size.width, size.height),
      blindsPaint,
    );

    drawBlinds(blindsMaxHeight, topBarHeight, bottomBarHeight, blindsPadding, canvas, size);
  }
}

/// abstract function that draws the blinds for the readl drawBlinds functions down below
void _drawBlinds(
  Canvas canvas,
  double position,
  Size size,
  double blindsMaxHeight,
  double bottomBarHeight,
  double blindsPadding,
  double startH,
  double endH,
  Paint blindsPaint,
) {
  double blindsClosedHeight = blindsMaxHeight / 100 * position;
  double offset = (blindsMaxHeight - blindsClosedHeight + bottomBarHeight);
  double blindHeight = 1.5;
  double blindSpacing = 1.0;
  for (var i = 0; i < blindsClosedHeight; i++) {
    if (i % (blindHeight + blindSpacing).toInt() == 0) {
      canvas.drawRect(
        Rect.fromLTRB(
          startH,
          size.height - i - blindHeight - offset,
          endH,
          size.height - i - offset,
        ),
        blindsPaint,
      );
    }
  }
}

/// implementation for a single curtain
class CurtainPainter extends CurtainPainterBase {
  final double position;

  CurtainPainter(this.position, brightness) : super([position], brightness);

  @override
  bool shouldRepaint(covariant CurtainPainter oldDelegate) => oldDelegate.position != position;

  @override
  void drawBlinds(
    double blindsMaxHeight,
    double topBarHeight,
    double bottomBarHeight,
    double blindsPadding,
    Canvas canvas,
    Size size,
  ) {
    _drawBlinds(
      canvas,
      position,
      size,
      blindsMaxHeight,
      bottomBarHeight,
      blindsPadding,
      blindsPadding,
      size.width - blindsPadding,
      blindsPaint,
    );
  }
}

/// implementation for dual curtains
class DualCurtainPainter extends CurtainPainterBase {
  final double positionLeft;
  final double positionRight;

  DualCurtainPainter(this.positionLeft, this.positionRight, brightness)
      : super([positionLeft, positionRight], brightness);

  @override
  bool shouldRepaint(covariant DualCurtainPainter oldDelegate) =>
      oldDelegate.positionLeft != positionLeft || oldDelegate.positionRight != positionRight;

  @override
  void drawBlinds(
    double blindsMaxHeight,
    double topBarHeight,
    double bottomBarHeight,
    double blindsPadding,
    Canvas canvas,
    Size size,
  ) {
    // left
    _drawBlinds(
      canvas,
      positionLeft,
      size,
      blindsMaxHeight,
      bottomBarHeight,
      blindsPadding,
      blindsPadding,
      size.width / 2,
      blindsPaint,
    );

    // right
    _drawBlinds(
      canvas,
      positionRight,
      size,
      blindsMaxHeight,
      bottomBarHeight,
      blindsPadding,
      size.width / 2,
      size.width - blindsPadding,
      blindsPaint,
    );

    // the middle line
    canvas.drawRect(
      Rect.fromLTRB(
        size.width / 2,
        0,
        size.width / 2 + 1,
        size.height,
      ),
      blindsPaint,
    );
  }
}

/// this widgt reacts to changes of the position and animates the curtain
class AnimatedCurtainItem extends HookWidget {
  final SingleCurtainDevice device;
  final Duration duration = const Duration(milliseconds: 3000);

  const AnimatedCurtainItem(this.device, {super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    double position = 100.0 - device.position;

    final animationController = useAnimationController(
      initialValue: position,
      duration: duration,
      lowerBound: 0.0,
      upperBound: 100.0,
    );
    useEffect(() {
      // print('${position} --- ${animationController.value}');
      if (position != animationController.value) {
        animationController.animateTo(position);
      }
      return null;
    }, [position]);

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: CurtainPainter(animationController.value, brightness),
          size: const Size(36, 36),
        );
      },
    );
  }
}

/// same only for dual curtains
class AnimatedDualCurtainItem extends HookWidget {
  final DualCurtainDevice device;
  final Duration duration = const Duration(milliseconds: 3000);

  const AnimatedDualCurtainItem(this.device, {super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    double positionLeft = 100.0 - device.positionLeft;
    double positionRight = 100.0 - device.positionRight;

    final animationControllerLeft = useAnimationController(
      initialValue: positionLeft,
      duration: duration,
      lowerBound: 0.0,
      upperBound: 100.0,
    );
    useEffect(() {
      if (positionLeft != animationControllerLeft.value) {
        animationControllerLeft.animateTo(positionLeft);
      }
      return null;
    }, [positionLeft]);

    final animationControllerRight = useAnimationController(
      initialValue: positionRight,
      duration: duration,
      lowerBound: 0.0,
      upperBound: 100.0,
    );
    useEffect(() {
      if (positionRight != animationControllerRight.value) {
        animationControllerRight.animateTo(positionRight);
      }
      return null;
    }, [positionRight]);

    return AnimatedBuilder(
      animation: Listenable.merge([
        animationControllerLeft,
        animationControllerRight,
      ]),
      builder: (context, child) {
        return CustomPaint(
          painter: DualCurtainPainter(animationControllerLeft.value, animationControllerRight.value, brightness),
          size: const Size(36, 36),
        );
      },
    );
  }
}
