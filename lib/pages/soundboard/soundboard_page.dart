import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '/models/mqtt_providers.dart';
import '/styles/styles.dart';

class SoundboardPage extends ConsumerWidget {
  const SoundboardPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soundboard'),
      ),
      body: Container(
        decoration: fancyBackground,
        child: GridView.count(
          padding: const EdgeInsets.all(8),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          children: [
            ...[
              {
                'topic': 'homebase14/soundboard',
                'message': 'cat-screaming-a.wav',
                'icon': '😾',
              },
              {
                'topic': 'homebase14/soundboard',
                'message': 'alarm01.wav',
                'icon': '🚨',
              },
              {
                'topic': 'homebase14/soundboard',
                'message': 'alarm02.wav',
                'icon': '🚨',
              },
              {
                'topic': 'homebase14/soundboard',
                'message': 'wilhelm.wav',
                'icon': '🗡',
              },
            ].map((e) {
              return Card(
                child: TextButton(
                  onPressed: () async {
                    final player = AudioPlayer();
                    ref
                        .read(mqttProvider.notifier)
                        .publish(e['topic']!, e.containsKey('message') ? e['message']! : 'ON');
                    player.setVolume(0.05);
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
          ],
        ),
      ),
    );
  }
}
