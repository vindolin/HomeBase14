// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/mqtt_providers.dart';
import '/models/mqtt_devices.dart';

enum MqttSwitchWidgetOrientation {
  horizontal,
  vertical,
}

class MqttSwitchWidget extends ConsumerStatefulWidget {
  final String title;
  final String statTopic;
  final String setTopic;
  final String onPayload;
  final String offPayload;
  final bool optimistic;
  final MqttSwitchWidgetOrientation orientation;

  const MqttSwitchWidget({
    required this.title,
    required this.statTopic,
    required this.setTopic,
    this.onPayload = 'ON',
    this.offPayload = 'OFF',
    this.optimistic = false,
    this.orientation = MqttSwitchWidgetOrientation.vertical,
    super.key,
  });

  @override
  ConsumerState<MqttSwitchWidget> createState() => _MqttSwitchWidgetState();
}

class _MqttSwitchWidgetState extends ConsumerState<MqttSwitchWidget> {
  bool switching = false;
  bool? switchState;
  bool optimisticSwitchState = false;

  Widget wrapper(Widget child, MqttSwitchWidgetOrientation orientation) {
    return orientation == MqttSwitchWidgetOrientation.vertical
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.title),
              child,
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.title),
              child,
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    switchState = ref.watch(mqttMessagesFamProvider(widget.statTopic)) == widget.onPayload ? true : false;

    bool? switchValue;
    if (widget.optimistic) {
      // if switching comes from the outside, use the switch state, else use the optimistic switch state
      switchValue = switching ? optimisticSwitchState : switchState;
      switching = false; // reset
    } else {
      switchValue = switchState;
    }

    return wrapper(
      // otimisticSwitchState
      // widget.switching ? optmisticSwitchState : switchState
      Switch(
        value: switchValue ?? false,
        onChanged: (value) {
          if (widget.optimistic) {
            // instantly set the switch state, don't wait for aknowledgement message
            setState(() {
              optimisticSwitchState = value;
              switching = true;
            });
          }
          ref.read(mqttProvider.notifier).publish(
                widget.setTopic,
                value ? widget.onPayload : widget.offPayload,
              );
        },
      ),
      widget.orientation,
    );
  }
}
