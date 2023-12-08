import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/mqtt_devices.dart';
import 'curtain_controll_widget.dart';

class CurtainWidget extends ConsumerWidget {
  final String deviceId;

  const CurtainWidget({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(
      singleCurtainDevicesProvider.select(
        (mqttDevices) => mqttDevices[deviceId],
      ),
    )!;

    final deviceName = ref.watch(deviceNamesProvider)[device.deviceId];

    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Text('$deviceName', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CurtainControll(
                device.position,
                (double value) {
                  device.position = value.toDouble();
                  device.publishState();
                },
                device.open,
                device.close,
                device.stop,
                invert: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
