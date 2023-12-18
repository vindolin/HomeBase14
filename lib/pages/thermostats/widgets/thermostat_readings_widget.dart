import 'package:flutter/material.dart';

const heatingSetpointColor = Colors.grey;
const temperatureColors = {
  'perfect': Colors.green,
  'tooCold': Colors.blue,
  'tooHot': Colors.orange,
  'wayTooHot': Colors.red,
};

Color? getTemperatureColor(double temperature, double setpoint) {
  return temperature == setpoint
      ? temperatureColors['perfect']
      : temperature < setpoint
          ? temperatureColors['tooCold']
          : Color.lerp(
              temperatureColors['tooHot'],
              temperatureColors['wayTooHot'],
              (temperature - setpoint) / 10,
            );
}

class ThermostatReadings extends StatelessWidget {
  final double localTemperature;
  final int currentHeatingSetpoint;
  const ThermostatReadings({
    super.key,
    required this.localTemperature,
    required this.currentHeatingSetpoint,
  });

  @override
  Widget build(BuildContext context) {
    final tempColor = getTemperatureColor(
      localTemperature,
      currentHeatingSetpoint.toDouble(),
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
