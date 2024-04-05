import 'dart:async';
import 'package:flutter/material.dart';

import '/widgets/shader_widget.dart';

const shaders = [
  ['plasma_cube.frag', <double>[], 1.0],
  ['spiral.frag', <double>[], 1.0],
  [
    'flubber.frag',
    [
      ...[0.16, 0.49, .24] /* light1 */,
      ...[.19, .9, .03] /* light2 */,
    ],
    4.0
  ],
  [
    'pulsing_guts.frag',
    [
      ...[4.0, 2.0, 1.0] /* color */,
    ],
    6.0
  ],
];

class ShaderButton extends StatefulWidget {
  const ShaderButton({super.key});

  @override
  ShaderButtonState createState() => ShaderButtonState();
}

class ShaderButtonState extends State<ShaderButton> {
  Timer? _timer;
  int _shaderIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (Timer t) => setState(
        () {
          _shaderIndex = (_shaderIndex + 1) % shaders.length;
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final [shader, parameters, slowDown] = shaders[_shaderIndex];

    return ShaderBox(
      shader as String,
      parameters: parameters as List<double>,
      slowDown: slowDown as double,
    );
  }
}
