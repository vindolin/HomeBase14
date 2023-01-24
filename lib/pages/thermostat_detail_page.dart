import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mqtt_providers.dart';

class ThermostatDetailPage extends ConsumerWidget {
  final String deviceId;

  const ThermostatDetailPage({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(mqttDevicesProvider)[deviceId];
    final deviceNames = ref.read(deviceNamesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thermostat'),
      ),
      body: Center(
        child: Text('${deviceNames[deviceId]} - ${device['local_temperature']}°C'),
      ),
    );
  }
}
