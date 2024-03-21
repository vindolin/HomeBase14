import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/styles/text_styles.dart';
import '/utils.dart';
import '/models/mqtt_devices.dart';
import '/pages/solar/solar_page.dart';

const smaErrorValue = -2147483648; // magic number from SMA
const maxSolarWatt = 6000; // eat this super nova!

TextStyle titleTextStyle(Brightness brightness, {Color color = Colors.white}) {
  if (color == Colors.white) {
    color = brightness == Brightness.dark ? Colors.white : Colors.black;
  }
  return TextStyle(
    color: color,
    shadows: const [
      Shadow(
        offset: Offset(1.0, 1.0),
        blurRadius: 1.0,
        color: Colors.black,
      )
    ],
  );
}

class SolarWatts extends ConsumerWidget {
  const SolarWatts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(mqttMessagesFamProvider('sma/tripower/totw'));

    final brightness = Theme.of(context).brightness;

    String solarWattString = ref.watch(mqttMessagesFamProvider('sma/tripower/totw')).toString();
    int solarWatt = int.tryParse(solarWattString) ?? 0;
    if (solarWatt == smaErrorValue) solarWatt = 0;

    String totalWattString = ref.watch(mqttMessagesFamProvider('sma/b3b461c9/total_w')).toString();
    int totalWatt = (double.tryParse(totalWattString) ?? 0.0).toInt();

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
      Colors.grey,
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
            textScaler: const TextScaler.linear(0.9),
            text: TextSpan(
              style: titleTextStyle(brightness),
              children: [
                const TextSpan(
                  text: 'Solar: ',
                ),
                TextSpan(
                  text: '${solarWatt}w $sunEmoji',
                  style: bold.copyWith(
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
                  style: bold,
                  text: '${useWatt}w',
                ),
              ],
            ),
          ),
          RichText(
            textScaler: const TextScaler.linear(0.9),
            text: TextSpan(
              style: titleTextStyle(brightness),
              children: [
                const TextSpan(
                  text: ' = ',
                ),
                TextSpan(
                    text: '${totalWatt > 0 ? '+' : ''}${totalWatt}w $happy',
                    style: bold.copyWith(
                      color: totalWatt > 0 ? Colors.green : Colors.red,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
