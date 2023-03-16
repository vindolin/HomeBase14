import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/styles/text_styles.dart';
import '/utils.dart';
import '/widgets/mqtt_switch_widget.dart';
import '/widgets/connection_bar_widget.dart';
import 'dropdown_select_widget.dart';

class ThomasPage extends ConsumerWidget {
  const ThomasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('ThomasPage.build()');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thomas'),
        actions: const [ConnectionBar()],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(8),
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        children: [
          // Card(
          //   color: Colors.amber[900],
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: const [
          //       Text(
          //         'Select sleep mode',
          //         style: textStyleShadowOne,
          //       ),
          //       SleepModeDropdown(),
          //     ],
          //   ),
          // ),
          Card(
            color: Colors.amber[900],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text(
                  'Select sleep mode',
                  style: textStyleShadowOne,
                ),
                DropdownSelect(
                  options: {
                    'wakeup': '☕️ - wake up',
                    'sleep': '😴 - sleep',
                    'hibernate': '🐻 - hibernate',
                  },
                  statTopic: 'leech/sleep',
                  setTopic: 'leech/sleep/set',
                ),
              ],
            ),
          ),
          Card(
            color: Colors.cyan[900],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text(
                  'Select Monitor',
                  style: textStyleShadowOne,
                ),
                DropdownSelect(
                  options: {
                    'tv': '📺 - TV',
                    'monitor': '💻 - Monitor',
                  },
                  statTopic: 'leech/screens',
                  setTopic: 'leech/screens/set',
                ),
              ],
            ),
          ),
          const Card(
            child: Center(
              child: MqttSwitchWidget(
                title: 'Meep A!',
                statTopic: 'meep/a/stat',
                setTopic: 'meep/a/set',
                optimistic: true,
                orientation: MqttSwitchWidgetOrientation.horizontal,
              ),
            ),
          ),
          const Card(
            child: Center(
              child: MqttSwitchWidget(
                title: 'Meep B!',
                statTopic: 'meep/b/stat',
                setTopic: 'meep/b/set',
                optimistic: false,
                orientation: MqttSwitchWidgetOrientation.vertical,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
