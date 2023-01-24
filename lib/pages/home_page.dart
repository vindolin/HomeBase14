import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'thermostat_list_page.dart';
import 'curtain_list_page.dart';
import '../widgets/connection_bar_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homebase'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          ListTile(
            title: const Text('Thermostats'),
            leading: const Icon(Icons.thermostat),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
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
            title: const Text('Curtains'),
            leading: const Icon(Icons.blinds),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CurtainListPage(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: const ConnectionBar(),
    );
  }
}
