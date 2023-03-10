import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

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
    final prusa = ref.watch(prusaProvider.select(
      // IMap is important here or select cannot compare the values and the widget would rebuild on changes to other attributes e.g. 'percent_done'
      (prusa) => IMap({
        'percent_done': prusa['percent_done'],
        'mins_remaining': prusa['mins_remaining'],
        'file_name': prusa['file_name'],
      }),
    ));

    int heightPercent = prusa['percent_done'];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            const Image(
              filterQuality: FilterQuality.medium,
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
            if (prusa['percent_done'] != null)
              Transform.rotate(
                angle: -0.6,
                child: BorderedText(
                  strokeWidth: 4,
                  strokeColor: Colors.black87,
                  child: Text(
                    '${prusa['percent_done']}%',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26, shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black54,
                        offset: Offset(2.0, 2.0),
                      ),
                    ]),
                  ),
                ),
              ),
            Column(
              children: [
                if (prusa['mins_remaining'] != null)
                  Text(
                    '≈${prusa['mins_remaining']} min',
                    style: const TextStyle(fontSize: 11),
                  ),
                const Spacer(),
                Text(
                  prusa['file_name'],
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
