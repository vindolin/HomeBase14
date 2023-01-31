import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/utils.dart';
import '/models/mqtt_devices.dart';
import '/pages/curtain_detail_page.dart';
import '/pages/dual_curtain_detail_page.dart';
import '/widgets/connection_bar_widget.dart';

ListTile mkCurtainDeviceListTile(AbstractMqttDevice device, context, deviceNames, key) {
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
}

ListTile mkDualCurtainDeviceListTile(AbstractMqttDevice device, context, deviceNames, key) {
  return ListTile(
    leading: const Icon(
      Icons.door_back_door,
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
          builder: (context) => DualCurtainDetailPage(deviceId: key),
        ),
      );
    },
  );
}

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

    final dualCurtainDevicesUnfiltered = ref.watch(dualCurtainDevicesProvider);
    final dualCurtainDevices = ref.watch(
      Provider<Map<String, DualCurtainDevice>>(
        (ref) {
          return dualCurtainDevicesUnfiltered.sortByList([
            (a, b) => deviceNames[a.key]!.compareTo(
                  deviceNames[b.key]!,
                ),
          ]);
        },
      ),
    );

    Map<String, AbstractMqttDevice> allCurtainDevices = {...dualCurtainDevices, ...curtainDevices};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Curtains'),
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: allCurtainDevices.length,
          itemBuilder: (context, index) {
            final key = allCurtainDevices.keys.elementAt(index);
            final device = allCurtainDevices.values.elementAt(index);

            return device.deviceType == 'curtain'
                ? mkCurtainDeviceListTile(device, context, deviceNames, key)
                : mkDualCurtainDeviceListTile(device, context, deviceNames, key);
          }),
      floatingActionButton: const ConnectionBar(),
    );
  }
}
