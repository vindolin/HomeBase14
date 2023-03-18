import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/utils.dart';
import '/models/mqtt_devices.dart';
import 'widgets/curtain_controll_widget.dart';

class CurtainDetailPage extends ConsumerWidget {
  final String deviceId;

  const CurtainDetailPage({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(
      singleCurtainDevicesProvider.select(
        (mqttDevices) => mqttDevices[deviceId],
      ),
    );

    final deviceNames = ref.watch(deviceNamesProvider);
    log('build CurtainDetailPage');

    return Scaffold(
      appBar: AppBar(
        title: Text('${deviceNames[deviceId]}'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CurtainControll(
            device!.position,
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
