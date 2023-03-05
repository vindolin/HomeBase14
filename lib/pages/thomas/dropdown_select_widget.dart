import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/mqtt_devices.dart';
import '/styles/text_styles.dart';

class DropdownSelect extends ConsumerStatefulWidget {
  final String subTopic;
  final String pubTopic;
  final bool retain;
  final Map<String, String> options;
  const DropdownSelect({required this.options, required this.subTopic, required this.pubTopic, this.retain = false, super.key});

  @override
  ConsumerState<DropdownSelect> createState() => _DropdownStateSelect();
}

class _DropdownStateSelect extends ConsumerState<DropdownSelect> {
  late String dropdownValue = widget.options.keys.first;

  @override
  Widget build(BuildContext context) {
    final mqttMessage = ref.watch(
      mqttMessagesProvider.select(
        (mqttMessages) {
          return mqttMessages[widget.subTopic];
        },
      ),
    );

    if (mqttMessage?.payload != null) {
      dropdownValue = mqttMessage!.payload;
    }

    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? value) {
        ref.read(mqttMessagesProvider.notifier).publishCallback(widget.pubTopic, value!, retain: widget.retain);
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
