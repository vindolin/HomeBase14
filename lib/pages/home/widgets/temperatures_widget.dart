import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/mqtt_devices.dart';
import '/utils.dart';

class Temperatures extends ConsumerWidget {
  const Temperatures({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final mqttMessage = ref.watch(
    //   mqttMessagesProvider.select(
    //     (mqttMessages) {
    //       log(mqttMessages);
    //       return mqttMessages['greenhouse/temp_inside'];
    //     },
    //   ),
    // );
    // if (simpleMqttMessage?.payload != null) {
    //   print(simpleMqttMessage?.payload);
    //   dropdownValue = simpleMqttMessage!.payload;
    // }

    // final tempInside = mqttMessage?.payload ?? '-.-';

    return Card(
      child: Column(
        children: [
          // Text(tempInside),
          // Text('Humidity'),
        ],
      ),
    );
  }
}
