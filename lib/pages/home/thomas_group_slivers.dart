import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:format/format.dart';
import 'package:audioplayers/audioplayers.dart';

// import '../../utils.dart';
import '/styles/styles.dart';
import '/pages/thomas/thomas_page.dart';
import '/pages/grafana/grafana_page.dart';
import '/pages/thomas/dropdown_select_widget.dart';
import '/pages/soundboard/soundboard_page.dart';
import '/pages/irrigator/irrigator_page.dart';
// import '/pages/placeholder_page.dart';
import '/models/mqtt_providers.dart';
// import '/models/generic_providers.dart';
import '/models/mqtt_devices.dart';

String lastSprayDuration(String timestamp) {
  if (timestamp == 'null') return '---';
  final microseconds = int.parse(timestamp);
  final now = DateTime.now();
  final lastSpray = DateTime.fromMicrosecondsSinceEpoch(microseconds * 1000);
  final duration = now.difference(lastSpray);
  return '{:02d}:{:02d}'.format(duration.inHours, duration.inMinutes % 60);
}

/// Stuff only relevant for Thomas (only visible if user is Thomas)
class ThomasGroups extends ConsumerWidget {
  const ThomasGroups({super.key});
  final visualDensity = const VisualDensity(horizontal: 0, vertical: -3);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final leechOnlineState = ref.watch(mqttMessagesFamProvider('leech/online')).toString();
    final lastSpray = ref.watch(mqttMessagesFamProvider('tulpe/spray_last')).toString();

    TextStyle titleStyle = textStyleShadowOne.copyWith(
      shadows: [
        Shadow(
          blurRadius: 2.0,
          color: brightness == Brightness.dark ? Colors.black : Colors.black45,
          offset: const Offset(1.0, 1.0),
        ),
      ],
    );

    final inactiveColor = WebViewPlatform.instance != null
        ? brightness == Brightness.dark
            ? Colors.white
            : Colors.black
        : Colors.grey;

    return SliverList(
      delegate: SliverChildListDelegate([
        ListTile(
          // tileColor: Colors.purple.shade800,
          title: Text(
            'Thomas',
            style: titleStyle,
            overflow: TextOverflow.ellipsis,
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {},
                onLongPress: () async {
                  final player = AudioPlayer();
                  await player.play(AssetSource('sounds/pop.wav'));
                  ref.read(mqttProvider.notifier).publish('tulpe/spray', 'ON');
                },
                child: Text(
                  lastSprayDuration(lastSpray),
                  style: TextStyle(
                    color: Colors.green.withAlpha(120),
                    fontSize: 12,
                  ),
                ),
              ),
              Icon(Icons.power_settings_new,
                  color: switch (leechOnlineState) {
                    'on' => Colors.green,
                    'off' => Colors.red,
                    'sleep' => Colors.amber,
                    _ => Colors.grey,
                  }),
              const SizedBox(width: 8),
              const DropdownSelect(
                options: {
                  'wakeup': '☕️',
                  'sleep': '😴',
                  'hibernate': '🐻',
                  'off': '❌',
                },
                statTopic: 'leech/sleep',
                setTopic: 'leech/sleep/set',
              ),
              const SizedBox(width: 16),
              const DropdownSelect(
                options: {
                  'tv': '📺',
                  'monitor': '💻',
                },
                statTopic: 'leech/screens',
                setTopic: 'leech/screens/set',
              ),
            ],
          ),
        ),
        const Divider(),
        ListTile(
          // tileColor: Colors.purple.shade800,
          title: Text(
            'Grafana ${WebViewPlatform.instance != null ? '' : '(WebView is not available on this platform)'}',
            style: titleStyle.copyWith(
              color: inactiveColor,
            ),
          ),
          leading: Icon(Icons.auto_graph,
              color: WebViewPlatform.instance != null ? Theme.of(context).listTileTheme.iconColor : Colors.grey),
          visualDensity: visualDensity,
          onTap: () {
            WebViewPlatform.instance != null
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GrafanaPage(),
                    ),
                  )
                : null;
          },
        ),
        const Divider(),
        ListTile(
          title: Text(
            'Soundboard',
            style: titleStyle.copyWith(),
          ),
          leading: Icon(Icons.music_note, color: Theme.of(context).listTileTheme.iconColor),
          visualDensity: visualDensity,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SoundboardPage(),
              ),
            );
          },
        ),
        // ListTile(
        //   trailing: Text(
        //     '${ref.watch(counterProvider('mqtt_message'))}',
        //     style: TextStyle(
        //       color: Colors.amber.withAlpha(120),
        //       fontSize: 10,
        //     ),
        //   ),
        // ),
        // const Divider(),
        // ListTile(
        //   title: TextButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const PlaceholderPage(),
        //         ),
        //       );
        //     },
        //     child: const Text('login'),
        //   ),
        // ),
        const Divider(),
        ListTile(
          title: Text(
            'Irrigation',
            style: titleStyle.copyWith(),
          ),
          leading: Icon(Icons.water_drop, color: Theme.of(context).listTileTheme.iconColor),
          visualDensity: visualDensity,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const IrrigatorPage(),
              ),
            );
          },
        ),
      ]),
    );
  }
}
