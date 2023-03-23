import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:decorated_icon/decorated_icon.dart';

import '/models/mqtt_providers.dart';

void onPressed(WidgetRef ref, String? deviceName, String topic, String stateLc) {
  if (deviceName == null) {
    ref.read(mqttProvider.notifier).publish(topic, stateLc);
  } else {
    if (deviceName.startsWith('dualCurtain')) {
      ref.read(mqttProvider.notifier).publish(topic, '{"state_left": "${stateLc.toUpperCase()}"}');
      ref.read(mqttProvider.notifier).publish(topic, '{"state_right": "${stateLc.toUpperCase()}"}');
    } else {
      ref.read(mqttProvider.notifier).publish(topic, '{"state": "${stateLc.toUpperCase()}" }');
    }
  }
}

List<Widget> curtainActions(BuildContext context, WidgetRef ref, [String? deviceName]) {
  final topic = deviceName == null ? 'home/curtains' : 'zigbee2mqtt/$deviceName/set';
  return [
    IconButton(
      onPressed: () {
        onPressed(ref, deviceName, topic, 'close');
      },
      icon: const DecoratedIcon(
        Icons.arrow_circle_down,
        shadows: [
          BoxShadow(
            blurRadius: 2.0,
            color: Colors.black,
            offset: Offset(1.0, 1.0),
          ),
        ],
      ),
    ),
    IconButton(
      onPressed: () {
        onPressed(ref, deviceName, topic, 'stop');
      },
      icon: const DecoratedIcon(
        Icons.pause_circle_outline,
        shadows: [
          BoxShadow(
            blurRadius: 2.0,
            color: Colors.black,
            offset: Offset(1.0, 1.0),
          ),
        ],
      ),
    ),
    IconButton(
      onPressed: () {
        onPressed(ref, deviceName, topic, 'open');
      },
      icon: const DecoratedIcon(
        Icons.arrow_circle_up,
        shadows: [
          BoxShadow(
            blurRadius: 2.0,
            color: Colors.black,
            offset: Offset(1.0, 1.0),
          ),
        ],
      ),
    ),
  ];
}
