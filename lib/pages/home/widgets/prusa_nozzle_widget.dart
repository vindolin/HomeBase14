import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '/models/mqtt_devices.dart';

class Dummy extends Widget {
  const Dummy({super.key});

  @override
  Element createElement() {
    throw UnimplementedError();
  }
}

const nozzleColors = [
  Color.fromARGB(255, 50, 50, 255),
  Color.fromARGB(255, 255, 173, 50),
  Color.fromARGB(255, 255, 50, 50),
];

class PrusaNozzle extends ConsumerWidget {
  const PrusaNozzle({super.key});

  Color lerp3(Color a, Color b, Color c, double t) {
    return t < 0.5 ? Color.lerp(a, b, t / 0.5)! : Color.lerp(b, c, (t - 0.5) / 0.5)!;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const int onDurationMs = 2500;
    const int fadeDurationMs = 500;

    final prusa = ref.watch(prusaProvider.select(
      // IMap is important here or select cannot compare the values and the widget would rebuild on changes to other attributes e.g. 'percent_done'
      (prusa) => IMap({
        'extruder_actual': prusa['extruder_actual'],
        'extruder_target': prusa['extruder_target'],
      }),
    ));

    Color nozzleColor = Colors.transparent;

    if (prusa['extruder_actual']! > 0 && prusa['extruder_target']! > 0.0) {
      final redFactor = (prusa['extruder_actual']! / prusa['extruder_target']!);
      nozzleColor = lerp3(
        nozzleColors[0],
        nozzleColors[1],
        nozzleColors[2],
        redFactor,
      );
    }

    Color? targetColor;

    Future<void> setColor() async {
      targetColor = nozzleColor; // flash color
      await Future.delayed(const Duration(milliseconds: onDurationMs));
      targetColor = Colors.transparent; // and back to transparent
    }

    // nozzleColor = Colors.white;
    const String assetName = 'assets/images/svg/nozzle.svg';

    return FutureBuilder<void>(
      future: setColor(),
      builder: (context, AsyncSnapshot<void> _) {
        return TweenAnimationBuilder<Color?>(
          tween: ColorTween(
            begin: null,
            end: targetColor,
          ),
          duration: const Duration(milliseconds: fadeDurationMs),
          curve: Curves.easeInOut,
          builder: (
            BuildContext context,
            Color? nozzleColor,
            Widget? child,
          ) {
            return SvgPicture.asset(
              assetName,
              colorFilter: ColorFilter.mode(nozzleColor!, BlendMode.srcIn),
              width: 16,
              height: 16,
            );
          },
        );
      },
    );
  }
}
