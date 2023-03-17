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
  bool? switchState;

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
    if (widget.optimistic) {
      // only watch the state on the first build when switchState is not yet set
      switchState ??= ref.watch(mqttMessagesFamProvider(widget.statTopic)) == widget.onPayload ? true : false;
    } else {
      switchState = ref.watch(mqttMessagesFamProvider(widget.statTopic)) == widget.onPayload ? true : false;
    }

    return wrapper(
      Switch(
        value: switchState ?? false,
        onChanged: (value) {
          if (widget.optimistic) {
            // instantly set the switch state, don't wait for aknowledgement message
            setState(() {
              switchState = value;
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
