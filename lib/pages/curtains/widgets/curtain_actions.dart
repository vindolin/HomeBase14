import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/mqtt_providers.dart';

List<Widget> curtainActions(BuildContext context, WidgetRef ref) {
  return [
    IconButton(
      onPressed: () => ref.read(mqttProvider.notifier).publish('home/curtains', 'open'),
      icon: const Icon(Icons.arrow_circle_up),
    ),
    IconButton(
      onPressed: () => ref.read(mqttProvider.notifier).publish('home/curtains', 'stop'),
      icon: const Icon(Icons.pause_circle_outline),
    ),
    IconButton(
      onPressed: () => ref.read(mqttProvider.notifier).publish('home/curtains', 'close'),
      icon: const Icon(Icons.arrow_circle_down),
    ),
  ];
}
