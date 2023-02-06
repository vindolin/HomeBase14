// import 'package:flutter/widgets.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../models/mqtt_devices.dart';
// import 'curtain_icons_widget.dart';

// class AnimatedWidget extends HookConsumerWidget {
//   final Duration duration = const Duration(milliseconds: 5000);

//   final String deviceId;

//   const AnimatedWidget(this.deviceId, {super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final controller = useAnimationController(duration: duration);
//     controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         controller.reverse();
//       }
//     });

//     final device = ref.watch(
//       curtainDevicesProvider.select(
//         (mqttDevices) => mqttDevices[deviceId],
//       ),
//     );

//     useValueChanged(device!.position, (_, __) async {
//       controller.forward();
//     });

//     return AnimatedBuilder(
//       animation: controller,
//       builder: (context, child) {
//         return curtainIcon(device);
//       },
//     );
//   }
// }
