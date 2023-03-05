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
    // final device = ref.watch(mqttDevicesProvider)[deviceId];

    final device = ref.watch(
      singleCurtainDevicesProvider.select(
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
        title: Text('${deviceNames[deviceId]}'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CurtainControll(
            position,
            (double value) {
              ref.read(positionProvider.notifier).state = value;
              device.position = value.toDouble();
            },
            (double value) {
              device.publishState();
            },
            device!.open,
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
