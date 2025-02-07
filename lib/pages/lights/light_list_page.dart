import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:home_base_14/shortcut_wrapper.dart';

import '/utils.dart';
import '/util/sorting.dart';

import '/models/mqtt_devices.dart';
import '/models/app_settings_provider.dart';
import '/widgets/slider_widget.dart';
import '/widgets/connection_bar_widget.dart';

import 'widgets/lights_off_button_widget.dart';

abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

class LightPage extends ConsumerWidget {
  const LightPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('LightPage.build()');

    final deviceNames = ref.watch(deviceNamesProvider);
    final lightDevices = ref.watch(lightDevicesProvider);
    final appSettings = ref.watch(appSettingsProvider);

    final smartBulbDevices = ref.watch(
      Provider<IMap<String, SmartBulbDevice>>(
        (ref) {
          return ref.watch(smartBulbDevicesProvider).sortByList(
            [
              // sort by names
              (a, b) => deviceNames[a.key]!.compareTo(
                    deviceNames[b.key]!,
                  ),
            ],
          );
        },
      ),
    );

    int onLightCount = lightDevices.values.where((device) => device.state == 'ON').length;

    // no divider for first and last items
    List<int> noDividerIndices = [
      0,
      lightDevices.length,
      lightDevices.length + 1,
    ];

    final lightDeviceTiles = List<Widget>.from(
      lightDevices.keys.map(
        (key) {
          final lightDevice = lightDevices[key]!;
          return ListTile(
            leading: lightDevice.state == 'ON'
                ? const Icon(
                    Icons.lightbulb,
                    color: Colors.amber,
                  )
                : const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.white,
                  ),
            key: Key(key),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lightDevice.name),
                if (appSettings.user == User.thomas)
                  Text(
                    lightDevice.topicSet,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  )
              ],
            ),
            onTap: () {
              ref.read(lightDevicesProvider.notifier).toggleState(key);
            },
          );
        },
      ),
    );

    int onSmartLightCount = smartBulbDevices.values.where((device) => device.state == 'ON').length;

    final smartBulbDeviceTiles = List<Widget>.from(
      smartBulbDevices.entries.map(
        (entry) {
          final key = entry.key;
          final device = entry.value;
          final deviceName = deviceNames[device.deviceId] ?? device.deviceId;

          // we need to prepare the brightness value for clamping it to 5.0
          final brightness = mapValue(device.brightness.toDouble(), 0.0, 254.0, 0.0, 100.0);

          final lidlBulbDevices = ['bulb/i011']; // buy more Ikea bulbs 🙄
          final isLidlBulb = lidlBulbDevices.contains(device.deviceId);
          const minColorIkea = 250.0;
          const maxColorIkea = 454.0;
          const minColorLidl = 153.0;
          const maxColorLidl = 500.0;

          final minBulbColor = isLidlBulb ? minColorLidl : minColorIkea;
          final maxBulbColor = isLidlBulb ? maxColorLidl : maxColorIkea;

          return ListTile(
            // because the smart bulps are switched on/off with the wall switch, we don't know the state of the bulb like with the simple lights
            // can be enabled when I replace the wall switch with a smart switch
            leading: smartBulbDevices[key]!.state == 'ON'
                ? const Icon(
                    Icons.lightbulb,
                    color: Colors.amber,
                  )
                : const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.white,
                  ),
            onTap: () {
              device.state = device.state == 'ON' ? 'OFF' : 'ON';
              device.publishState();
            },
            key: Key(key),

            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deviceName,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (appSettings.user == User.thomas)
                        Text(
                          device.deviceId,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        )
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      SliderWidget(
                        minColor: const Color.fromARGB(255, 109, 109, 109),
                        maxColor: Colors.white,
                        inactiveColor: Colors.grey.shade600,
                        value: brightness < 5.0 ? 5.0 : brightness,
                        min: 5,
                        max: 100,
                        divisions: 20,
                        onChangeEnd: (double value) {
                          device.brightness = mapValue(value, 0.0, 100.0, 0.0, 254.0).toInt();
                          device.publishState();
                        },
                      ),
                      if (device.colorTemp != null && device.colorTemp! >= minBulbColor) ...[
                        SliderWidget(
                          minColor: const Color.fromARGB(255, 155, 173, 255),
                          maxColor: Colors.amber,
                          inactiveColor: Colors.grey.shade600,
                          value: mapValue(device.colorTemp!.toDouble(), minBulbColor, maxBulbColor, 0.0, 100.0),
                          max: 100,
                          divisions: 20,
                          onChangeEnd: (double value) {
                            device.colorTemp = mapValue(value, 0.0, 100.0, minBulbColor, maxBulbColor).toInt();
                            device.publishState();
                          },
                        )
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    final combinedListViewWidgets = [
      // header simple lights
      ListTile(
        tileColor: Colors.black26,
        title: const Text(
          'Lampen',
          style: TextStyle(color: Colors.white),
        ),
        trailing: onLightCount > 0 ? const LightDevicesOffButton() : null,
      ),

      // simple lights
      ...lightDeviceTiles,

      // header smart lights
      ListTile(
        tileColor: Colors.black26,
        title: const Text(
          'Smart Lampen',
          style: TextStyle(color: Colors.white),
        ),
        trailing: onSmartLightCount > 0 ? const SmartBulbsOffButton() : null, // TODOs implement
      ),

      // smart lights
      ...smartBulbDeviceTiles,
    ];

    return shortcutWrapper(
      context,
      Scaffold(
        appBar: AppBar(
          title: Text(translate('device_names.lights')),
          actions: const [ConnectionBar()],
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) {
            return !noDividerIndices.contains(index) ? const Divider() : Container();
          },
          itemCount: combinedListViewWidgets.length,
          itemBuilder: (context, index) {
            return combinedListViewWidgets[index];
          },
        ),
      ),
    );
  }
}
