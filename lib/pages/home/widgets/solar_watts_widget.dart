import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/utils.dart';
import '/models/mqtt_providers.dart';
import '/models/mqtt_devices.dart';

const smaErrorValue = -2147483648;
const maxSolarWatt = 6000;

const shadow = Shadow(
  offset: Offset(1.0, 1.0),
  blurRadius: 2.0,
  color: Colors.black,
);

const dividerText = TextSpan(
  text: ' | ',
  style: TextStyle(
    color: Colors.white30,
  ),
);

class SolarWatts extends ConsumerWidget {
  const SolarWatts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int solarWatt = int.tryParse(
          getMessage(mqttMessagesProvider, ref, 'sma/tripower/totw') ?? '',
        ) ??
        0;

    if (solarWatt == smaErrorValue) solarWatt = 0;

    int totalWatt = (double.tryParse(
              getMessage(mqttMessagesProvider, ref, 'sma/b3b461c9/total_w') ?? '',
            ) ??
            0.0)
        .round();

    // solarWatt = 20;
    // totalWatt = 400;
    // print('solarWatt: $solarWatt, totalWatt: $totalWatt');

    int useWatt = solarWatt - totalWatt;

    final sunEmoji = valueToItem(
      ['☁️', '🌥', '⛅️', '🌤', '☀️'],
      solarWatt,
      maxSolarWatt,
    );

    String happy = totalWatt == 0.0
        ? '😐'
        : totalWatt > 0.0
            ? totalWatt > 3000
                ? '😎'
                : '😃'
            : '🙁';

    final solarColor = Color.lerp(
      Colors.white,
      Colors.amber,
      solarWatt / 5500,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              shadows: [
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 1.0,
                  color: Colors.black,
                )
              ],
            ),
            children: [
              const TextSpan(
                text: 'Solar: ',
              ),
              TextSpan(
                text: '${solarWatt}w $sunEmoji',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: solarColor,
                ),
              ),
              const TextSpan(
                text: ' - ',
              ),
              const TextSpan(
                text: 'Verbrauch: ',
              ),
              TextSpan(
                text: '${useWatt}w',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              shadows: [
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 1.0,
                  color: Colors.black,
                )
              ],
            ),
            children: [
              const TextSpan(
                text: ' = ',
              ),
              TextSpan(
                text: '${totalWatt > 0 ? '+' : ''}${totalWatt}w $happy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: totalWatt > 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
