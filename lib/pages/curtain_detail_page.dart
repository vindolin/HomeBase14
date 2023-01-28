import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/utils.dart';
import '/models/mqtt_providers.dart';
import '/widgets/vertical_slider_widget.dart';
import '/models/mqtt_devices.dart';

class CurtainDetailPage extends ConsumerWidget {
  final String deviceId;

  const CurtainDetailPage({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final device = ref.watch(mqttDevicesProvider)[deviceId];

    final device = ref.watch(
      curtainDevicesProvider.select(
        (mqttDevices) => mqttDevices[deviceId],
      ),
    );

    // we need this special provider to be able to change the value in realtime
    final positionProvider = StateProvider<double>((ref) => device!.position);
    final position = ref.watch(positionProvider);

    final deviceNames = ref.read(deviceNamesProvider);
    log('build CurtainDetailPage');

    return Scaffold(
        appBar: AppBar(
          title: const Text('Curtain'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            VerticalSlider(
              position,
              (double value) {
                ref.read(positionProvider.notifier).state = value;
                device?.position = value.round().toDouble();
              },
              (double value) {
                device?.publishState();
              },
              invert: true,
            ),
            Center(
              child: Text(
                '${deviceNames[deviceId]}\n$deviceId\n${device!.deviceType}\n${device.position}',
              ),
            ),
          ],
        ));
  }
}
