import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/curtain_detail_page.dart';
import '../widgets/connection_bar_widget.dart';
import '../models/mqtt_providers.dart';

class CurtainListPage extends ConsumerWidget {
  const CurtainListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mqttDevices = ref.watch(mqttDevicesProvider);
    final deviceNames = ref.read(deviceNamesProvider);
    final curtainDevices = Map.fromEntries(
        // TODO_ refactor this to a separate provider
        ({...mqttDevices}..removeWhere(
                (key, value) {
                  return !key.startsWith('curtain');
                },
              ))
            .entries
            .toList()
          ..sort(
            // first sort by device name
            (a, b) => deviceNames[a.key]!.compareTo(
              deviceNames[b.key]!,
            ),
          ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Curtains'),
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: curtainDevices.length,
          itemBuilder: (context, index) {
            final key = curtainDevices.keys.elementAt(index);
            final value = curtainDevices.values.elementAt(index);

            print(key);

            return ListTile(
              leading: Icon(
                Icons.blinds,
                color: Colors.red,
                grade: 0.2,
              ),
              key: Key(key),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Text(
                deviceNames[key]!,
              ),
              // subtitle: Row(
              //   children: [
              //     Text(
              //       'localTemperature°C',
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         color: Colors.red,
              //       ),
              //     ),
              //   ],
              // ),
              onTap: () {
                print('tapped $key');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CurtainDetailPage(deviceId: key),
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
