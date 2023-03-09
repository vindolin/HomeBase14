import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/mqtt_providers.dart';

List<Widget> curtainActions(BuildContext context, WidgetRef ref, [String? deviceName]) {
  final topic = deviceName == null ? 'home/curtains' : 'zigbee2mqtt/$deviceName/set';
  return [
    // TODOs move publish to mqtt_devices.dart
    IconButton(
      onPressed: () {
        ref.read(mqttProvider.notifier).publish(topic, deviceName != null ? '{"state": "OPEN" }' : 'open');
      },
      icon: const Icon(Icons.arrow_circle_up),
    ),
    IconButton(
      onPressed: () {
        ref.read(mqttProvider.notifier).publish(topic, deviceName != null ? '{"state": "STOP" }' : 'stop');
      },
      icon: const Icon(Icons.pause_circle_outline),
    ),
    IconButton(
      onPressed: () {
        ref.read(mqttProvider.notifier).publish(topic, deviceName != null ? '{"state": "CLOSE" }' : 'close');
      },
      icon: const Icon(Icons.arrow_circle_down),
    ),
  ];
}
