import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'door_widget.dart';

class DoorsWidget extends ConsumerWidget {
  const DoorsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        DoorWidget(topic: 'zigbee2mqtt/door/i001'),
        DoorWidget(topic: 'zigbee2mqtt/door/i002'),
        DoorWidget(topic: 'zigbee2mqtt/door/i003'),
      ],
    );
  }
}
