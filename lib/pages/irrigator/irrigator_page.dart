import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/widgets/slider_widget.dart';
import '/models/mqtt_providers.dart';
import '/models/mqtt_devices.dart';
import '/widgets/influxdb_widget.dart';

class IrrigatorPage extends ConsumerWidget {
  const IrrigatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soilMoistureProvider = ref.watch(mqttMessagesFamProvider('irrigator/soil'));
    final targetMoisture = ref.watch(mqttMessagesFamProvider('irrigator/target'));

    // clamp values slider range
    final target = (targetMoisture != null && targetMoisture != '' ? targetMoisture.toDouble() : null).clamp(0, 50);
    double soilMoisture = (soilMoistureProvider?.toDouble() ?? 0).clamp(0, 50);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Irrigator'),
      ),
      body: SingleChildScrollView(
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Coffee bush irrigation', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Soil moisture: $soilMoisture'),
                Text('Set target moisture: ${target != null ? target.toInt() : "???"}'),
                SliderWidget(
                  value: target,
                  min: 0,
                  max: 50,
                  minColor: Colors.grey,
                  maxColor: Colors.red,
                  divisions: 20,
                  inactiveColor: Colors.grey,
                  secondaryActiveColor: Colors.blue,
                  secondaryTrackValue: soilMoisture.toDouble(),
                  onChangeEnd: (value) {
                    ref.read(mqttProvider.notifier).publish(
                          'irrigator/set/targetMoisture',
                          value.toInt().toString(),
                        );
                  },
                ),
                InfluxChartWidget(
                  measurement: 'irrigator',
                  timeSpan: '12h',
                  groupTime: '10m',
                  numberFormat: '#0',
                  labelFormat: '{value} %',
                  fields: {
                    'target': {
                      'name': 'Target moisture',
                      'color': Colors.blue,
                      'nameFormat': (value) => 'Aktuell ${value.toStringAsFixed(0)} %',
                    },
                    'soil': {
                      'name': 'Soil moisture',
                      'color': Colors.red,
                      'nameFormat': (value) => 'Ziel ${value.toStringAsFixed(0)} %',
                    },
                  },
                ),
                Card(
                  color: Colors.grey.shade800,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Actions:',
                            style: TextStyle(color: Colors.grey.shade300, fontWeight: FontWeight.bold, fontSize: 20)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                            onPressed: () {
                              ref.read(mqttProvider.notifier).publish('irrigator/measure', '');
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text('Check now', style: TextStyle(fontSize: 18)),
                            )),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  ref.read(mqttProvider.notifier).publish('irrigator/openValve', '');
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Text('Open valve', style: TextStyle(fontSize: 18)),
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  ref.read(mqttProvider.notifier).publish('irrigator/closeValve', '');
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Text('Close valve', style: TextStyle(fontSize: 18)),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
