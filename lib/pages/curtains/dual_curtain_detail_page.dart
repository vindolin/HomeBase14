import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/utils.dart';
import 'widgets/curtain_controll_widget.dart';
import '/models/mqtt_devices.dart';

class DualCurtainDetailPage extends ConsumerWidget {
  final String deviceId;

  const DualCurtainDetailPage({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(
      dualCurtainDevicesProvider.select(
        (mqttDevices) => mqttDevices[deviceId],
      ),
    )!;

    final deviceNames = ref.watch(deviceNamesProvider);
    log('build DualCurtainDetailPage $deviceId');

    return Scaffold(
      appBar: AppBar(
        title: Text('${deviceNames[deviceId]}'),
      ),
      body: Row(
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(deviceId, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
