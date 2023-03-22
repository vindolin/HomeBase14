import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/pages/home/home_page.dart';
import '/utils.dart';
import 'widgets/lights_off_button_widget.dart';
import '../../widgets/slider_widget.dart';
import '/models/mqtt_devices.dart';
import '/widgets/connection_bar_widget.dart';

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
    final smartBulbDevices = ref.watch(smartBulbDevicesProvider);

    int onLightCount = lightDevices.values.where((device) => device.state == 'ON').length;

    // no divider for first and last items
    List<int> noDividerIndices = [0, lightDevices.length, smartBulbDevices.length];

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
            title: Row(
              children: [
                Text(lightDevice.name),
              ],
            ),
            onTap: () {
              ref.read(lightDevicesProvider.notifier).toggleState(key);
            },
          );
        },
      ),
    );

    // int onSmartLightCount = smartBulbDevices.values.where((device) => device.state == 'ON').length;

    // print(smartBulbDevices['bulb/i001']!.state);
    final smartBulbDeviceTiles = List<Widget>.from(
      smartBulbDevices.keys.map(
        (key) {
          final device = smartBulbDevices[key]!;
          final deviceName = deviceNames[device.deviceId] ?? device.deviceId;

          return ListTile(
            // because the smart bulps ares witched on/off with the wall switch, we don't know the state of the bulb like with the simple lights
            // can be enabled when I replace the wall switch with a smart switch
            // leading: smartBulbDevices[key]!.state == 'ON'
            //     ? const Icon(
            //         Icons.lightbulb,
            //         color: Colors.amber,
            //       )
            //     : const Icon(
            //         Icons.lightbulb_outline,
            //         color: Colors.white,
            //       ),
            key: Key(key),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: device.state == 'ON'
                        ? const Icon(
                            Icons.lightbulb,
                            color: Colors.amber,
                          )
                        : const Icon(
                            Icons.lightbulb_outline,
                            color: Colors.white,
                          ),
                    onPressed: () {
                      device.state = device.state == 'ON' ? 'OFF' : 'ON';
                      device.publishState();
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    deviceName,
                    overflow: TextOverflow.ellipsis,
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
                        value: device.brightness.toDouble(),
                        max: 255,
                        divisions: 20,
                        onChangeEnd: (double value) {
                          device.brightness = value.toInt();
                          device.publishState();
                        },
                      ),
                      SliderWidget(
                        minColor: const Color.fromARGB(255, 155, 173, 255),
                        maxColor: Colors.amber,
                        inactiveColor: Colors.grey.shade600,
                        value: device.colorTemp.toDouble(),
                        max: 500,
                        divisions: 20,
                        onChangeEnd: (double value) {
                          device.colorTemp = value.toInt();
                          device.publishState();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              // ref.read(smartBulbDevicesProvider.notifier).toggleState(key);
            },
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
        trailing: onLightCount > 0 ? const LightsOffButton() : null,
      ),

      // simple lights
      ...lightDeviceTiles,

      // header smart lights
      const ListTile(
        tileColor: Colors.black26,
        title: Text(
          'Smart Lampen',
          style: TextStyle(color: Colors.white),
        ),
        // trailing: onSmartLightCount > 0 ? const LightsOffButton() : null,  // TODOs implement
      ),

      // smart lights
      ...smartBulbDeviceTiles,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('device_names.lights')),
        actions: const [ConnectionBar()],
        leading: homeBackButton(context),
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
    );
  }
}
