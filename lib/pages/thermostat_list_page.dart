import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/thermostat_detail_page.dart';
import '../widgets/connection_bar_widget.dart';
import '../models/mqtt_providers.dart';

class ThermostatListPage extends ConsumerWidget {
  const ThermostatListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mqttDevices = ref.watch(mqttDevicesProvider);
    final deviceNames = ref.read(deviceNamesProvider);
    final thermostatDevices = Map.fromEntries(
      // TODO_ refactor this to a separate provider
      ({...mqttDevices}..removeWhere(
              (key, value) {
                return !key.startsWith('thermostat') ||
                    value['local_temperature'] == null ||
                    value['current_heating_setpoint'] == null;
              },
            ))
          .entries
          .toList()
        ..sort(
          // first sort by device name
          (a, b) => deviceNames[a.key]!.compareTo(
            deviceNames[b.key]!,
          ),
        )
        ..sort(
          // then sort by local temperature
          (a, b) => b.value['local_temperature'].compareTo(
            a.value['local_temperature'],
          ),
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
            final value = thermostatDevices.values.elementAt(index);
            num localTemperature = value['local_temperature'];
            num heatingSetpoint = value['current_heating_setpoint'];

            print(key);
            final tempColor = localTemperature == heatingSetpoint
                ? Colors.green
                : localTemperature < heatingSetpoint
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
                    '$localTemperature°C',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tempColor,
                    ),
                  ),
                  Text(
                    '  / $heatingSetpoint°C',
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              onTap: () {
                print('tapped $key');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThermostatDetailPage(deviceId: key),
                  ),
                  // PageRouteBuilder(
                  //   pageBuilder: (_, __, ___) => ThermostatDetailPage(deviceId: key),
                  //   transitionDuration: Duration(milliseconds: 500),
                  //   transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
                  // ),
                );
              },
            );
          }),
      floatingActionButton: const ConnectionBar(),
    );
  }
}
