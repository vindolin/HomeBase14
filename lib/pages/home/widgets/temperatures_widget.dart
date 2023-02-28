import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bordered_text/bordered_text.dart';

import '/models/mqtt_devices.dart';

dynamic getMessage(ProviderBase provider, WidgetRef ref, String topic) {
  dynamic payload;
  final mqttMessage = ref.watch(
    provider.select(
      (mqttMessages) {
        return mqttMessages[topic];
      },
    ),
  );
  if (mqttMessage?.payload != null) {
    payload = mqttMessage!.payload;
  }

  return payload;
}

Widget temperature(String prefix, double? value, Color? color) {
  String tempValue = value != null ? value.toStringAsFixed(1) : '-.-';
  return BorderedText(
    strokeWidth: 3,
    strokeColor: Colors.black,
    child: Text(
      '$prefix$tempValue°C',
      style: GoogleFonts.robotoCondensed(
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color, shadows: const [
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 1.0,
            color: Colors.black,
          ),
        ]),
      ),
    ),
  );
}

class Temperatures extends ConsumerWidget {
  const Temperatures({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double? tempInside = double.tryParse(
      getMessage(mqttMessagesProvider, ref, 'greenhouse/temp_inside') ?? '',
    );
    double? tempOutside = double.tryParse(
      getMessage(mqttMessagesProvider, ref, 'greenhouse/temp_outside') ?? '',
    );
    // final humidity = checkMessage(mqttMessagesProvider, ref, 'greenhouse/humidity') ?? '-.-';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        temperature('', tempInside, Colors.blue),
        temperature('', tempOutside, Colors.green),
        // Text(humidity),
      ],
    );
  }
}
