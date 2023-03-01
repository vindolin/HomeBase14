import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

    // nozzleColor = Colors.white;
    const String assetName = 'assets/images/svg/nozzle.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
      colorFilter: ColorFilter.mode(nozzleColor, BlendMode.srcIn),
      // color: nozzleColor,
      width: 16,
      height: 16,
    );
    return svg;
  }
}
