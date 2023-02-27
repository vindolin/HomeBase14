import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/utils.dart';
import 'widgets/lights_off_button_widget.dart';
import '/models/mqtt_devices.dart';
import '/widgets/connection_bar_widget.dart';

class LightPage extends ConsumerWidget {
  const LightPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('LightPage.build()');

    final lightDevices = ref.watch(lightDevicesProvider);
    int onLightCount = lightDevices.values.where((lightDevice) => lightDevice.state == 'ON').length;

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('device_names.lights')),
        actions: [
          if (onLightCount > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [LightsOffButton()],
            ),
          const ConnectionBar()
        ],
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: lightDevices.length,
          itemBuilder: (context, index) {
            final key = lightDevices.keys.elementAt(index);
            final device = lightDevices.values.elementAt(index);

            return ListTile(
              leading: device.state == 'ON'
                  ? const Icon(
                      Icons.lightbulb,
                      color: Colors.amber,
                      grade: 0.2,
                    )
                  : const Icon(
                      Icons.lightbulb_outline,
                      color: Colors.white,
                      grade: 0.2,
                    ),
              key: Key(key),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Row(
                children: [
                  Text(device.name),
                ],
              ),
              onTap: () {
                ref.read(lightDevicesProvider.notifier).toggleState(key);
              },
            );
          }),
    );
  }
}
