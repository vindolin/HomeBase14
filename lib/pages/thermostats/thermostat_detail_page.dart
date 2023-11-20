import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/models/mqtt_devices.dart';
import 'widgets/thermostat_readings_widget.dart';

// import '/widgets/shader_widget.dart';
// import 'graph_widget.dart';

class ThermostatInput extends ConsumerStatefulWidget {
  final ThermostatDevice device;
  const ThermostatInput({required this.device, super.key});

  @override
  ConsumerState<ThermostatInput> createState() => _ThermostatInputState();
}

class _ThermostatInputState extends ConsumerState<ThermostatInput> {
  double? newHeatingSetpoint;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ThermostatReadings(
          currentHeatingSetpoint: widget.device.currentHeatingSetpoint,
          localTemperature: widget.device.localTemperature,
        ),
        SpinBox(
          min: 0,
          max: 30,
          direction: Axis.vertical,
          incrementIcon: const Icon(Icons.keyboard_arrow_up, size: 32),
          decrementIcon: const Icon(Icons.keyboard_arrow_down, size: 32),
          value: widget.device.currentHeatingSetpoint.toDouble(),
          onChanged: (value) {
            setState(() {
              newHeatingSetpoint = value;
            });
          },
        ),
        ElevatedButton(
          onPressed: newHeatingSetpoint != null
              ? () {
                  widget.device.currentHeatingSetpoint = newHeatingSetpoint!.toInt();
                  widget.device.publishState();
                }
              : null,
          child: Text(translate('thermostats.submit_button_text')),
        ),
      ],
    );
  }
}

class ThermostatDetailPage extends ConsumerWidget {
  final String deviceId;

  const ThermostatDetailPage({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceNames = ref.watch(deviceNamesProvider);

    final device = ref.watch(
      thermostatDevicesProvider.select(
        (mqttDevices) => mqttDevices[deviceId],
      ),
    )!;

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${deviceNames[deviceId]}'),
        ),
        body: Center(
          child: SizedBox(
            width: 300,
            child: ThermostatInput(device: device),
          ),
        ),
      ),
    );
  }
}
