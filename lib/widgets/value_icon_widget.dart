import 'package:flutter/material.dart';
import '/utils.dart';

enum IconType {
  // cellular, // 0-4
  wifi, // 0-6
  battery, //0-6
}

/// TODOs refactor, make more generic!
class ValueIcon extends StatelessWidget {
  final int value;
  final IconType type;
  ValueIcon(this.type, this.value, {super.key});

  final iconsBattery = [
    Icons.battery_0_bar,
    Icons.battery_1_bar,
    Icons.battery_2_bar,
    Icons.battery_3_bar,
    Icons.battery_4_bar,
    Icons.battery_5_bar,
    Icons.battery_6_bar,
  ];

  final iconsWifi = [
    Icons.signal_wifi_statusbar_null,
    Icons.network_wifi_1_bar,
    Icons.network_wifi_2_bar,
    Icons.network_wifi_3_bar,
    Icons.signal_wifi_statusbar_4_bar,
  ];

  @override
  Widget build(BuildContext context) {
    Icon makeIcon(IconData iconData) {
      return Icon(
        iconData,
        color: Colors.green,
        size: 16,
      );
    }

    return switch (type) {
      IconType.battery => makeIcon(
          iconsBattery[mapValue(
            value.toDouble(),
            0.0,
            100.0,
            0.0,
            iconsBattery.length.toDouble(),
          ).round()],
        ),
      IconType.wifi => makeIcon(
          iconsWifi[mapValue(
            value.toDouble(),
            0.0,
            255.0,
            0.0,
            iconsWifi.length.toDouble(),
          ).round()],
        ),
    };
  }
}
