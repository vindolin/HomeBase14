import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/models/mqtt_devices.dart';
import '/styles/styles.dart';
import '/pages/thermostats/thermostat_list_page.dart';
import '/pages/curtains/curtain_list_page.dart';
import '/pages/lights/light_list_page.dart';
import '/pages/lights/widgets/lights_off_button_widget.dart';
import '/pages/curtains/widgets/curtain_actions.dart';
import '/pages/other/other_page.dart';
import '/pages/other/widgets/doors_widget.dart';
import '/pages/thermostats/widgets/thermostat_readings_widget.dart';

class DeviceGroups extends ConsumerWidget {
  const DeviceGroups({super.key});
  final visualDensity = const VisualDensity(horizontal: 0, vertical: -3);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lightDevices = ref.watch(lightDevicesProvider);
    final smrartBulbDevices = ref.watch(smartBulbDevicesProvider);

    final thermostatDevices = ref.watch(thermostatDevicesProvider);

    final localTemperatureAvg =
        thermostatDevices.values.averageBy((thermostatDevice) => thermostatDevice.localTemperature);
    final currentHeatingSetpointAvg =
        thermostatDevices.values.averageBy((thermostatDevice) => thermostatDevice.currentHeatingSetpoint);

    // color the icon yellow if any lights are on
    int onLightCount = lightDevices.values.where((lightDevice) => lightDevice.state == 'ON').length +
        smrartBulbDevices.values.where((smartBulbDevice) => smartBulbDevice.state == 'ON').length;

    final brightness = Theme.of(context).brightness;
    TextStyle titleStyle = textStyleShadowOne.copyWith(
      shadows: [
        Shadow(
          blurRadius: 2.0,
          color: brightness == Brightness.dark ? Colors.black : Colors.black45,
          offset: const Offset(1.0, 1.0),
        ),
      ],
    );

    return SliverList(
      delegate: SliverChildListDelegate([
        const Divider(),
        ListTile(
          title: Text(
            translate('device_names.curtains'),
            style: titleStyle,
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
            translate('device_names.thermostats'),
            style: titleStyle,
          ),
          leading: const Icon(Icons.thermostat),
          visualDensity: visualDensity,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ThermostatListPage(),
              ),
            );
          },
          trailing: Text(
            ' ${localTemperatureAvg.toStringAsFixed(1)}°C⌀',
            style: titleStyle.copyWith(
              color: getTemperatureColor(localTemperatureAvg, currentHeatingSetpointAvg),
            ),
          ),
        ),
        const Divider(),
        ListTile(
          title: Text(
            translate('device_names.lights'),
            style: titleStyle,
          ),
          leading: const Icon(Icons.lightbulb),
          trailing: onLightCount > 0 ? const CombinedLIghtsOffButton() : null,
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
            style: titleStyle,
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
          trailing: const DoorsWidget(miniMode: true),
        ),
      ]),
    );
  }
}
