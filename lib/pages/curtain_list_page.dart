import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/utils.dart';
import '/models/mqtt_devices.dart';
import '/pages/curtain_detail_page.dart';
import '/pages/dual_curtain_detail_page.dart';
import '/widgets/connection_bar_widget.dart';

const String assetName = 'assets/images/svg/blinds.svg';
final Widget svg = SvgPicture.asset(
  assetName,
  // semanticsLabel: 'blinds',
  color: Colors.white,
  width: 24,
  height: 24,
);

class CurtainPainter extends CustomPainter {
  final double position;
  final topBarHeight = 4.0;
  final bottomBarHeight = 3.0;
  final blindsMaxHeight = 0.0;
  final blindsPadding = 1.0;

  CurtainPainter(this.position);

  @override
  bool shouldRepaint(CurtainPainter oldDelegate) => oldDelegate.position != position;

  @override
  void paint(Canvas canvas, Size size) {
    final blindsMaxHeight = size.height - (topBarHeight + bottomBarHeight);
    final blindsClosedHeight = blindsMaxHeight * (100 - position) / 100;

    final blindsPaint = Paint()..color = Colors.white;

    // top bar
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, topBarHeight),
      blindsPaint,
    );
    // bottom bar
    canvas.drawRect(
      Rect.fromLTRB(0, size.height - bottomBarHeight, size.width, size.height),
      blindsPaint,
    );

    for (var i = topBarHeight; i < topBarHeight + blindsClosedHeight; i++) {
      if (i % 2 == 0) {
        canvas.drawRect(
          Rect.fromLTRB(
            blindsPadding,
            i.toDouble(),
            size.width - blindsPadding,
            i.toDouble() + 1,
          ),
          blindsPaint,
        );
      }
    }

    final paint = Paint()..color = Colors.transparent;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }
}

Widget mkCurtainIcon() {
  return const Icon(
    Icons.curtains,
  );
}

Widget mkDualCurtainIconx() {
  return const Icon(
    Icons.door_front_door,
  );
}

dualCurtainIcon(double position) {
  log(position);
  return CustomPaint(
    painter: CurtainPainter(position),
    size: const Size(24, 24),
  );
}

class CurtainListPage extends ConsumerWidget {
  const CurtainListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('CurtainListPage.build()');

    final deviceNames = ref.read(deviceNamesProvider);

    final curtainDevicesUnfiltered = ref.watch(curtainDevicesProvider);
    final curtainDevices = ref.watch(
      Provider<Map<String, CurtainDevice>>(
        (ref) {
          return curtainDevicesUnfiltered.sortByList([
            (a, b) => deviceNames[a.key]!.compareTo(
                  deviceNames[b.key]!,
                ),
          ]);
        },
      ),
    );

    final dualCurtainDevicesUnfiltered = ref.watch(dualCurtainDevicesProvider);
    final dualCurtainDevices = ref.watch(
      Provider<Map<String, DualCurtainDevice>>(
        (ref) {
          return dualCurtainDevicesUnfiltered.sortByList([
            (a, b) => deviceNames[a.key]!.compareTo(
                  deviceNames[b.key]!,
                ),
          ]);
        },
      ),
    );

    Map<String, AbstractMqttDevice> combinedCurtainDevices = {
      ...dualCurtainDevices,
      ...curtainDevices,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Curtains'),
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: combinedCurtainDevices.length,
          itemBuilder: (context, index) {
            final device = combinedCurtainDevices.values.elementAt(index);
            bool isDualCurtain = device is DualCurtainDevice;

            return ListTile(
              leading: isDualCurtain ? dualCurtainIcon(device.positionLeft) : mkCurtainIcon(),
              key: Key(device.deviceId),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Text(
                deviceNames[device.deviceId]!,
              ),
              subtitle: Row(
                children: [
                  isDualCurtain
                      // ? Text(
                      //     '${device.deviceType} ${device.positionLeft} ${device.positionRight}',
                      //   )
                      ? Text(
                          '${device.deviceType}',
                        )
                      : Text('${device.deviceType} C'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => isDualCurtain
                        ? DualCurtainDetailPage(deviceId: device.deviceId)
                        : CurtainDetailPage(deviceId: device.deviceId),
                  ),
                );
              },
            );
          }),
      floatingActionButton: const ConnectionBar(),
    );
  }
}
