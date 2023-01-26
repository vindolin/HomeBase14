// import 'dart:ui';
// // import 'dart:developer' as d;
// import 'package:flutter/material.dart';
// import 'package:mqtee/models/mqtt_devices.dart';
// import 'package:provider/provider.dart';
// import '../models/mqtt_client.dart';
// import 'flashing_card_widget.dart';
// import 'value_icon_widget.dart';

// class MqttDevice extends StatelessWidget {
//   final Widget child;
//   final String deviceId;
//   const MqttDevice({required this.deviceId, required this.child, super.key});

//   Widget childWrapper(child, device) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             ValueIcon(IconType.wifi, device.linkQuality),
//             Flexible(
//               flex: 3,
//               child: Text(
//                 mqttDeviceDescriptions[deviceId]!,
//                 softWrap: false,
//                 overflow: TextOverflow.fade,
//               ),
//             ),
//             device.battery != null
//                 ? ValueIcon(IconType.battery, device.battery!)
//                 : const SizedBox(
//                     width: 16,
//                     height: 16,
//                   ),
//           ],
//         ),
//         Expanded(child: child),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Mqtt>(
//       builder: (_, mqtt, __) {
//         return AbsorbPointer(
//           absorbing: !mqtt.connected,
//           child: ChangeNotifierProvider<AbstractMqttDevice>.value(
//             value: mqttDevices.items[deviceId],
//             child: Consumer<AbstractMqttDevice>(
//               builder: (_, device, __) {
//                 log('change ${device.deviceId}');
//                 return FlashingCard(
//                   child: Padding(
//                     padding: const EdgeInsets.all(4),
//                     child: Stack(
//                       children: mqtt.connected
//                           ? [childWrapper(child, device)]
//                           : [
//                               childWrapper(child, device),
//                               BackdropFilter(
//                                 filter: ImageFilter.blur(sigmaX: 1.2, sigmaY: 1.5),
//                                 child: Container(),
//                               )
//                             ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
