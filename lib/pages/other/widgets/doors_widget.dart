import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'door_widget.dart';

class DoorsWidget extends ConsumerWidget {
  final bool miniMode;
  const DoorsWidget({super.key, this.miniMode = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: miniMode ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DoorWidget(topic: 'zigbee2mqtt/door/i001', miniMode: miniMode),
        DoorWidget(topic: 'zigbee2mqtt/door/i002', miniMode: miniMode),
        DoorWidget(topic: 'zigbee2mqtt/door/i003', miniMode: miniMode),
      ],
    );
  }
}
