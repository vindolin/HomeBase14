import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_base_14/widgets/slider_widget.dart';
import '/models/mqtt_providers.dart';
import '/models/mqtt_devices.dart';
import 'influxdb_widget.dart';

class IrrigatorPage extends ConsumerWidget {
  const IrrigatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soilMoisture = ref.watch(mqttMessagesFamProvider('irrigator/soil'));
    final targetMoisture = ref.watch(mqttMessagesFamProvider('irrigator/target'));

    double? target = targetMoisture != null && targetMoisture != '' ? targetMoisture.toDouble() : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Irrigator'),
      ),
      body: Card(
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
                value: target ?? 0,
                min: 0,
                max: 50,
                minColor: Colors.grey,
                maxColor: Colors.red,
                divisions: 20,
                inactiveColor: Colors.grey,
                secondaryActiveColor: Colors.blue,
                secondaryTrackValue: soilMoisture?.toDouble() ?? 0,
                onChangeEnd: (value) {
                  ref.read(mqttProvider.notifier).publish(
                        'irrigator/set/targetMoisture',
                        value.toInt().toString(),
                      );
                },
              ),
              const InfluxdbWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
