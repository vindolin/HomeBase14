import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/app_settings.dart';
import '/styles/text_styles.dart';
import '/pages/thomas/thomas_page.dart';
import '/pages/grafana/grafana_page.dart';

/// Stuff only relevant for Thomas (only visible if user is Thomas)
class ThomasGroups extends ConsumerWidget {
  const ThomasGroups({super.key});
  final visualDensity = const VisualDensity(horizontal: 0, vertical: -3);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);

    return SliverList(
      delegate: SliverChildListDelegate([
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
        if (appSettings.user == User.thomas)
          ListTile(
            // tileColor: Colors.purple.shade800,
            title: const Text(
              'Grafana',
              style: textStyleShadowOne,
            ),
            leading: const Icon(Icons.auto_graph),
            visualDensity: visualDensity,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GrafanaPage(),
                ),
              );
            },
          ),
        const Divider(),
      ]),
    );
  }
}
