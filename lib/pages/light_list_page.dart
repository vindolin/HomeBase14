import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '/utils.dart';
import '/models/mqtt_devices.dart';
import '/widgets/connection_bar_widget.dart';

class LightPage extends ConsumerWidget {
  const LightPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('LightPage.build()');

    final lightDevices = ref.watch(lightDevicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('device_names.lights')),
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: lightDevices.length,
          itemBuilder: (context, index) {
            final key = lightDevices.keys.elementAt(index);
            final device = lightDevices.values.elementAt(index);
            print(device['state']);

            return ListTile(
              leading: device['state'] == 'ON'
                  ? const Icon(
                      Icons.lightbulb,
                      color: Colors.amber,
                      grade: 0.2,
                    )
                  : const Icon(
                      Icons.lightbulb_outline,
                      color: Colors.amber,
                      grade: 0.2,
                    ),
              key: Key(key),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Row(
                children: [
                  Text(device['name']!),
                  // Expanded(child: Switch(value: device['state'] == 'ON', onChanged: (value) {}))
                ],
              ),
              onTap: () {
                log('tapped $key');
                ref.read(lightDevicesProvider.notifier).toggleState(key);
              },
            );
          }),
      floatingActionButton: const ConnectionBar(),
    );
  }
}
