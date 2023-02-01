import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '/utils.dart';
import '/models/mqtt_devices.dart';
import '/pages/curtain_detail_page.dart';
import '/pages/dual_curtain_detail_page.dart';
import '/widgets/connection_bar_widget.dart';
import '/widgets/curtain_icons_widget.dart';

class CurtainListPage extends ConsumerWidget {
  const CurtainListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('CurtainListPage.build()');

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

    // add both curtain types to a single map
    Map<String, AbstractMqttDevice> combinedCurtainDevices = {
      ...dualCurtainDevices,
      ...curtainDevices,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Curtains'),
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: combinedCurtainDevices.length,
          itemBuilder: (context, index) {
            final device = combinedCurtainDevices.values.elementAt(index);

            Widget? icon;
            if (device is DualCurtainDevice) {
              icon = dualCurtainIcon(device.positionLeft, device.positionRight);
            } else if (device is CurtainDevice) {
              icon = curtainIcon(device.position);
              // icon = AnimatedWidget(device.deviceId);
            }

            return ListTile(
              leading: icon,
              key: Key(device.deviceId),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Text(
                deviceNames[device.deviceId]!,
              ),
              subtitle: Row(
                children: [
                  Text(
                    device.deviceType,
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => device is DualCurtainDevice
                        ? DualCurtainDetailPage(deviceId: device.deviceId)
                        : CurtainDetailPage(deviceId: device.deviceId),
                  ),
                );
              },
            );
          }),
      // bottomSheet: Column(
      //   children: [
      //     const AnimatedWidget(device.deviceId),
      //     ElevatedButton(
      //       child: const Text('Increment'),
      //       onPressed: () {
      //         notifier.increment();
      //       },
      //     ),
      //   ],
      // ),
      floatingActionButton: const ConnectionBar(),
    );
  }
}
