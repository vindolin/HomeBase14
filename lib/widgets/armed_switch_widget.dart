import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/mqtt_providers.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '/models/mqtt_devices.dart';

Future<bool> confirmIcon(
  BuildContext context, {
  Widget? title,
  required Widget icon,
}) async {
  final bool? isConfirm = await showDialog<bool>(
    context: context,
    builder: (_) => WillPopScope(
      child: AlertDialog(
        title: title,
        content: IconButton(icon: icon, onPressed: () => Navigator.pop(context, true)),
      ),
      onWillPop: () async {
        Navigator.pop(context, false);
        return true;
      },
    ),
  );

  return isConfirm ?? false;
}

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

    return Card(
      child: Column(
        children: [
          Text(switchDevice.name),
          IconButton(
            iconSize: 40,
            highlightColor: Colors.red,
            icon: Icon(
              switchDevice.state == switchDevice.on ? switchDevice.iconOn : switchDevice.iconOff,
              color: switchDevice.state == switchDevice.on ? switchDevice.colorOn : switchDevice.colorOff,
            ),
            onPressed: () async {
              if (switchDevice.state == switchDevice.on) {
                setState(() {
                  ref.read(switchDevicesProvider.notifier).toggleState(switchDevice.id);
                });
                return;
              }

              final confirmation = await confirmIcon(
                context,
                title: const Text('Ganz sicher?'),
                icon: Icon(
                  switchDevice.state == switchDevice.on ? switchDevice.iconOn : switchDevice.iconOff,
                  color: switchDevice.state == switchDevice.on ? switchDevice.colorOn : switchDevice.colorOff,
                  size: 40,
                ),
              );
              if (confirmation) {
                setState(() {
                  ref.read(switchDevicesProvider.notifier).toggleState(switchDevice.id);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
