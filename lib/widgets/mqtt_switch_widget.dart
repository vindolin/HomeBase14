import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/mqtt_devices.dart';
import '/models/mqtt_providers.dart';

class MqttSwitchWidget extends ConsumerWidget {
  final String title;
  final String id;
  final String statTopic;
  final String setTopic;

  const MqttSwitchWidget({
    required this.title,
    required this.id,
    required this.statTopic,
    required this.setTopic,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final switchState = ref.watch(mqttMessagesFamProvider(statTopic)) ?? 'OFF';

    return Switch(
      value: switchState == 'ON',
      onChanged: (value) {
        ref.read(mqttProvider.notifier).publish(setTopic, switchState);
      },
    );
  }
}
