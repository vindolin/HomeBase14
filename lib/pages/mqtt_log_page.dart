import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/mqtt_providers.dart';

final messageQueue = Queue();

class MqttLog extends ConsumerWidget {
  const MqttLog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(messageProvider).when(
          data: (data) {
            if (messageQueue.length > 100) {
              messageQueue.removeFirst();
            }
            messageQueue.add(data);
            return data;
          },
          loading: () => null,
          error: (err, stack) => null,
        );

    // return Text of last 100 messages
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: messageQueue.length,
          itemBuilder: (context, index) {
            // newest message first
            int reverseIndex = messageQueue.length - 1 - index;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${messageQueue.elementAt(reverseIndex)?.topic}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '${messageQueue.elementAt(reverseIndex)?.payload}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MqttLogPage extends ConsumerWidget {
  const MqttLogPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Message Log'),
      ),
      body: const Center(
        child: MqttLog(),
      ),
    );
  }
}
