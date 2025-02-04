import 'dart:ui';

bool colorsClose(Color c1, Color c2, {double tolerance = 0.001}) {
  return (c1.r / 255 - c2.r / 255).abs() <= tolerance &&
      (c1.g / 255 - c2.g / 255).abs() <= tolerance &&
      (c1.b / 255 - c2.b / 255).abs() <= tolerance;
}
