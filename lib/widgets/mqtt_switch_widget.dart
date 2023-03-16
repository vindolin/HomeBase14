import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/mqtt_devices.dart';
import '/models/mqtt_providers.dart';

class MqttSwitchWidget extends ConsumerStatefulWidget {
  final String title;
  final String id;
  final String statTopic;
  final String setTopic;
  final bool optimistic;

  const MqttSwitchWidget({
    required this.title,
    required this.id,
    required this.statTopic,
    required this.setTopic,
    this.optimistic = false,
    super.key,
  });

  @override
  ConsumerState<MqttSwitchWidget> createState() => _MqttSwitchWidgetState();
}

class _MqttSwitchWidgetState extends ConsumerState<MqttSwitchWidget> {
  bool? switchState;

  @override
  Widget build(BuildContext context) {
    if (widget.optimistic && switchState == null || !widget.optimistic) {
      switchState = ref.watch(mqttMessagesFamProvider(widget.statTopic)) == 'ON' ? true : false;
    }

    return Switch(
      value: switchState ?? false,
      onChanged: (value) {
        if (widget.optimistic) {
          setState(() {
            switchState = value;
          });
        }
        ref.read(mqttProvider.notifier).publish(widget.setTopic, switchState == false ? 'ON' : 'OFF');
      },
    );
  }
}
