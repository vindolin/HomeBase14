// @riverpod
// class Mqtt extends _$Mqtt {
//   final MqttClient mqtt = MqttClient();
//   @override
//   FutureOr<void> build() {
//     print('building mqtt');
//     mqtt.onConnected = onConnected;
//     mqtt.onDisconnected = onDisconnected;
//   }

//   Future<void> connect() async {
//     state = const AsyncValue.loading();
//     state = await AsyncValue.guard<void>(
//       () async {
//         // connecting
//         ref.read(mqttConnectionStateXProvider.notifier).state = MqttConnectionState.connecting;
//         Future.delayed(
//           const Duration(seconds: 2),
//           () {
//             mqtt.connect(config.username, config.password);
//           },
//         );
//       },
//     );
//   }

//   void disconnect() {
//     mqtt.disconnect();
//   }

//   void onConnected() {
//     print('connected');
//     mqtt.subscribe('homer/#', MqttQos.atMostOnce);

//     mqtt.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
//       final message = c![0].payload as MqttPublishMessage;
//       final payload = const Utf8Decoder().convert(message.payload.message);

//       print(message);
//       print(payload);
//     });

//     ref.read(mqttConnectionStateXProvider.notifier).state = MqttConnectionState.connected;
//   }

//   void onDisconnected() {
//     print('disconnected');
//     ref.read(mqttConnectionStateXProvider.notifier).state = MqttConnectionState.disconnected;
//   }
// }


// @riverpod
// class MqttConnectionDataXXX extends _$MqttConnectionDataXXX {
//   // Future<MqttConnectionDataClass> build() async {
//   @override
//   FutureOr<MqttConnectionDataClass> build() {
//     return const MqttConnectionDataClass(
//       username: config.username,
//       password: config.password,
//       address: config.server,
//       port: config.port,
//     );
//   }

//   Future<void> save(Map<String, dynamic> data) async {
//     state = const AsyncLoading();

//     state = await Future(
//       () => AsyncValue.data(
//         state.value!.copyWith(
//           username: data['username'],
//           password: data['password'],
//           address: data['address'],
//           port: data['port'],
//         ),
//       ),
//     );
//   }
// }

//     // final mqttConnectionData = ref.watch(mqttConnectionDataXXXProvider);
//     // Map<String, dynamic> formData = {
//     //   'username': mqttConnectionData.value?.username,
//     //   'password': mqttConnectionData.value?.password,
//     //   'address': mqttConnectionData.value?.address,
//     //   'port': mqttConnectionData.value?.port,
//     // };


//     final thermostatDevicesProvider = Provider<Map<String, dynamic>>((ref) {
//       return Map.fromEntries(
//         ({...mqttDevicesX}..removeWhere((_, device) => device is! ThermostatDevice)).entries.toList()
//           ..sort(
//             (a, b) => deviceNames[a.key]!.compareTo(
//               deviceNames[b.key]!,
//             ),
//           )
//           ..sort(
//             // then sort by local temperature
//             (a, b) => b.value.localTemperature.compareTo(
//               a.value.localTemperature,
//             ),
//           ),
//       );
//     });

// @riverpod
// Map<String, AbstractMqttDevice> curtainDevices(CurtainDevicesRef ref) {
//   final mqttDevices = ref.watch(mqttDevicesXProvider);
//   return {
//     ...Map.fromEntries(
//       ({...mqttDevices}..removeWhere(
//               (key, value) {
//                 return value is! CurtainDevice;
//               },
//             ))
//           .entries
//           .toList(),
//     ),
//   };
// }

// @riverpod
// Map<String, dynamic> curtainDevices(CurtainDevicesRef ref) {
//   final curtainDevices = ref.watch(curtainDevicesProvider);
//   return {
//     ...Map.fromEntries(
//       ({...curtainDevices}..removeWhere(
//               (key, value) {
//                 return !key.startsWith('dualCurtain');
//               },
//             ))
//           .entries
//           .toList(),
//     ),
//   };
// }


// class MyFancyPainter extends CustomPainter {
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       // ..style = PaintingStyle.stroke
//       ..style = PaintingStyle.fill
//       // ..strokeWidth = 4.0
//       ..color = Colors.indigo
//       ..shader = const LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [
//           Colors.indigo,
//           Colors.blue,
//         ],
//       ).createShader(const Rect.fromLTWH(0, 0, 24, 24));
//     // ..blendMode = BlendMode.color;

//     // canvas.drawRect(
//     //   const Rect.fromLTWH(0, 0, 24, 24),
//     //   paint,
//     // );
//   }
// }


// import 'package:flutter_svg/flutter_svg.dart';

// const String assetName = 'assets/images/svg/blinds.svg';
// final Widget svg = SvgPicture.asset(
//   assetName,
//   // semanticsLabel: 'blinds',
//   color: Colors.white,
//   width: 24,
//   height: 24,
// );

// final paint = Paint()..color = Colors.transparent;
// canvas.drawRect(
//   Rect.fromLTWH(0, 0, size.width, size.height),
//   paint,
// );


// if (widget.streamProvider != null) {
//   ref.watch(widget.streamProvider!.selectAsync((value) {
//     // select works by watching a changing value, so this workaround is needed
//     if (value != 0) triggerVal = !triggerVal;
//     return triggerVal;
//   }));
// }

// return Card(
//   elevation: 125,
//   color: Colors.black.withAlpha(20),
//   shadowColor: Colors.transparent,
//   child: Padding(
//     padding: const EdgeInsets.all(3.0),
//     child: Row(
//       children: [
//         const Icon(Icons.thermostat, color: Colors.white54),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             temperature('', tempInside, Colors.blue),
//             temperature('', tempOutside, Colors.green),
//             // Text(humidity),
//           ],
//         ),
//       ],
//     ),
//   ),
// );

// /// blocks rotation; sets orientation to: portrait
// void _portraitModeOnly() {
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.landscapeLeft,
//     DeviceOrientation.landscapeRight,
//   ]);
// }






// import 'dart:io' show Platform;
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:simple_shadow/simple_shadow.dart';

// import '/pages/home/widgets/temperatures_widget.dart';
// import '/pages/home/armed_switch_buttons/armed_switch_buttons.dart';

// import '/models/app_settings.dart';
// import '/models/mqtt_providers.dart';
// import '/models/app_version_provider.dart';
// import '/models/generic_providers.dart';

// import '/widgets/stream_blinker_widget.dart';
// import '/widgets/connection_bar_widget.dart';

// import 'device_group_slivers.dart';
// import 'thomas_group_slivers.dart';
// import 'cameras.dart';
// import 'widgets/solar_watts_widget.dart';
// import 'settings_form_widget.dart';

// class Delegate extends SliverPersistentHeaderDelegate {
//   final Color _backgroundColor;
//   final String _title;

//   Delegate(this._backgroundColor, this._title);

//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: _backgroundColor,
//       child: Center(
//         child: Text(
//           _title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   double get maxExtent => 80;

//   @override
//   double get minExtent => 50;

//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }

// class SliverHeader extends StatelessWidget {
//   final Color _backgroundColor;
//   final String _title;

//   const SliverHeader(this._backgroundColor, this._title, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SliverPersistentHeader(
//       pinned: true,
//       floating: false,
//       delegate: Delegate(_backgroundColor, _title),
//     );
//   }
// }

// @immutable
// class HomePage extends ConsumerWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final appVersion = ref.watch(appVersionProvider);
//     final appSettings = ref.watch(appSettingsProvider);
//     final mqttMessageCounter = ref.watch(counterProvider('mqtt_message'));

//     return Scaffold(
//       endDrawer: const Drawer(
//         child: SettingsForm(),
//       ),
//       body: RefreshIndicator(
//         // reload home page on pull down
//         onRefresh: () async {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const HomePage(),
//             ),
//           );
//         },
//         child: Container(
//             // glance effect of background
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 stops: [0.0, 0.6, 1.0],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Color.fromARGB(150, 0, 0, 0),
//                   Color.fromARGB(10, 0, 0, 0),
//                   Color.fromARGB(150, 0, 0, 0),
//                 ],
//               ),
//               image: DecorationImage(
//                 repeat: ImageRepeat.repeat,
//                 image: AssetImage('assets/images/bg_pattern.png'),
//               ),
//             ),
//             child: Stack(
//               children: [
//                 mqttMessageCounter <= 100
//                     ? const Positioned.fill(
//                         child: AbsorbPointer(),
//                       )
//                     : Container(),
//                 StreamContainerBlinker(
//                   doorMovementProvider, // flash background on object detection on front door cam
//                   vibrate: true,
//                   ignoreFirstBuild: true,
//                   color: Colors.pink.withOpacity(0.1),
//                 ),
//                 CustomScrollView(
//                   slivers: [
//                     SliverAppBar(
//                       iconTheme: const IconThemeData(color: Colors.black),
//                       titleSpacing: 0.0,
//                       leadingWidth: 10.0,
//                       leading: Container(),
//                       title: Stack(
//                         children: [
//                           Text(
//                             translate('app_bar.title'),
//                             style: GoogleFonts.robotoCondensed(
//                               textStyle: const TextStyle(
//                                 fontSize: 40,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                                 shadows: [
//                                   Shadow(
//                                     blurRadius: 3.0,
//                                     color: Colors.black54,
//                                     offset: Offset(2.0, 2.0),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             right: 0,
//                             top: -5,
//                             child: Transform.rotate(
//                               angle: 0.4,
//                               child: SimpleShadow(
//                                 opacity: 1.0,
//                                 offset: const Offset(2, 2),
//                                 child: SvgPicture.asset(
//                                   'assets/images/svg/14.svg',
//                                   colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
//                                   width: 42,
//                                   height: 42,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             bottom: 0,
//                             child: Text(
//                               Platform.operatingSystemVersion,
//                               style: const TextStyle(fontSize: 8),
//                             ),
//                           ),
//                           Positioned(
//                             bottom: 0,
//                             right: 0,
//                             child: Text(
//                               appVersion.when(
//                                 data: (value) => value,
//                                 loading: () => '...',
//                                 error: (e, s) => '...',
//                               ),
//                               style: const TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),
//                       forceElevated: true,
//                       pinned: true,
//                       floating: true,
//                       expandedHeight: 80.0,
//                       flexibleSpace: const FlexibleSpaceBar(
//                         background: Image(
//                           image: AssetImage('assets/images/homebase.jpg'),
//                           fit: BoxFit.cover,
//                           filterQuality: FilterQuality.medium,
//                         ),
//                       ),
//                     ),
//                     // const SliverHeader(Colors.red, 'SliverPersistentHeader 1'),
//                     const ArmedButtons(),
//                     const DeviceGroups(),
//                     const Cameras(),
//                     if (appSettings.user == User.thomas) const ThomasGroups(),
//                   ],
//                 ),
//               ],
//             )),
//       ),
//       bottomNavigationBar: Container(
//         // pattern on bottom bar
//         // decoration: const BoxDecoration(
//         //   image: DecorationImage(
//         //     fit: BoxFit.fitWidth,
//         //     image: AssetImage('assets/images/bar_pattern.jpg'),
//         //     filterQuality: FilterQuality.high,
//         //   ),
//         // ),
//         decoration: const BoxDecoration(
//           border: Border(
//             top: BorderSide(
//               color: Colors.black87,
//               width: 1.0,
//             ),
//           ),
//         ),
//         // color: Colors.black26,
//         child: const ConnectionBar(
//           children: [
//             Temperatures(),
//             SolarWatts(),
//           ],
//         ),
//       ),
//     );
//   }
// }
