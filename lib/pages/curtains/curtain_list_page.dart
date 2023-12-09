import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '/utils.dart';
import '/ui_helpers.dart';

import '/models/mqtt_devices.dart';

import 'widgets/curtain_actions.dart';
import 'widgets/curtain_icon_widgets.dart';
import 'widgets/curtain_widget.dart';
import 'widgets/dual_curtain_widget.dart';

import '/widgets/connection_bar_widget.dart';

class CurtainListPage extends ConsumerWidget {
  const CurtainListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // log('CurtainListPage.build()');

    final deviceNames = ref.read(deviceNamesProvider);

    final curtainDevicesUnfiltered = ref.watch(singleCurtainDevicesProvider);
    final curtainDevices = ref.watch(
      Provider<IMap<String, SingleCurtainDevice>>(
        (ref) {
          return curtainDevicesUnfiltered.sortByList(
            [
              (a, b) => deviceNames[a.key]!.compareTo(
                    deviceNames[b.key]!,
                  ),
            ],
          );
        },
      ),
    );

    final dualCurtainDevicesUnfiltered = ref.watch(dualCurtainDevicesProvider);
    final dualCurtainDevices = ref.watch(
      Provider<IMap<String, DualCurtainDevice>>(
        (ref) {
          return dualCurtainDevicesUnfiltered.sortByList(
            [
              (a, b) => deviceNames[a.key]!.compareTo(
                    deviceNames[b.key]!,
                  ),
            ],
          );
        },
      ),
    );

    // add both curtain types to a single map
    IMap<String, AbstractMqttDevice> combinedCurtainDevices = IMap({
      ...dualCurtainDevices.unlock,
      ...curtainDevices.unlock,
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('device_names.curtains')),
        actions: [...curtainActions(context, ref), const ConnectionBar()],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: combinedCurtainDevices.length,
        itemBuilder: (context, index) {
          final device = combinedCurtainDevices.values.elementAt(index);

          Widget? icon;

          if (device is DualCurtainDevice) {
            icon = AnimatedDualCurtainItem(device);
          } else if (device is SingleCurtainDevice) {
            icon = AnimatedCurtainItem(device);
          }

          return ListTile(
            leading: icon,
            key: Key(device.deviceId),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: Text(
              deviceNames[device.deviceId] ?? device.deviceId,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Row(
              children: [
                Text(
                  device.deviceType,
                )
              ],
            ),
            onTap: () {
              modalDialog(
                context,
                device is DualCurtainDevice
                    ? DualCurtainWidget(deviceId: device.deviceId)
                    : CurtainWidget(deviceId: device.deviceId),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...curtainActions(context, ref, device.deviceId),
              ],
            ),
          );
        },
      ),
    );
  }
}
