import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'curtain_controll_widget.dart';
import '/models/mqtt_devices.dart';

class DualCurtainWidget extends ConsumerWidget {
  final String deviceId;

  const DualCurtainWidget({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(
      dualCurtainDevicesProvider.select(
        (mqttDevices) => mqttDevices[deviceId],
      ),
    )!;

    final deviceName = ref.watch(deviceNamesProvider)[device.deviceId];

    return Column(
      children: [
        Text('$deviceName', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CurtainControll(
                device.positionLeft,
                (double value) {
                  device.positionLeft = value.toDouble();
                  device.publishState();
                },
                device.openLeft,
                device.closeLeft,
                device.stopLeft,
                invert: true,
              ),
              CurtainControll(
                device.positionRight,
                (double value) {
                  device.positionRight = value.toDouble();
                  device.publishState();
                },
                device.openRight,
                device.closeRight,
                device.stopRight,
                invert: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
