import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/utils.dart';
import '/models/mqtt_providers.dart';
import '/widgets/vertical_slider_widget.dart';

class CurtainDetailPage extends ConsumerWidget {
  final String deviceId;

  const CurtainDetailPage({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final device = ref.watch(mqttDevicesProvider)[deviceId];
    final device = ref.watch(
      mqttDevicesProvider.select(
        (mqttDevices) => mqttDevices[deviceId],
      ),
    );
    final deviceNames = ref.read(deviceNamesProvider);
    log('build CurtainDetailPage');
    // log(device['position']);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Curtain'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            VerticalSlider(
              // device['position'].toDouble(), // invert
              device['position'].toDouble(),
              (double value) {
                // setState(
                //   () => device.position = value.round().toDouble(),
                // );
              },
              (double value) {
                // device.publishState();
              },
              invert: true,
            ),
            Center(
              child: Text('${deviceNames[deviceId]}\n$deviceId\n${device['_device_type']}\n${device['position']}'),
            ),
          ],
        ));
  }
}
