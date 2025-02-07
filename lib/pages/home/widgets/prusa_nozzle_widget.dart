import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '/util/color.dart';
import '/models/mqtt_devices.dart';

const onDurationMs = 2500;
const fadeDurationMs = 500;
const nozzleColors = [
  Color.fromARGB(255, 50, 50, 255),
  Color.fromARGB(255, 255, 173, 50),
  Color.fromARGB(255, 255, 50, 50),
];

class PrusaNozzle extends ConsumerWidget {
  const PrusaNozzle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prusa = ref.watch(prusaProvider.select(
      // IMap is important here or select cannot compare the values and the widget would rebuild on changes to other attributes e.g. 'percent_done'
      (prusa) => IMap({
        'extruder_actual': prusa['extruder_actual'],
        'extruder_target': prusa['extruder_target'],
      }),
    ));

    Color nozzleColor = Colors.transparent;
    if (prusa['extruder_target'] > 0) {
      nozzleColor = colorClamp3(
        prusa['extruder_actual'],
        prusa['extruder_target'],
        nozzleColors,
      );
    }

    Color? targetColor;

    Future<void> setColor() async {
      targetColor = nozzleColor; // flash color
      await Future.delayed(const Duration(milliseconds: onDurationMs));
      targetColor = Colors.transparent; // and back to transparent
    }

    // nozzleColor = Colors.white;

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
              'assets/images/svg/nozzle.svg',
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
