import 'dart:ui';

import 'package:flutter/material.dart';

bool colorsClose(Color c1, Color c2, {double tolerance = 0.001}) {
  return (c1.r / 255 - c2.r / 255).abs() <= tolerance &&
      (c1.g / 255 - c2.g / 255).abs() <= tolerance &&
      (c1.b / 255 - c2.b / 255).abs() <= tolerance;
}

Color lerp3(Color a, Color b, Color c, double t) {
  return t < 0.5 ? Color.lerp(a, b, t / 0.5)! : Color.lerp(b, c, (t - 0.5) / 0.5)!;
}

Color colorClamp3(double actual, double target, colors) {
  Color finalColor = Colors.transparent;

  double position = clampDouble(actual / target, 0.0, 1.0);

  finalColor = lerp3(
    colors[0],
    colors[1],
    colors[2],
    position,
  );
  return finalColor;
}
