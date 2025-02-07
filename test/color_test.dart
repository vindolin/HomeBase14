import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:home_base_14/util/color.dart';

void main() {
  bool colorsClose(Color c1, Color c2, {double tolerance = 0.001}) {
    return (c1.r / 255 - c2.r / 255).abs() <= tolerance &&
        (c1.g / 255 - c2.g / 255).abs() <= tolerance &&
        (c1.b / 255 - c2.b / 255).abs() <= tolerance;
  }

  group('lerp3 Tests', () {
    test('lerp3 interpolates between three colors', () {
      const a = Color(0xFFFF0000); // Red
      const b = Color(0xFF0000FF); // Blue
      const c = Color(0xFF00FF00); // Green

      final result0 = lerp3(a, b, c, 0.0);
      final result25 = lerp3(a, b, c, 0.25);
      final result50 = lerp3(a, b, c, 0.5);
      final result75 = lerp3(a, b, c, 0.75);
      final result100 = lerp3(a, b, c, 1.0);

      expect(colorsClose(result0, a), isTrue);
      expect(colorsClose(result25, Color.lerp(a, b, 0.5)!), isTrue);
      expect(colorsClose(result50, b), isTrue);
      expect(colorsClose(result75, Color.lerp(b, c, 0.5)!), isTrue);
      expect(colorsClose(result100, c), isTrue);
    });
  });
}
