import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/utils.dart';
import '/widgets/vertical_slider_widget.dart';
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
    final positionLeft = ref.watch(positionLeftProvider);
    // final positionRightProvider = StateProvider<double>((ref) => device!.positionLeft);
    // final positionRight = ref.watch(positionRightProvider);

    final deviceNames = ref.read(deviceNamesProvider);
    log('build DualCurtainDetailPage');

    return Scaffold(
        appBar: AppBar(
          title: const Text('DualCurtain'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            VerticalSlider(
              positionLeft,
              (double value) {
                ref.read(positionLeftProvider.notifier).state = value;
                device?.positionLeft = value.round().toDouble();
              },
              (double value) {
                device?.publishState();
              },
              invert: true,
            ),
            Center(
              child: Text(
                '${deviceNames[deviceId]}\n$deviceId\n${device!.deviceType}\n${device.positionLeft}',
              ),
            ),
          ],
        ));
  }
}
