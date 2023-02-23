import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homer/models/mqtt_devices.dart';

import '/utils.dart';
import '/widgets/connection_bar_widget.dart';

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
      body: const Center(
        child: DropdownButtonExample(),
      ),
    );
  }
}

class DropdownButtonExample extends ConsumerStatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  ConsumerState<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

const Map<String, String> options = {
  // 'none': '',
  'wake': '☕️ - wake up',
  'sleep': '😴 - sleep',
  'hibernate': '🐻 - hibernate',
};

class _DropdownButtonExampleState extends ConsumerState<DropdownButtonExample> {
  String dropdownValue = options.keys.first;

  @override
  Widget build(BuildContext context) {
    final simpleMqttMessage = ref.watch(
      simpleMqttMessagesProvider.select(
        (simpleMqttMessages) {
          return simpleMqttMessages['leech/sleepy'];
        },
      ),
    );

    if (simpleMqttMessage?.payload != null) {
      dropdownValue = simpleMqttMessage!.payload;
    }

    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? value) {
        ref.read(simpleMqttMessagesProvider.notifier).publishCallback('leech/sleepy', value!, retain: true);
        setState(
          () {
            print(value);
            dropdownValue = value;
          },
        );
      },
      items: options
          .map(
            (key, value) {
              return MapEntry(
                key,
                DropdownMenuItem<String>(
                  value: key,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(value),
                  ),
                ),
              );
            },
          )
          .values
          .toList(),
    );
  }
}
