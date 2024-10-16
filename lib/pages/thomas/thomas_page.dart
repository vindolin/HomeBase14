import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '/shortcut_wrapper.dart';
import '/models/mqtt_providers.dart';
import '/styles/styles.dart';
// import '/pages/placeholder_page.dart';
import '/pages/mqtt_log_page.dart';
import '/pages/remotes/remotes_page.dart';
// import '/utils.dart';
import '/widgets/mqtt_switch_widget.dart';
import '/widgets/connection_bar_widget.dart';
// import 'video_player_test_widget.dart';
import '/pages/home/dummy_page.dart';
import 'dropdown_select_widget.dart';

/// Random stuff for Thomas
class ThomasPage extends ConsumerWidget {
  const ThomasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // log('ThomasPage.build()');
    return shortcutWrapper(
      context,
      Scaffold(
        appBar: AppBar(
          title: const Text('Thomas'),
          actions: const [ConnectionBar()],
        ),
        body: Container(
          decoration: fancyBackground,
          child: GridView.count(
            padding: const EdgeInsets.all(8),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            children: [
              Card(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RemotesPage(),
                      ),
                    );
                  },
                  child: const Text('󰻅', style: TextStyle(fontFamily: 'NerdFont', fontSize: 50)),
                ),
              ),
              Card(
                // child: VideoPlayerTestWidget(),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MqttLogPage(),
                      ),
                    );
                  },
                  // child: const WebviewVideo(),
                  child: const Text(
                    '',
                    style: TextStyle(
                      fontFamily: 'NerdFont',
                      fontSize: 50,
                    ),
                  ),
                ),
              ),
              const Card(
                child: Center(
                  child: MqttSwitchWidget(
                    title: 'Prusa MK3S',
                    statTopic: 'stat/dose13/POWER',
                    setTopic: 'cmnd/dose13/POWER',
                    optimistic: false,
                    orientation: MqttSwitchWidgetOrientation.vertical,
                  ),
                ),
              ),
              const Card(
                child: Center(
                  child: MqttSwitchWidget(
                    title: 'Flashforge CP',
                    statTopic: 'stat/dose10/POWER',
                    setTopic: 'cmnd/dose10/POWER',
                    optimistic: false,
                    orientation: MqttSwitchWidgetOrientation.vertical,
                  ),
                ),
              ),
              ...[
                {
                  'topic': 'tulpe/spray',
                  'icon': '🌿',
                },
                // {
                //   'topic': 'tulpe/soda',
                //   'icon': '💦',
                // },
                {
                  'topic': 'bluekey/login',
                  'icon': '👾',
                },
                {
                  'topic': 'bluekey/escape',
                  'icon': '✖️',
                },
                {
                  'topic': 'bluekey/password',
                  'icon': '🔑',
                },
              ].map((e) {
                return Card(
                  child: TextButton(
                    onPressed: () async {
                      final player = AudioPlayer();
                      ref
                          .read(mqttProvider.notifier)
                          .publish(e['topic']!, e.containsKey('message') ? e['message']! : 'ON');
                      await player.play(AssetSource('sounds/pop.wav'));
                    },
                    child: Text(
                      e['icon']!,
                      style: const TextStyle(
                        fontSize: 50,
                      ),
                    ),
                  ),
                );
              }),
              Card(
                color: Colors.amber[900],
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Select sleep mode',
                      style: textStyleShadowOne,
                    ),
                    DropdownSelect(
                      options: {
                        'wakeup': '☕️ - wake up',
                        'sleep': '😴 - sleep',
                        'hibernate': '🐻 - hibernate',
                        'off': '❌ - off',
                      },
                      statTopic: 'leech/sleep',
                      setTopic: 'leech/sleep/set',
                    ),
                  ],
                ),
              ),
              Card(
                color: Colors.cyan[900],
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Select Monitor',
                      style: textStyleShadowOne,
                    ),
                    DropdownSelect(
                      options: {
                        'tv': '📺 - TV',
                        'monitor': '💻 - Monitor',
                      },
                      statTopic: 'leech/screens',
                      setTopic: 'leech/screens/set',
                    ),
                  ],
                ),
              ),
              const Card(
                child: Center(
                  child: MqttSwitchWidget(
                    title: 'Meep A!',
                    statTopic: 'meep/a/stat',
                    setTopic: 'meep/a/set',
                    optimistic: true,
                    orientation: MqttSwitchWidgetOrientation.horizontal,
                  ),
                ),
              ),
              const Card(
                child: Center(
                  child: MqttSwitchWidget(
                    title: 'Meep B!',
                    statTopic: 'meep/b/stat',
                    setTopic: 'meep/b/set',
                    optimistic: false,
                    orientation: MqttSwitchWidgetOrientation.vertical,
                  ),
                ),
              ),
              Card(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DummyPage(),
                      ),
                    );
                  },
                  child: const Text('Video Player Test'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
