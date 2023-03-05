import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/generic_providers.dart';

var time = .0;

class ShaderPainter extends CustomPainter {
  ShaderPainter({required this.shader});
  ui.FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    time += .01;
    [
      time,
      size.width / 1.5,
      size.height / 1.5,
      0.203,
      0.390,
      0.349,
      .19,
      .9,
      .03,
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

class Plasma extends ConsumerWidget {
  const Plasma({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool showPlasma = ref.watch(togglerProvider('plasma'));

    return ProviderScope(
      // overrides: [
      //   togglerProvider,
      // ],
      child: InkWell(
        onTap: () => ref.read(togglerProvider('plasma').notifier).toggle(),
        child: showPlasma
            ? ShaderBuilder(
                assetKey: 'shaders/plasma.frag',
                (context, shader, child) => TimerBuilder.periodic(
                  const Duration(milliseconds: 16),
                  builder: (context) {
                    return CustomPaint(
                      size: MediaQuery.of(context).size,
                      painter: ShaderPainter(
                        shader: shader,
                      ),
                    );
                  },
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(),
      ),
    );
  }
}
