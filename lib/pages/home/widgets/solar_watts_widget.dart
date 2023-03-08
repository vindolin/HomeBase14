import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/mqtt_providers.dart';
import '/models/mqtt_devices.dart';

const shadow = Shadow(
  offset: Offset(1.0, 1.0),
  blurRadius: 2.0,
  color: Colors.black,
);

class SolarWatts extends ConsumerWidget {
  const SolarWatts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int solarWatt = int.tryParse(
          getMessage(mqttMessagesProvider, ref, 'sma/tripower/totw') ?? '',
        ) ??
        0;

    double totalWatt = (double.tryParse(
              getMessage(mqttMessagesProvider, ref, 'sma/b3b461c9/total_w') ?? '',
            ) ??
            0.0) *
        -1.0;

    return Expanded(
      flex: 6,
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Solar:',
                ),
                TextSpan(
                    text: ' ${solarWatt}w',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.lerp(Colors.white, Colors.amber, solarWatt / 5500),
                    )),
              ],
            ),
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Verbrauch: ',
                ),
                TextSpan(
                    text: '${totalWatt}w',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: totalWatt > 0.0 ? Colors.red : Colors.green,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
