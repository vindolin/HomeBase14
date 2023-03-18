import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/mqtt_devices.dart';

class HumiTempWidget extends ConsumerWidget {
  const HumiTempWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceNames = ref.read(deviceNamesProvider);
    final payload = ref.watch(humiTempDevicesProvider);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(child: Text('HumiTemps:')),
            ...payload.entries
                .map(
                  (e) => Card(
                    color: Colors.grey[700],
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            deviceNames[e.key] ?? e.key,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${e.value.humidity}%'),
                          Text('${e.value.temperature}°C'),
                        ],
                      ),
                    ),
                  ),
                )
                .toList()
          ],
        ),
      ),
    );
  }
}
