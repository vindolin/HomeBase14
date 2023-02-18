import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/mqtt_providers.dart';

import '/models/mqtt_devices.dart';

class ArmedSwitch extends ConsumerStatefulWidget {
  final String id;
  const ArmedSwitch(this.id, {super.key});

  @override
  ConsumerState<ArmedSwitch> createState() => _ArmedSwitchState();
}

class _ArmedSwitchState extends ConsumerState<ArmedSwitch> {
  @override
  Widget build(BuildContext context) {
    final switchDevice = ref.watch(
      switchDevicesProvider.select((switchDevices) => switchDevices[widget.id]),
    )!;

    print('building ArmedSwitch: $switchDevice');
    return Icon(
      switchDevice.state == switchDevice.on ? switchDevice.iconOn : switchDevice.iconOff,
      color: switchDevice.state == switchDevice.on ? switchDevice.colorOn : switchDevice.colorOff,
      size: 64,
    );
  }
}
