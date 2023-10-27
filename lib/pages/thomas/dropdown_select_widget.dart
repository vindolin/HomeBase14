import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/mqtt_devices.dart';
import '/styles/text_styles.dart';

class DropdownSelect extends ConsumerStatefulWidget {
  final String statTopic;
  final String setTopic;
  final Map<String, String> options;
  const DropdownSelect({required this.options, required this.statTopic, required this.setTopic, super.key});

  @override
  ConsumerState<DropdownSelect> createState() => _DropdownSelectState();
}

class _DropdownSelectState extends ConsumerState<DropdownSelect> {
  late String dropdownValue = widget.options.keys.first;

  @override
  Widget build(BuildContext context) {
    final mqttMessage = ref.watch(
      mqttMessagesProvider.select(
        (mqttMessages) {
          return mqttMessages[widget.statTopic];
        },
      ),
    );

    if (widget.options.keys.contains(mqttMessage?.payload)) {
      dropdownValue = mqttMessage!.payload;
    }

    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? value) {
        ref.read(mqttMessagesProvider.notifier).publishCallback(widget.setTopic, value!, retain: false);
        ref.read(mqttMessagesProvider.notifier).publishCallback(widget.statTopic, value, retain: true);
        setState(
          () {
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
