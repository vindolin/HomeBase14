import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '/models/mqtt_devices.dart';
import '/widgets/pulsating_container_hooks_widget.dart';

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
        content: IconButton(
          icon: icon,
          iconSize: iconSize,
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      onWillPop: () async {
        Navigator.pop(context, false);
        return true;
      },
    ),
  );

  return isConfirm ?? false;
}

class ArmedSwitchButton extends ConsumerStatefulWidget {
  final iconSize = 60.0;
  final String id;
  final String label;
  final IconData iconOn;
  final IconData iconOff;
  final Color colorOn;
  final Color colorOff;
  final String textOn;
  final String textOff;
  final bool confirm;

  const ArmedSwitchButton({
    required this.id,
    required this.label,
    required this.iconOn,
    required this.iconOff,
    required this.colorOn,
    required this.colorOff,
    required this.textOn,
    required this.textOff,
    this.confirm = false,
    super.key,
  });

  @override
  ConsumerState<ArmedSwitchButton> createState() => _ArmedSwitchState();
}

class _ArmedSwitchState extends ConsumerState<ArmedSwitchButton> {
  bool transitioning = false;

  @override
  Widget build(BuildContext context) {
    final switchDevice = ref.watch(
      switchDevicesProvider.select((switchDevices) => switchDevices[widget.id]),
    )!;

    // print('ArmedSwitchButton: ${widget.label} ${switchDevice.state} ${switchDevice.state.runtimeType}');
    return Card(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (switchDevice.state == switchDevice.onState) PulsatingContainer(color: widget.colorOn),
          Column(
            children: [
              // Text(switchDevice.name),
              IconButton(
                iconSize: widget.iconSize,
                icon: Icon(
                  switchDevice.state == switchDevice.onState ? widget.iconOn : widget.iconOff,
                  color: switchDevice.state == switchDevice.onState ? widget.colorOn : widget.colorOff,
                ),
                onPressed: () async {
                  // only publish passive state e.g. off/close without confirmation
                  if (widget.confirm == false || switchDevice.state == switchDevice.onState) {
                    setState(() {
                      ref.read(switchDevicesProvider.notifier).toggleState(widget.id);
                    });
                    return;
                  }

                  // else open the confirm dialog
                  final confirmation = await confirmIcon(
                    context,
                    title: Text(translate('questions.are_you_sure')),
                    icon: Icon(
                      switchDevice.state == switchDevice.onState ? widget.iconOn : widget.iconOff,
                      color: switchDevice.state == switchDevice.onState ? widget.colorOn : widget.colorOff,
                      size: widget.iconSize,
                    ),
                    iconSize: widget.iconSize,
                  );
                  // and publish the value if confirmed
                  if (confirmation) {
                    setState(() {
                      ref.read(switchDevicesProvider.notifier).toggleState(widget.id);
                    });
                  }
                },
              ),
              Flexible(
                child: Text(
                  switchDevice.state == switchDevice.onState ? widget.textOn : widget.textOff,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          if (switchDevice.transitioning) const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
