import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';

import '/utils.dart';
import '/widgets/connection_bar_widget.dart';
import 'widgets/interval_segment_widget.dart';
import 'widgets/doors_widget.dart';
import 'widgets/multiplug_widget.dart';
import 'widgets/humitemps_widget.dart';

class OtherPage extends ConsumerWidget {
  const OtherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('OtherPage.build()');

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('device_names.other')),
        actions: const [ConnectionBar()],
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
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
            Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: DoorsWidget(),
              ),
            ),
            Card(
              child: Row(
                children: [
                  HumiTempWidget(),
                ],
              ),
            ),
            // Text(appLog.length.toString()),
            Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text('Bewegungsmelder'),
                    ),
                    Column(
                      children: [
                        Text('Terrasse'),
                        Gap(4),
                        AlarmIntervalSegmentButtons(
                          topic: 'home/motion/alarmInterval/terrace',
                        ),
                      ],
                    ),
                    Gap(16),
                    Column(
                      children: [
                        Text('Keller'),
                        Gap(4),
                        AlarmIntervalSegmentButtons(
                          topic: 'home/motion/alarmInterval/basement',
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
    );
  }
}
