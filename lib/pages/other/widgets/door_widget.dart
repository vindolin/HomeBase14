import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/models/mqtt_devices.dart';

class DoorWidget extends ConsumerWidget {
  final bool miniMode;
  final String topic;

  const DoorWidget({super.key, required this.topic, this.miniMode = false});

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
        size: miniMode ? 24 : 70,
      );
    } catch (e) {
      doorIcon = FaIcon(
        FontAwesomeIcons.doorOpen,
        color: Colors.grey,
        size: miniMode ? 24 : 70,
      );

      unknown = true;
    }
    return Column(
      children: [
        doorIcon,
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
          child: Text(
            deviceName ?? topic.split('zigbee2mqtt/')[1],
            style: TextStyle(fontSize: miniMode ? 12 : 14),
          ),
        ),
        if (!miniMode)
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
