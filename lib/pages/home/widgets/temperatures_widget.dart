import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/styles/text_styles.dart';
import '/models/mqtt_devices.dart';
import '/utils.dart';

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
  return Text(
    '$prefix$tempValue °C',
    style: textStyleShadowOne.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: color,
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

    return Card(
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            const Icon(Icons.thermostat),
            Column(
              children: [
                temperature('', tempInside, Colors.blue),
                temperature('', tempOutside, Colors.green),
                // Text(humidity),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
