import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/utils.dart';
import '/models/generic_providers.dart';
import '/widgets/connection_bar_widget.dart';
import 'widgets/doors_widget.dart';
import 'widgets/multiplug_widget.dart';
import 'widgets/humitemps_widget.dart';

class OtherPage extends ConsumerWidget {
  const OtherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('OtherPage.build()');
    final appLog = ref.watch(appLogProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('device_names.other')),
        actions: const [ConnectionBar()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
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
            const Card(
              child: Row(
                children: [
                  HumiTempWidget(),
                ],
              ),
            ),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Text(
                appLog.join('\n'),
                overflow: TextOverflow.fade,
              ),
            ),
            // Text(appLog.length.toString()),
          ],
        ),
      ),
    );
  }
}
