import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gap/gap.dart';

import '/widgets/mqtt_switch_widget.dart';
import '/widgets/slider_widget.dart';
import '/models/mqtt_providers.dart';
import '/models/mqtt_devices.dart';
import '/widgets/influxdb_widget.dart';

class IncubatorPage extends ConsumerWidget {
  const IncubatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heaterDutyCycle = (ref.watch(mqttMessagesFamProvider('incubator/heater')) ?? 0).toDouble();
    final humidity = ref.watch(mqttMessagesFamProvider('home/humidity')).toInt();

    // clamp values slider range

    final target = (ref.watch(mqttMessagesFamProvider('incubator/target_temp')) ?? 0).toDouble().clamp(20, 45);
    final temperature = (ref.watch(mqttMessagesFamProvider('incubator/temp')) ?? 0).toInt().clamp(20, 45);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Incubator 🦠',
          // 'Incubator \uf499',
          // style: TextStyle(fontFamily: 'NerdFont'),
        ),
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
                Text('Fermentation Incubator', style: Theme.of(context).textTheme.titleLarge),
                const Gap(8),
                Text('Temperature: $temperature°C'),
                Text('Set target temperature: ${target != 0 ? target.toInt() : "???"}°C'),
                SliderWidget(
                  value: target.toDouble(),
                  min: 20,
                  max: 46,
                  minColor: Colors.grey,
                  maxColor: Colors.red,
                  divisions: 26,
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
                const Gap(8),
                InfluxChartWidget(
                  measurement: 'incubator',
                  timeSpan: '12h',
                  groupTime: '10m',
                  minimum: 20,
                  maximum: 45,
                  numberFormat: '#0',
                  labelFormat: '{value}°C',
                  fields: {
                    'temp': {
                      'name': 'Current',
                      'color': Colors.blue,
                      'nameFormat': (value) => 'Aktuell ${value.toStringAsFixed(0)}°C',
                    },
                    'target_temp': {
                      'name': 'Target',
                      'color': Colors.orange,
                      'nameFormat': (value) => 'Ziel ${value.toStringAsFixed(0)}°C',
                    },
                    'heater': {
                      'name': 'Heater Duty Cycle',
                      'color': Colors.red.withAlpha(50),
                      'nameFormat': (value) => 'Duty Cycle ${value.toStringAsFixed(0)}%',
                    },
                  },
                ),
                Text('Heater duty cycle: ${heaterDutyCycle ?? "???"}%'),
                const Gap(8),
                Flexible(
                  child: LinearProgressIndicator(
                    value: heaterDutyCycle != null ? heaterDutyCycle / 100 : 0,
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.lerp(Colors.blue, Colors.red, heaterDutyCycle.toDouble() / 100)!,
                    ),
                    backgroundColor: Colors.grey.withAlpha(100),
                  ),
                ),
                const Gap(16),
                Text('Humidity: ${humidity ?? "???"}%'),
                const Gap(8),
                MqttSwitchWidget(
                  title: ref.watch(mqttMessagesFamProvider('incubator/on_state')).toString(),
                  statTopic: 'incubator/on_state',
                  setTopic: 'incubator/set/on_state',
                  optimistic: true,
                  orientation: MqttSwitchWidgetOrientation.horizontal,
                ),
                const Gap(8),
                Card(
                  color: Colors.grey.shade800,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Presets:',
                            style: TextStyle(color: Colors.grey.shade300, fontWeight: FontWeight.bold, fontSize: 20)),
                        const Gap(8),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            ...{
                              'koji': {'name': 'Koji', 'temp': 30},
                              'natto': {'name': 'Natto', 'temp': 42},
                              'tempeh': {'name': 'Tempeh', 'temp': 34},
                              'lactobazillus': {'name': 'Milchsauer', 'temp': 21},
                            }.entries.map(
                                  (e) => ElevatedButton(
                                    onPressed: () {
                                      ref
                                          .read(mqttProvider.notifier)
                                          .publish('incubator/set/target_temp', e.value['temp'].toString());
                                    },
                                    child: Text('${e.value['name']} @ ${e.value['temp']}°C'),
                                  ),
                                ),
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
