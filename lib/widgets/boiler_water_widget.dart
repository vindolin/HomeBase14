import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/mqtt_devices.dart';

/// A widget that displays the boiler water temperature and an icon representing a shower.
/// The color of the icon and the temperature text are based on the current boiler water temperature.
class BoilerWaterWidget extends ConsumerWidget {
  const BoilerWaterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boilerTemp = (ref.watch(mqttMessagesFamProvider('home/boiler_temp')) ?? 0).toInt();

    const minTemp = 20;
    const maxTemp = 60;

    final boilerColor = Color.lerp(
      Colors.blue,
      Colors.red,
      (boilerTemp - minTemp) / (maxTemp - minTemp),
    );

    return Row(children: [
      Icon(
        Icons.shower,
        color: boilerColor,
      ),
      Text(
        boilerTemp.toString(),
        style: TextStyle(
          color: boilerColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      )
    ]);
  }
}
