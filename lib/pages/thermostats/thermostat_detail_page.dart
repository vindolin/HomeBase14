import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/mqtt_devices.dart';
import '/widgets/shader_widget.dart';
// import 'graph_widget.dart';

class ThermostatDetailPage extends ConsumerWidget {
  final String deviceId;

  const ThermostatDetailPage({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(
      thermostatDevicesProvider.select(
        (mqttDevices) => mqttDevices[deviceId],
      ),
    );
    final deviceNames = ref.watch(deviceNamesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${deviceNames[deviceId]}'),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 200,
          child: Stack(
            children: [
              const ShaderWidget(
                'warning.frag',
              ),
              Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${deviceNames[deviceId]} - ${device?.localTemperature}°C'),
                  const Icon(Icons.construction),
                  const Text('Implement graphs for list and detail page'),
                  // const ThermostatGraph(),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
