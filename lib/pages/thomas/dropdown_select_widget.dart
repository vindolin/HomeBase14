import 'package:flutter/material.dart';
import 'package:homer/models/mqtt_devices.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/styles/text_styles.dart';

class DropdownSelect extends ConsumerStatefulWidget {
  final String subTopic;
  final String pubTopic;
  final Map<String, String> options;
  const DropdownSelect({required this.options, required this.subTopic, required this.pubTopic, super.key});

  @override
  ConsumerState<DropdownSelect> createState() => _DropdownStateSelect();
}

class _DropdownStateSelect extends ConsumerState<DropdownSelect> {
  late String dropdownValue = widget.options.keys.first;

  @override
  Widget build(BuildContext context) {
    final simpleMqttMessage = ref.watch(
      simpleMqttMessagesProvider.select(
        (simpleMqttMessages) {
          return simpleMqttMessages[widget.subTopic];
        },
      ),
    );

    if (simpleMqttMessage?.payload != null) {
      print(simpleMqttMessage?.payload);
      dropdownValue = simpleMqttMessage!.payload;
    }

    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? value) {
        ref.read(simpleMqttMessagesProvider.notifier).publishCallback(widget.pubTopic, value!, retain: true);
        setState(
          () {
            print(value);
            dropdownValue = value;
          },
        );
      },
      items: widget.options
          .map(
            (key, value) {
              return MapEntry(
                key,
                DropdownMenuItem<String>(
                  value: key,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(value, style: textStyleShadowOne),
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
