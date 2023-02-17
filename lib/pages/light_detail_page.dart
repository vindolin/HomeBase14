import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/utils.dart';
import '/models/mqtt_devices.dart';

class LightDetailPage extends ConsumerWidget {
  final String deviceId;

  const LightDetailPage({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final device = ref.watch(mqttDevicesProvider)[deviceId];

    final deviceNames = ref.read(deviceNamesProvider);
    log('build LightDetailPage');

    return Scaffold(
      appBar: AppBar(
        title: Text('${deviceNames[deviceId]}'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [],
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
