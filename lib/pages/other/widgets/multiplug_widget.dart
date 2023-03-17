import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/mqtt_providers.dart';
import '/models/mqtt_devices.dart';

class MultiplugWidget extends ConsumerWidget {
  final int plugCount;
  final String topic;

  const MultiplugWidget({
    required this.plugCount,
    required this.topic,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payload = ref.watch(mqttMessagesFamProvider(topic));
    var filteredPayload = {};
    if (payload != null) {
      // filter relevant keys
      filteredPayload = Map.from(payload)..removeWhere((k, v) => !k.startsWith('state_l'));
    } else {
      // create default payload
      filteredPayload = {
        for (var item in List<int>.generate(plugCount, (i) => i + 1)) 'state_l$item': 'OFF',
      };
    }

    return Row(
      children: List<Widget>.generate(
        plugCount,
        (i) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('L${i + 1}'),
            Switch(
              value: filteredPayload['state_l${i + 1}'] == 'ON' ? true : false,
              onChanged: (value) {
                filteredPayload['state_l${i + 1}'] = value ? 'ON' : 'OFF';
                ref.read(mqttProvider.notifier).publish(
                      '$topic/set',
                      jsonEncode(filteredPayload),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
