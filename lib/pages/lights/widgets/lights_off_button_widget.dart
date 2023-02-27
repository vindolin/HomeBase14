import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/mqtt_devices.dart';

class LightsOffButton extends ConsumerWidget {
  const LightsOffButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lightDevices = ref.watch(lightDevicesProvider);
    int onLightCount = lightDevices.values.where((lightDevice) => lightDevice.state == 'ON').length;

    return IconButton(
      color: onLightCount > 0 ? Colors.amber : null,
      onPressed: () => ref.read(lightDevicesProvider.notifier).allOff(),
      icon: const Icon(Icons.lightbulb),
    );
  }
}
