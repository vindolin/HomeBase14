import 'package:flutter/material.dart';
import '../painters/curtain_icon_painters.dart';

CustomPaint curtainIcon(double position) {
  return CustomPaint(
    painter: CurtainPainter(position),
    size: const Size(24, 24),
  );
}

CustomPaint dualCurtainIcon(double leftPosition, double rightPosition) {
  return CustomPaint(
    painter: DualCurtainPainter(leftPosition, rightPosition),
    size: const Size(24, 24),
  );
}
