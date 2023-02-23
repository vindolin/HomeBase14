import 'package:flutter/material.dart';
import 'package:homer/models/mqtt_devices.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SleepModeDropdown extends ConsumerStatefulWidget {
  const SleepModeDropdown({super.key});

  @override
  ConsumerState<SleepModeDropdown> createState() => _SleepModeDropdownState();
}

const Map<String, String> options = {
  // 'none': '',
  'wake': '☕️ - wake up',
  'sleep': '😴 - sleep',
  'hibernate': '🐻 - hibernate',
};

class _SleepModeDropdownState extends ConsumerState<SleepModeDropdown> {
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
