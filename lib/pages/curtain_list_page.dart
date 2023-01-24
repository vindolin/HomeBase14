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
    final curtainDevices = {
      ...Map.fromEntries(
        // TODO_ refactor this to a separate provider
        ({...mqttDevices}..removeWhere(
                (key, value) {
                  return !key.startsWith('dualCurtain');
                },
              ))
            .entries
            .toList()
          ..sort(
            // first sort by device name
            (a, b) => deviceNames[a.key]!.compareTo(
              deviceNames[b.key]!,
            ),
          ),
      ),
      ...Map.fromEntries(
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
          ),
      ),
    };

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
              leading: value['_device_type'] == 'dualCurtain'
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
                    value['_device_type'],
                  ),
                ],
              ),
              onTap: () {
                print('tapped $key');
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
