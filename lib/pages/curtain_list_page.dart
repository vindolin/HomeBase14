import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/utils.dart';
import '/models/mqtt_devices.dart';
import '/pages/curtain_detail_page.dart';
import '/widgets/connection_bar_widget.dart';
import '/models/mqtt_providers.dart';

class CurtainListPage extends ConsumerWidget {
  const CurtainListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mqttDevicesX = ref.watch(mqttDevicesXProvider);
    final deviceNames = ref.read(deviceNamesProvider);

    final filteredCurtainDevicesProvider = Provider<Map<String, AbstractMqttDevice>>((ref) {
      return Map.fromEntries(
          ({...mqttDevicesX}..removeWhere((_, device) => device is! CurtainDevice)).entries.toList());
    });

    final curtainDevices = ref.watch(filteredCurtainDevicesProvider);

    // final curtainDevices = {
    //   ...Map.fromEntries(
    //     // TODO_ refactor this to a separate provider
    //     ({...mqttDevices}..removeWhere(
    //             (key, value) {
    //               return !key.startsWith('dualCurtain');
    //             },
    //           ))
    //         .entries
    //         .toList()
    //       ..sort(
    //         // first sort by device name
    //         (a, b) => deviceNames[a.key]!.compareTo(
    //           deviceNames[b.key]!,
    //         ),
    //       ),
    //   ),
    //   ...Map.fromEntries(
    //     // TODO_ refactor this to a separate provider
    //     ({...mqttDevices}..removeWhere(
    //             (key, value) {
    //               return !key.startsWith('curtain');
    //             },
    //           ))
    //         .entries
    //         .toList()
    //       ..sort(
    //         // first sort by device name
    //         (a, b) => deviceNames[a.key]!.compareTo(
    //           deviceNames[b.key]!,
    //         ),
    //       ),
    //   ),
    // };
    // log(curtainDevicesX);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Curtains'),
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: curtainDevices.length,
          itemBuilder: (context, index) {
            final key = curtainDevices.keys.elementAt(index);
            final device = curtainDevices.values.elementAt(index);

            // log(key);

            return ListTile(
              leading: device is! CurtainDevice
                  ? const Icon(
                      Icons.blinds,
                    )
                  : const Icon(
                      Icons.blinds_closed,
                    ),
              key: Key(key),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Text(
                deviceNames[key]!,
              ),
              subtitle: Row(
                children: [
                  Text(
                    device.deviceType,
                  ),
                ],
              ),
              onTap: () {
                log('tapped $key');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CurtainDetailPage(deviceId: key),
                  ),
                );
              },
            );
          }),
      floatingActionButton: const ConnectionBar(),
    );
  }
}
