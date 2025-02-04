import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:home_base_14/pages/thermostats/widgets/thermostat_readings_widget.dart';
import 'package:home_base_14/util/color.dart';

void main() {
  group(
    'Widget Tests',
    () {
      testWidgets('Testing ThermostatReadings', (widgetTester) async {
        for (final e in [
          {'currentHeatingSetpoint': 21, 'localTemperature': 21.0, 'expectedColor': Colors.green}, // just right
          {'currentHeatingSetpoint': 22, 'localTemperature': 21.0, 'expectedColor': Colors.blue}, // too cold
          {
            'currentHeatingSetpoint': 19,
            'localTemperature': 21.0,
            'expectedColor': const Color.fromRGBO(253, 135, 11, 1.0),
          }, // too hot
        ]) {
          await widgetTester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ThermostatReadings(
                  currentHeatingSetpoint: e['currentHeatingSetpoint'] as int,
                  localTemperature: e['localTemperature'] as double,
                ),
              ),
            ),
          );

          await widgetTester.pumpAndSettle();
          final found = find.text('21.0°C').evaluate().single.widget as Text;
          // check if the color matches (with a tolerance)
          expect(colorsClose(found.style!.color!, e['expectedColor'] as Color), isTrue);
        }
      });
    },
  );
}
