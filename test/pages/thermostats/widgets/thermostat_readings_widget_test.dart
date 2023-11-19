import 'package:home_base_14/pages/thermostats/widgets/thermostat_readings_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Widget Tests',
    () {
      testWidgets('Testing ThermostatReadings', (widgetTester) async {
        for (final e in [
          {'currentHeatingSetpoint': 21, 'localTemperature': 21, 'expectedColor': Colors.green}, // just right
          {'currentHeatingSetpoint': 21, 'localTemperature': 20, 'expectedColor': Colors.blue}, // too cold
          {'currentHeatingSetpoint': 21, 'localTemperature': 22, 'expectedColor': Colors.orange}, // too hot
        ]) {
          await widgetTester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ThermostatReadings(
                  currentHeatingSetpoint: e['currentHeatingSetpoint'] as double,
                  localTemperature: e['localTemperature'] as double,
                ),
              ),
            ),
          );

          await widgetTester.pumpAndSettle();
          final found = find.text('21.0°C').evaluate().single.widget as Text;
          expect(found.style!.color!.value, e['expectedColor'] as MaterialColor);
        }
      });
    },
  );
}
