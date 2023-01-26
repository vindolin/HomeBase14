// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/mqtt_devices.dart';
// import '../widgets/mqtt_device_widget.dart';
// import '../widgets/vertical_slider_widget.dart';

// class CurtainWidget extends StatefulWidget {
//   final String deviceId;
//   const CurtainWidget(this.deviceId, {super.key});

//   @override
//   State<CurtainWidget> createState() => _CurtainWidgetState();
// }

// class _CurtainWidgetState extends State<CurtainWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<CurtainDevice>.value(
//       value: mqttDevices.items[widget.deviceId],
//       child: Consumer<CurtainDevice>(builder: (_, device, __) {
//         return MqttDevice(
//           deviceId: widget.deviceId,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               VerticalSlider(
//                 device.position, // invert
//                 (double value) {
//                   setState(
//                     () => device.position = value.round().toDouble(),
//                   );
//                 },
//                 (double value) {
//                   device.publishState();
//                 },
//                 invert: true,
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
