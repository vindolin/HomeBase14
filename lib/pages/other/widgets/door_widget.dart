import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/models/mqtt_devices.dart';

class DoorWidget extends ConsumerWidget {
  final String topic;

  const DoorWidget({super.key, required this.topic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final door = ref.watch(mqttMessagesFamProvider(topic));
    final deviceNames = ref.watch(deviceNamesProvider);
    final deviceName = deviceNames[topic.split('zigbee2mqtt/')[1]];

    bool contact = false;
    Widget doorIcon;
    bool unknown = false;
    try {
      contact = door['contact'];
      doorIcon = FaIcon(
        contact ? FontAwesomeIcons.doorClosed : FontAwesomeIcons.doorOpen,
        color: contact ? Colors.green : Colors.red,
        size: 70,
      );
    } catch (e) {
      doorIcon = const FaIcon(
        FontAwesomeIcons.doorOpen,
        color: Colors.grey,
        size: 70,
      );

      unknown = true;
    }
    return Column(
      children: [
        doorIcon,
        Text(deviceName ?? topic.split('zigbee2mqtt/')[1]),
        Text(
          unknown
              ? '???'
              : contact
                  ? 'zu'
                  : 'auf',
        ),
      ],
    );
  }
}
