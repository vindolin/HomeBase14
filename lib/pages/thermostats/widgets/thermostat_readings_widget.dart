import 'package:flutter/material.dart';

const heatingSetpointColor = Color.fromARGB(255, 100, 100, 100);
const temperatureColors = {
  'perfect': Colors.green,
  'tooCold': Colors.blue,
  'tooHot': Colors.orange,
};

MaterialColor? getTemperatureColor(double temperature, double setpoint) {
  return temperature == setpoint
      ? temperatureColors['perfect']
      : temperature < setpoint
          ? temperatureColors['tooCold']
          : temperatureColors['tooHot'];
}

class ThermostatReadings extends StatelessWidget {
  final double localTemperature;
  final double currentHeatingSetpoint;
  const ThermostatReadings({super.key, required this.localTemperature, required this.currentHeatingSetpoint});

  @override
  Widget build(BuildContext context) {
    final tempColor = getTemperatureColor(
      localTemperature,
      currentHeatingSetpoint,
    );

    return Row(
      children: [
        Text(
          '$localTemperature°C',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: tempColor,
          ),
        ),
        Text(
          '  / $currentHeatingSetpoint°C',
          style: const TextStyle(
            color: heatingSetpointColor,
          ),
        ),
      ],
    );
  }
}
