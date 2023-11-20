import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:ir_sensor_plugin/ir_sensor_plugin.dart';
import 'package:audioplayers/audioplayers.dart';

import '/models/mqtt_providers.dart';
import '/styles/styles.dart';
import '/utils.dart';
import '/widgets/mqtt_switch_widget.dart';
import '/widgets/connection_bar_widget.dart';
import 'dropdown_select_widget.dart';
// import 'test_page.dart';
// import 'video_player_test_widget.dart';
import 'video_player_test_page.dart';

/// Random stuff for Thomas
class ThomasPage extends ConsumerWidget {
  const ThomasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('ThomasPage.build()');
    return Scaffold(
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
              // child: VideoPlayerTestWidget(),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VideoApp(),
                    ),
                  );
                },
                // child: const WebviewVideo(),
                child: const Text('Video Player Test'),
              ),
            ),
            Card(
              child: TextButton(
                onPressed: () async {
                  // final String getCarrierFrequencies = await IrSensorPlugin.getCarrierFrequencies;
                  // print(getCarrierFrequencies);
                  // await IrSensorPlugin.setFrequencies(40000);
                  Map samsungHex = {
                    'power':
                        '0000 006d 0022 0003 00a9 00a8 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0040 0015 0015 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 0702 00a9 00a8 0015 0015 0015 0e6e',
                    'volume_up':
                        '0000 006d 0022 0003 00a9 00a8 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 0702 00a9 00a8 0015 0015 0015 0e6e',
                    'volume_down':
                        '0000 006d 0022 0003 00a9 00a8 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015 0015 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 0015 0015 003f 0015 003f 0015 003f 0015 003f 0015 0702 00a9 00a8 0015 0015 0015 0e6e',
                    'blue':
                        '0000 006d 0022 0003 00a9 00a8 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0040 0015 0015 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 0702 00a9 00a8 0015 0015 0015 0e6e',
                  };
                  samsungHex;

                  // Map necHex = {
                  //   'power':
                  //       '0000 0073 0000 0022 0144 00a2 0014 0014 0014 0014 0014 0014 0014 0014 0014 003c 0014 0014 0014 0014 0014 0014 0014 003c 0014 0014 0014 003c 0014 003c 0014 003c 0014 0014 0014 0014 0014 003c 0014 0014 0014 003c 0014 003c 0014 003c 0014 003c 0014 003c 0014 0014 0014 0014 0014 003c 0014 0014 0014 0014 0014 0014 0014 0014 0014 0014 0014 003c 0014 003c 0014 003c',
                  // };

                  // final String result = await IrSensorPlugin.transmitString(pattern: samsungHex['power']!);
                  // final String result = await IrSensorPlugin.transmitString(pattern: samsungHex['volume_up']!);
                  // await IrSensorPlugin.setFrequencies(38000);
                  // await IrSensorPlugin.transmitString(pattern: necHex['power']!);
                  await IrSensorPlugin.transmitString(pattern: samsungHex['power']!);
                  // transmit NEC pattern
                  // final String result = await IrSensorPlugin.transmitString(pattern: samsungHex['volume_up']!);
                },
                child: const Text('IR'),
              ),
            ),
            ...[
              {
                'topic': 'tulpe/spray',
                'icon': '🌿',
              },
              {
                'topic': 'tulpe/soda',
                'icon': '💦',
              },
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
                    ref.read(mqttProvider.notifier).publish(e['topic']!, 'ON');
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
            // Card(
            //   child: TextButton(
            //     onPressed: () async {
            //       final player = AudioPlayer();
            //       ref.read(mqttProvider.notifier).publish('tulpe/spray', 'ON');
            //       await player.play(AssetSource('sounds/pop.wav'));
            //     },
            //     child: const Text(
            //       '🌿',
            //       style: TextStyle(
            //         fontSize: 50,
            //       ),
            //     ),
            //   ),
            // ),
            // Card(
            //   child: TextButton(
            //     onPressed: () async {
            //       final player = AudioPlayer();
            //       ref.read(mqttProvider.notifier).publish('bluekey/login', '1');
            //       await player.play(AssetSource('sounds/pop.wav'));
            //     },
            //     child: const Text(
            //       '👾',
            //       style: TextStyle(
            //         fontSize: 50,
            //       ),
            //     ),
            //   ),
            // ),
            // Card(
            //   // child: VideoPlayerTestWidget(),
            //   child: TextButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const VideoApp(),
            //         ),
            //       );
            //     },
            //     // child: const WebviewVideo(),
            //     child: const Text('Video Player Test'),
            //   ),
            // ),
            // Card(
            //   // child: VideoPlayerTestWidget(),
            //   child: TextButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => VideoScreen(
            //             // url: 'rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4',
            //             url: secrets.camData['door']!['videoUrl']!,
            //           ),
            //         ),
            //       );
            //     },
            //     child: const Text('Video Player Test'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
