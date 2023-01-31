import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/utils.dart';
import '/models/mqtt_devices.dart';
import '/pages/thermostat_detail_page.dart';
import '/widgets/connection_bar_widget.dart';

class ThermostatListPage extends ConsumerWidget {
  const ThermostatListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceNames = ref.read(deviceNamesProvider);

    final thermostatDevicesUnfiltered = ref.watch(thermostatDevicesProvider);
    final thermostatDevices = ref.watch(
      Provider<Map<String, ThermostatDevice>>(
        (ref) {
          return thermostatDevicesUnfiltered.sortByList(
            [
              (a, b) => deviceNames[a.key]!.compareTo(
                    deviceNames[b.key]!,
                  ),
              (a, b) => b.value.localTemperature.compareTo(
                    a.value.localTemperature,
                  ),
            ],
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thermostats'),
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: thermostatDevices.length,
          itemBuilder: (context, index) {
            final key = thermostatDevices.keys.elementAt(index);
            final device = thermostatDevices.values.elementAt(index);

            // log(key);
            final tempColor = device.localTemperature == device.currentHeatingSetpoint
                ? Colors.green
                : device.localTemperature < device.currentHeatingSetpoint
                    ? Colors.blue
                    : Colors.red;

            return ListTile(
              leading: Icon(
                Icons.thermostat,
                color: tempColor,
                grade: 0.2,
              ),
              key: Key(key),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Text(
                deviceNames[key]!,
              ),
              subtitle: Row(
                children: [
                  Text(
                    '${device.localTemperature}°C',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tempColor,
                    ),
                  ),
                  Text(
                    '  / ${device.currentHeatingSetpoint}°C',
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              onTap: () {
                log('tapped $key');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThermostatDetailPage(deviceId: key),
                  ),
                );
              },
            );
          }),
      floatingActionButton: const ConnectionBar(),
    );
  }
}
