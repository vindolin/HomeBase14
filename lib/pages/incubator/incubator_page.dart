import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/widgets/mqtt_switch_widget.dart';
import '/widgets/slider_widget.dart';
import '/models/mqtt_providers.dart';
import '/models/mqtt_devices.dart';
import 'influxdb_widget.dart';

class IncubatorPage extends ConsumerWidget {
  const IncubatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tempProvider = ref.watch(mqttMessagesFamProvider('incubator/temp'));
    final targetTemp = ref.watch(mqttMessagesFamProvider('incubator/target_temp'));
    final heaterDutyCycle = ref.watch(mqttMessagesFamProvider('incubator/heater'));

    // print('tempProvider: $tempProvider');
    // print('targetTemp: $targetTemp');

    // clamp values slider range
    final target = (targetTemp != null && targetTemp != '' ? targetTemp.toDouble() : null).clamp(20, 45);
    double temperature = (tempProvider?.toDouble() ?? 0).clamp(20, 45);
    // double temperature = 20;
    // double target = 30;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incubator'),
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
              Text('Fermentation Incubator', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('Temperature: $temperature°C'),
              Text('Set target temperature: ${target != null ? target.toInt() : "???"}°C'),
              SliderWidget(
                value: target,
                min: 20,
                max: 46,
                minColor: Colors.grey,
                maxColor: Colors.red,
                divisions: 20,
                inactiveColor: Colors.grey,
                secondaryActiveColor: Colors.blue,
                secondaryTrackValue: temperature.toDouble(),
                onChangeEnd: (value) {
                  ref.read(mqttProvider.notifier).publish(
                        'incubator/set/target_temp',
                        value.toInt().toString(),
                      );
                },
              ),
              const SizedBox(height: 8),
              Text('Heater duty cycle: ${heaterDutyCycle ?? "???"}%'),
              const SizedBox(height: 8),
              const InfluxdbWidget(),
              MqttSwitchWidget(
                title: ref.watch(mqttMessagesFamProvider('incubator/on_state')).toString(),
                statTopic: 'incubator/on_state',
                setTopic: 'incubator/set/on_state',
                optimistic: true,
                orientation: MqttSwitchWidgetOrientation.horizontal,
              )
            ],
          ),
        ),
      ),
    );
  }
}
