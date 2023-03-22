import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/pages/home/home_page.dart';
import '/utils.dart';
import '/widgets/connection_bar_widget.dart';
import '/widgets/influxdb_widget.dart';
import 'widgets/doors_widget.dart';
import 'widgets/multiplug_widget.dart';
import 'widgets/humitemps_widget.dart';

class OtherPage extends ConsumerWidget {
  const OtherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('OtherPage.build()');

    return pageAfterHome(
      context,
      Scaffold(
        appBar: AppBar(
          title: Text(translate('device_names.other')),
          actions: const [ConnectionBar()],
          leading: homeBackButton(context),
        ),
        body: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    Text('Multiplug Sofa'),
                    Spacer(),
                    MultiplugWidget(
                      plugCount: 3,
                      topic: 'zigbee2mqtt/multiplug/i001',
                    ),
                  ],
                ),
              ),
            ),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: DoorsWidget(),
              ),
            ),
            Card(
              child: Row(
                children: const [
                  HumiTempWidget(),
                ],
              ),
            ),
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
      ),
    );
  }
}
