import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/models/app_settings.dart';
import '/models/mqtt_devices.dart';
import '/styles/text_styles.dart';
import '/pages/thermostat_list_page.dart';
import '/pages/curtains/curtain_list_page.dart';
import '/pages/lights/light_list_page.dart';
import '/pages/lights/widgets/lights_off_button_widget.dart';
import '/pages/curtains/widgets/curtain_actions.dart';
import '/pages/other_page.dart';
import '/pages/thomas/thomas_page.dart';

class DeviceGroups extends ConsumerWidget {
  const DeviceGroups({super.key});
  final visualDensity = const VisualDensity(horizontal: 0, vertical: -3);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);
    final lightDevices = ref.watch(lightDevicesProvider);

    // color the icon yellow if any lights are on
    int onLightCount = lightDevices.values.where((lightDevice) => lightDevice.state == 'ON').length;

    return SliverList(
      delegate: SliverChildListDelegate([
        const Divider(),
        ListTile(
          title: Text(
            translate('device_names.thermostats'),
            style: textStyleShadowOne,
          ),
          leading: const Icon(Icons.thermostat),
          visualDensity: visualDensity,
          // tileColor: Colors.amber,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ThermostatListPage(),
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          title: Text(
            translate('device_names.curtains'),
            style: textStyleShadowOne,
          ),
          leading: const Icon(Icons.blinds),
          visualDensity: visualDensity,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: curtainActions(context, ref),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CurtainListPage(),
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          title: Text(
            translate('device_names.lights'),
            style: textStyleShadowOne,
          ),
          leading: const Icon(Icons.lightbulb),
          trailing: onLightCount > 0 ? const LightsOffButton() : null,
          visualDensity: visualDensity,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LightPage(),
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          title: Text(
            translate('device_names.other'),
            style: textStyleShadowOne,
          ),
          leading: const Icon(Icons.extension),
          visualDensity: visualDensity,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OtherPage(),
              ),
            );
          },
        ),
        const Divider(),
        if (appSettings.user == User.thomas)
          ListTile(
            // tileColor: Colors.purple.shade800,
            title: const Text(
              'Thomas',
              style: textStyleShadowOne,
            ),
            leading: const Icon(Icons.pest_control),
            visualDensity: visualDensity,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ThomasPage(),
                ),
              );
            },
          ),
        const Divider(),
      ]),
    );
  }
}
