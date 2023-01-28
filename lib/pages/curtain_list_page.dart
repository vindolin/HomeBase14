import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/utils.dart';
import '/models/mqtt_devices.dart';
import '/models/mqtt_providers.dart';
import '/pages/curtain_detail_page.dart';
import '/widgets/connection_bar_widget.dart';

class CurtainListPage extends ConsumerWidget {
  const CurtainListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceNames = ref.read(deviceNamesProvider);
    final curtainDevicesUnfiltered = ref.watch(curtainDevicesProvider);

    final curtainDevices = ref.watch(
      Provider<Map<String, CurtainDevice>>(
        (ref) {
          return curtainDevicesUnfiltered.sortByList([
            (a, b) => deviceNames[a.key]!.compareTo(
                  deviceNames[b.key]!,
                ),
          ]);
        },
      ),
    );

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
              leading: const Icon(
                Icons.blinds,
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
