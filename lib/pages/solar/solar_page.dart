import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/utils.dart';
import '/widgets/connection_bar_widget.dart';
import '/widgets/influxdb_widget.dart';

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
