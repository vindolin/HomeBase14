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
    // final device = ref.watch(mqttDevicesProvider)[deviceId];

    final device = ref.watch(
      dualCurtainDevicesProvider.select(
        (mqttDevices) => mqttDevices[deviceId],
      ),
    );

    // we need this special provider to be able to change the value in realtime
    final positionLeftProvider = StateProvider<double>((ref) => device!.positionLeft);
    final positionRightProvider = StateProvider<double>((ref) => device!.positionRight);
    final positionLeft = ref.watch(positionLeftProvider);
    final positionRight = ref.watch(positionRightProvider);

    final deviceNames = ref.read(deviceNamesProvider);
    log('build DualCurtainDetailPage $deviceId');

    return Scaffold(
      appBar: AppBar(
        title: Text('${deviceNames[deviceId]}'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CurtainControll(
            positionLeft,
            (double value) {
              ref.read(positionLeftProvider.notifier).state = value;
              device.positionLeft = value.toDouble();
            },
            (double value) {
              device.publishState();
            },
            device!.openLeft,
            device.closeLeft,
            device.stopLeft,
            invert: true,
          ),
          CurtainControll(
            positionRight,
            (double value) {
              ref.read(positionRightProvider.notifier).state = value;
              device.positionRight = value.toDouble();
            },
            (double value) {
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
