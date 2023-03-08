import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:timer_builder/timer_builder.dart';

class ShaderPainter extends CustomPainter {
  final List<double> parameters;
  late double startTime;
  double slowDown;
  ShaderPainter(this.shader, this.startTime, this.slowDown, {this.parameters = const []});

  ui.FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    [
      (DateTime.now().millisecondsSinceEpoch.toDouble() / 1000 - startTime) / slowDown,
      size.width,
      size.height,
      ...parameters,
    ].asMap().entries.map(
      (entry) {
        shader.setFloat(entry.key, entry.value);
      },
    ).toList();
    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Offset.zero & size,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ShaderWidget extends StatelessWidget {
  final List<double> parameters;
  final String shader;
  final double slowDown;
  const ShaderWidget(this.shader, {this.parameters = const [], this.slowDown = 1.0, super.key});

  @override
  Widget build(BuildContext context) {
    final double time = DateTime.now().millisecondsSinceEpoch.toDouble() / 1000;

    return ShaderBuilder(
      assetKey: 'shaders/$shader',
      (context, shader, child) => TimerBuilder.periodic(
        const Duration(milliseconds: 10),
        builder: (context) {
          return CustomPaint(
            size: MediaQuery.of(context).size,
            painter: ShaderPainter(
              shader,
              time,
              slowDown,
              parameters: parameters,
            ),
          );
        },
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ShaderBox extends StatefulWidget {
  final List<double> parameters;
  final String shader;
  final double slowDown;
  const ShaderBox(this.shader, {this.parameters = const [], this.slowDown = 1.0, super.key});

  @override
  State<ShaderBox> createState() => _ShaderBoxState();
}

class _ShaderBoxState extends State<ShaderBox> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => setState(() {
          visible = !visible;
        }),
        child: visible
            ? ShaderWidget(widget.shader, parameters: widget.parameters, slowDown: widget.slowDown)
            : Container(),
      ),
    );
  }
}
