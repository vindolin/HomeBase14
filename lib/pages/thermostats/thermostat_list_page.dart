import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '/utils.dart';
import '/models/mqtt_devices.dart';
import '/pages/thermostats/thermostat_detail_page.dart';
import '/widgets/connection_bar_widget.dart';
import 'widgets/thermostat_readings_widget.dart';

/// Shows a list of all thermostats, sorted by name and temperature.
class ThermostatListPage extends ConsumerWidget {
  const ThermostatListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceNames = ref.watch(deviceNamesProvider);

    final thermostatDevicesUnfiltered = ref.watch(thermostatDevicesProvider);
    final thermostatDevices = ref.watch(
      Provider<IMap<String, ThermostatDevice>>(
        (ref) {
          return thermostatDevicesUnfiltered.sortByList(
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
                color: getTemperatureColor(localTemperatureAvg, currentHeatingSetpointAvg),
              ),
            )
          ],
        ),
        actions: const [ConnectionBar()],
      ),
      body: GridView.count(
        childAspectRatio: 2.3,
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
                  log('tapped $key');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThermostatDetailPage(deviceId: key),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.thermostat,
                      color: tempColor,
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


// ListTile(
//   leading: Icon(
//     Icons.thermostat,
//     color: tempColor,
//   ),
//   key: Key(key),
//   title: Text(
//     deviceNames[key]!,
//   ),
//   subtitle: ThermostatReadings(
//     currentHeatingSetpoint: device.currentHeatingSetpoint,
//     localTemperature: device.localTemperature,
//   ),
//   onTap: () {
//     log('tapped $key');
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ThermostatDetailPage(deviceId: key),
//       ),
//     );
//   },
// ),