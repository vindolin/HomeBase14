import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/pages/thermostat_list_page.dart';
import '/pages/curtain_list_page.dart';
import '/pages/light_list_page.dart';
import '/pages/other_page.dart';
import '/widgets/app_bar_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  final visualDensity = const VisualDensity(horizontal: 0, vertical: -4);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBarWithIcons(
        title: translate('app_bar.title'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ListTile(
            title: Text(translate('device_names.thermostats')),
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
          ),
          ListTile(
            title: Text(translate('device_names.curtains')),
            leading: const Icon(Icons.blinds),
            visualDensity: visualDensity,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CurtainListPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(translate('device_names.lights')),
            leading: const Icon(Icons.lightbulb),
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
          ListTile(
            title: Text(translate('device_names.other')),
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
        ],
      ),
    );
  }
}
