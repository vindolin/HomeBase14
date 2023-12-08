import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/models/mqtt_devices.dart';
import 'thermostat_readings_widget.dart';

class ThermostatInput extends ConsumerStatefulWidget {
  final String deviceId;
  final Function closeAction;
  const ThermostatInput({super.key, required this.deviceId, required this.closeAction});

  @override
  ConsumerState<ThermostatInput> createState() => _ThermostatInputState();
}

class _ThermostatInputState extends ConsumerState<ThermostatInput> {
  double? newHeatingSetpoint;

  @override
  Widget build(BuildContext context) {
    final device = ref.watch(
      thermostatDevicesProvider.select(
        (mqttDevices) => mqttDevices[widget.deviceId],
      ),
    )!;

    return Column(
      children: [
        ThermostatReadings(
          currentHeatingSetpoint: device.currentHeatingSetpoint,
          localTemperature: device.localTemperature,
        ),
        SpinBox(
          min: 0,
          max: 30,
          direction: Axis.vertical,
          incrementIcon: const Icon(Icons.keyboard_arrow_up, size: 32),
          decrementIcon: const Icon(Icons.keyboard_arrow_down, size: 32),
          value: device.currentHeatingSetpoint.toDouble(),
          onChanged: (value) {
            setState(() {
              newHeatingSetpoint = value;
            });
          },
        ),
        ElevatedButton(
          onPressed: newHeatingSetpoint != null
              ? () {
                  device.currentHeatingSetpoint = newHeatingSetpoint!.toInt();
                  device.publishState();
                  widget.closeAction();
                }
              : null,
          child: Text(translate('thermostats.submit_button_text')),
        ),
      ],
    );
  }
}
