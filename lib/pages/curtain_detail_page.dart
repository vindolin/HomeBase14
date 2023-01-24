import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mqtt_providers.dart';

class CurtainDetailPage extends ConsumerWidget {
  final String deviceId;

  const CurtainDetailPage({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(mqttDevicesProvider)[deviceId];
    final deviceNames = ref.read(deviceNamesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Curtain'),
      ),
      body: Center(
        child: Text('${deviceNames[deviceId]}'),
      ),
    );
  }
}
