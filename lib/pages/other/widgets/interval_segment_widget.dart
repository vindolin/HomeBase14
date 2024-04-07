import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/mqtt_devices.dart';
import '/models/mqtt_providers.dart';

enum IntervalSegment { hour, quarter, five, minute }

Map<IntervalSegment, String> intervalSegmentMap = {
  IntervalSegment.minute: '1m',
  IntervalSegment.five: '5m',
  IntervalSegment.quarter: '15m',
  IntervalSegment.hour: '1h',
};

/// A segmented button for selecting a rearm interval for the motion detectors
class AlarmIntervalSegmentButtons extends ConsumerStatefulWidget {
  final String topic;
  const AlarmIntervalSegmentButtons({super.key, required this.topic});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlarmIntervalSegmentButtonsState();
}

class _AlarmIntervalSegmentButtonsState extends ConsumerState<AlarmIntervalSegmentButtons> {
  @override
  Widget build(BuildContext context) {
    final alarmInterval = ref.watch(
      mqttMessagesFamProvider(widget.topic),
    );
    final alarmIntervalSelection = intervalSegmentMap.entries
        .firstWhere(
          (entry) => entry.value == alarmInterval,
          orElse: () => intervalSegmentMap.entries.first,
        )
        .key;

    return SegmentedButton<IntervalSegment>(
      segments: intervalSegmentMap.entries
          .map(
            (entry) => ButtonSegment<IntervalSegment>(
              value: entry.key,
              label: Text(entry.value),
              icon: const Icon(Icons.access_time),
            ),
          )
          .toList(),
      selected: <IntervalSegment>{alarmIntervalSelection},
      onSelectionChanged: (Set<IntervalSegment> newSelection) {
        ref.read(mqttProvider.notifier).publish(
              widget.topic,
              intervalSegmentMap[newSelection.first]!,
              retain: true,
            );
      },
    );
  }
}
