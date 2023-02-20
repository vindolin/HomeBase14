import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/mqtt_providers.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '/models/mqtt_devices.dart';

Future<bool> confirmIcon(
  BuildContext context, {
  Widget? title,
  required Widget icon,
  required double iconSize,
}) async {
  final bool? isConfirm = await showDialog<bool>(
    context: context,
    builder: (_) => WillPopScope(
      child: AlertDialog(
        title: title,
        content: IconButton(icon: icon, iconSize: iconSize, onPressed: () => Navigator.pop(context, true)),
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
  final iconSize = 60.0;
  final String id;
  const ArmedSwitch(this.id, {super.key});

  @override
  ConsumerState<ArmedSwitch> createState() => _ArmedSwitchState();
}

class _ArmedSwitchState extends ConsumerState<ArmedSwitch> {
  bool transitioning = false;

  @override
  Widget build(BuildContext context) {
    final switchDevice = ref.watch(
      switchDevicesProvider.select((switchDevices) => switchDevices[widget.id]),
    )!;

    return Card(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              // Text(switchDevice.name),
              IconButton(
                iconSize: widget.iconSize,
                icon: Icon(
                  switchDevice.state == switchDevice.on ? switchDevice.iconOn : switchDevice.iconOff,
                  color: switchDevice.state == switchDevice.on ? switchDevice.colorOn : switchDevice.colorOff,
                ),
                onPressed: () async {
                  // only publish passive state e.g. off/close without confirmation
                  if (switchDevice.state == switchDevice.on) {
                    setState(() {
                      ref.read(switchDevicesProvider.notifier).toggleState(switchDevice.id);
                    });
                    return;
                  }

                  // else open the confirm dialog
                  final confirmation = await confirmIcon(
                    context,
                    title: const Text('Ganz sicher?'),
                    icon: Icon(
                      switchDevice.state == switchDevice.on ? switchDevice.iconOn : switchDevice.iconOff,
                      color: switchDevice.state == switchDevice.on ? switchDevice.colorOn : switchDevice.colorOff,
                      size: widget.iconSize,
                    ),
                    iconSize: widget.iconSize,
                  );
                  // and publish the value if confirmed
                  if (confirmation) {
                    setState(() {
                      ref.read(switchDevicesProvider.notifier).toggleState(switchDevice.id);
                    });
                  }
                },
              ),
              Text(switchDevice.state == switchDevice.on ? switchDevice.textOn : switchDevice.textOff),
            ],
          ),
          switchDevice.transitioning ? const CircularProgressIndicator() : Container()
        ],
      ),
    );
  }
}
