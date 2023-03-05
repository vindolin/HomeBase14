import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/models/mqtt_providers.dart';
import '/models/mqtt_devices.dart';
import '/models/watch_mqtt_message.dart';

class PrusaNozzle extends ConsumerWidget {
  const PrusaNozzle({super.key});

  Map<String, double> getTempData(ref) {
    Map<String, double> retVal = {'extruder_actual': 0, 'extruder_target': 0};
    try {
      String payload = watchMqttMessage(mqttMessagesProvider, ref, 'prusa/temp');
      Map<String, dynamic> payloadDecoded = jsonDecode(payload);
      retVal['extruder_actual'] = double.parse(payloadDecoded['extruder_actual']);
      retVal['extruder_target'] = double.parse(payloadDecoded['extruder_target']);
    } catch (_) {}
    return retVal;
  }

  Color lerp3(Color a, Color b, Color c, double t) {
    return t < 0.5 ? Color.lerp(a, b, t / 0.5)! : Color.lerp(b, c, (t - 0.5) / 0.5)!;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const int onDurationMs = 2500;
    const int fadeDurationMs = 500;

    final progressData = getTempData(ref);
    // final progressData = {'extruder_actual': 170.0, 'extruder_target': 200.0};
    Color nozzleColor = Colors.transparent;

    if (progressData['extruder_actual']! > 0 && progressData['extruder_target']! > 0.0) {
      final redFactor = (progressData['extruder_actual']! / progressData['extruder_target']!);
      nozzleColor = lerp3(
        const Color.fromARGB(255, 50, 50, 255),
        const Color.fromARGB(255, 255, 173, 50),
        const Color.fromARGB(255, 255, 50, 50),
        redFactor,
      );
    }

    Color? targetColor;

    Future<void> setColor() async {
      targetColor = nozzleColor; // flash color
      await Future.delayed(const Duration(milliseconds: onDurationMs));
      targetColor = Colors.transparent; // and back to transparent
    }

    ref.watch(nozzleBlinkProvider); // every time message stream provider fires, the icon will blink

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
