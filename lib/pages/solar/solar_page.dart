import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/utils.dart';
import '/widgets/connection_bar_widget.dart';
import 'influxdb_widget.dart';

class SolarPage extends ConsumerWidget {
  const SolarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('SolarPage.build()');

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('solar')),
        actions: const [ConnectionBar()],
      ),
      body: Column(
        children: [
          Expanded(
            child: Card(
              color: const Color.fromARGB(255, 66, 33, 62),
              child: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: constraints.maxHeight),
                    child: const InfluxdbWidget(),
                    // TODO: consolidate with /widgets/influxdb_widget.dart
                    // child: InfluxdbWidget(
                    //   titleFormat: (value) => 'Solar Watt ☀️ ${value.toStringAsFixed(1)} kW',
                    //   measurement: 'sma',
                    //   timeSpan: '12h',
                    //   groupTime: '10m',
                    //   numberFormat: '#0.0',
                    //   labelFormat: '{value} kW',
                    //   fields: {
                    //     'totw': {
                    //       'color': Colors.blue,
                    //       'nameFormat': (value) => 'Solar ${value.toStringAsFixed(1)} kW',
                    //     },
                    //     'total_w': {
                    //       'color': Colors.red,
                    //       'nameFormat': (value) => 'Verbrauch ${(value * 1000).toStringAsFixed(1)} W',
                    //     },
                    //   },
                    // ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
