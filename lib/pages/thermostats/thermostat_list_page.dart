import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '/utils.dart';
import '/models/mqtt_devices.dart';
import '/widgets/connection_bar_widget.dart';
import '/widgets/pulsating_icon_hooks_widget.dart';
import 'widgets/thermostat_readings_widget.dart';
import 'widgets/thermostat_settings_widget.dart';

showOverlayModal(context, device, deviceName) {
  showDialog(
    context: context,
    builder: (BuildContext _) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 350),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$deviceName', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                ThermostatInput(
                  deviceId: device.deviceId,
                  closeAction: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Shows a list of all thermostats, sorted by name and temperature.
class ThermostatListPage extends ConsumerWidget {
  const ThermostatListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceNames = ref.watch(deviceNamesProvider);

    final unsortedThermostatDevices = ref.watch(thermostatDevicesProvider);
    final thermostatDevices = ref.watch(
      Provider<IMap<String, ThermostatDevice>>(
        (ref) {
          return unsortedThermostatDevices.sortByList(
            [
              // sort by names
              (a, b) => deviceNames[a.key]!.compareTo(
                    deviceNames[b.key]!,
                  ),
              // then sort by temperature
              (a, b) => b.value.localTemperature.compareTo(
                    a.value.localTemperature,
                  ),
            ],
          );
        },
      ),
    );

    final localTemperatureAvg =
        thermostatDevices.values.averageBy((thermostatDevice) => thermostatDevice.localTemperature);
    final currentHeatingSetpointAvg =
        thermostatDevices.values.averageBy((thermostatDevice) => thermostatDevice.currentHeatingSetpoint);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(translate('device_names.thermostats')),
            const Spacer(),
            Text(
              '${localTemperatureAvg.toStringAsFixed(1)}°C⌀',
              style: const TextStyle().copyWith(
                fontWeight: FontWeight.w700,
                color: getTemperatureColor(localTemperatureAvg, currentHeatingSetpointAvg),
              ),
            )
          ],
        ),
        actions: const [ConnectionBar()],
      ),
      body: GridView.count(
        childAspectRatio: 2.1,
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        padding: const EdgeInsets.all(4),
        children: thermostatDevices.entries.map(
          (entry) {
            final key = entry.key;
            final device = entry.value;

            final tempColor = getTemperatureColor(
              device.localTemperature,
              device.currentHeatingSetpoint.toDouble(),
            );
            return Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: InkWell(
                onTap: () {
                  showOverlayModal(context, device, deviceNames[key]!);
                },
                child: Row(
                  children: [
                    device.localTemperature < device.currentHeatingSetpoint
                        ? PulsatingIcon(
                            iconData: Icons.thermostat,
                            color: tempColor!,
                          )
                        : Icon(
                            Icons.thermostat,
                            color: tempColor!,
                            size: 36,
                          ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deviceNames[key]!,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.fade,
                            softWrap: true,
                          ),
                          ThermostatReadings(
                            currentHeatingSetpoint: device.currentHeatingSetpoint,
                            localTemperature: device.localTemperature,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
