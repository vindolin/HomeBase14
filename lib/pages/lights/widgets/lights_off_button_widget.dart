import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/mqtt_devices.dart';

class LightDevicesOffButton extends ConsumerWidget {
  const LightDevicesOffButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lightDevices = ref.watch(lightDevicesProvider);
    int onLightCount = lightDevices.values.where((lightDevice) => lightDevice.state == 'ON').length;

    return IconButton(
      color: onLightCount > 0 ? Colors.amber : null,
      onPressed: () => ref.read(lightDevicesProvider.notifier).allOff(),
      icon: Badge(
        label: Text(onLightCount.toString()),
        backgroundColor: Colors.amber[800],
        textColor: Colors.black,
        child: const Icon(Icons.lightbulb),
      ),
    );
  }
}

class SmartBulbsOffButton extends ConsumerWidget {
  const SmartBulbsOffButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final smartLightDevices = ref.watch(smartBulbDevicesProvider);
    int onLightCount = smartLightDevices.values.where((smartLightDevice) => smartLightDevice.state == 'ON').length;

    return IconButton(
      color: onLightCount > 0 ? Colors.amber : null,
      onPressed: () => ref.read(smartBulbDevicesProvider.notifier).allOff(),
      icon: Badge(
        label: Text(onLightCount.toString()),
        backgroundColor: Colors.amber[800],
        textColor: Colors.black,
        child: const Icon(Icons.lightbulb),
      ),
    );
  }
}

class CombinedLIghtsOffButton extends ConsumerWidget {
  const CombinedLIghtsOffButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lightDevices = ref.watch(lightDevicesProvider);
    final smartLightDevices = ref.watch(smartBulbDevicesProvider);
    int onLightCount = lightDevices.values.where((lightDevice) => lightDevice.state == 'ON').length +
        smartLightDevices.values.where((smartLightDevice) => smartLightDevice.state == 'ON').length;

    return IconButton(
      color: onLightCount > 0 ? Colors.amber : null,
      onPressed: () {
        ref.read(lightDevicesProvider.notifier).allOff();
        ref.read(smartBulbDevicesProvider.notifier).allOff();
      },
      icon: Badge(
        label: Text(onLightCount.toString()),
        backgroundColor: Colors.amber[800],
        textColor: Colors.black,
        child: const Icon(Icons.lightbulb),
      ),
    );
  }
}
