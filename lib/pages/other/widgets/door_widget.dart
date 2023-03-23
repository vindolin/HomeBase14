import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:decorated_icon/decorated_icon.dart';

import '/models/mqtt_devices.dart';

Widget iconWrapper(IconData icon, Color color, double size) {
  return DecoratedIcon(
    icon,
    color: color,
    size: size,
    shadows: const [
      BoxShadow(
        blurRadius: 2.0,
        color: Colors.black,
        offset: Offset(1.0, 1.0),
      ),
    ],
  );
}

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
      doorIcon = iconWrapper(
        contact ? FontAwesomeIcons.doorClosed : FontAwesomeIcons.doorOpen,
        contact ? Colors.green : Colors.red,
        miniMode ? 24 : 70,
      );
    } catch (e) {
      doorIcon = iconWrapper(
        FontAwesomeIcons.doorOpen,
        Colors.grey,
        miniMode ? 24 : 70,
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
