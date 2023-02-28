import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bordered_text/bordered_text.dart';

import 'prusa_nozzle_widget.dart';
import '/models/mqtt_devices.dart';
import '/models/watch_mqtt_message.dart';

class PrusaProgress extends ConsumerWidget {
  const PrusaProgress({super.key});

  Map<String, int?> getProgressData(ref) {
    Map<String, int?> retVal = {'percent_done': null, 'mins_remaining': null};
    try {
      String payload = watchMqttMessage(mqttMessagesProvider, ref, 'prusa/progress');
      Map<String, dynamic> payloadDecoded = jsonDecode(payload);
      retVal['percent_done'] = int.parse(payloadDecoded['percent_done']);
      retVal['mins_remaining'] = int.parse(payloadDecoded['mins_remaining']);
    } catch (_) {}
    return retVal;
  }

  String getFileName(ref) {
    try {
      String payload = watchMqttMessage(mqttMessagesProvider, ref, 'prusa/file');
      Map<String, dynamic> payloadDecoded = jsonDecode(payload);
      return payloadDecoded['file_name'];
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressData = getProgressData(ref);
    String fileName = getFileName(ref);
    int heightPercent = progressData['percent_done'] ?? 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/benchy.png'),
            ),
            Positioned(
              bottom: constraints.maxHeight / 100 * heightPercent,
              child: Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            if (progressData['percent_done'] != null)
              BorderedText(
                strokeWidth: 4,
                strokeColor: Colors.black87,
                child: Text(
                  '${progressData['percent_done']}%',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
              ),
            Column(
              children: [
                if (progressData['mins_remaining'] != null)
                  Text(
                    '≈${progressData['mins_remaining']} min',
                    style: const TextStyle(fontSize: 11),
                  ),
                const Spacer(),
                Text(
                  fileName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
            const Positioned(
              top: 0,
              left: 0,
              child: PrusaNozzle(),
            ),
          ],
        );
      }),
    );
  }
}
