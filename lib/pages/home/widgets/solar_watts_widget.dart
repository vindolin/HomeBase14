import 'dart:developer' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/utils.dart';
import '/models/mqtt_devices.dart';
import '/pages/solar/solar_page.dart';

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
    ref.watch(mqttMessagesFamProvider('sma/tripower/totw'));

    final brightness = Theme.of(context).brightness;

    String solarWatt_ = ref.watch(mqttMessagesFamProvider('sma/tripower/totw')).toString();
    int solarWatt = int.parse(solarWatt_);
    if (solarWatt == smaErrorValue) solarWatt = 0;

    String totalWatt_ = ref.watch(mqttMessagesFamProvider('sma/b3b461c9/total_w')).toString();
    int totalWatt = double.parse(totalWatt_).toInt();

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

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SolarPage(),
          ),
        );
      },
      child: Column(
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
                TextSpan(
                    text: 'Verbrauch: ',
                    style: TextStyle(
                      color: brightness == Brightness.dark ? Colors.white : Colors.black,
                    )),
                TextSpan(
                  text: '${useWatt}w',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: brightness == Brightness.dark ? Colors.white : Colors.black),
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
                TextSpan(
                  text: ' = ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: brightness == Brightness.dark ? Colors.white : Colors.black),
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
      ),
    );
  }
}
