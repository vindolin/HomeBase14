import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/pages/home/widgets/temperatures_widget.dart';

import '/models/mqtt_providers.dart';
import '/widgets/stream_blinker_widget.dart';
import '/widgets/connection_bar_widget.dart';

import '/utils.dart';
import '/models/mqtt_devices.dart';

class Delegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final String _title;

  Delegate(this.backgroundColor, this._title);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Text(
          _title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class SliverHeader extends StatelessWidget {
  final Color backgroundColor;
  final String _title;

  const SliverHeader(this.backgroundColor, this._title, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: Delegate(backgroundColor, _title),
    );
  }
}

@immutable
class LightPage extends ConsumerWidget {
  const LightPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('LightPage.build()');

    final lightDevices = ref.watch(lightDevicesProvider);
    // int onLightCount = lightDevices.values.where((lightDevice) => lightDevice.state == 'ON').length;

    return Scaffold(
      endDrawer: const Drawer(
        child: Text('Drawer'),
      ),
      body: RefreshIndicator(
        // reload home page on pull down
        onRefresh: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LightPage(),
            ),
          );
        },
        child: Stack(
          children: [
            StreamContainerBlinker(
              doorMovementProvider, // flash background on object detection on front door cam
              vibrate: true,
              ignoreFirstBuild: true,
              color: Colors.pink.withOpacity(0.1),
            ),
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  titleSpacing: 0.0,
                  leadingWidth: 10.0,
                  leading: Container(),
                  title: Text(translate('device_names.lights')),
                  forceElevated: true,
                  pinned: true,
                  floating: true,
                ),
                // SliverAppBar.medium(
                //   title: const Text('11'),
                //   actions: null,
                // ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final int itemIndex = index ~/ 2;
                      final key = lightDevices.keys.elementAt(itemIndex);
                      final device = lightDevices.values.elementAt(itemIndex);

                      return index.isEven
                          ? ListTile(
                              leading: device.state == 'ON'
                                  ? const Icon(
                                      Icons.lightbulb,
                                      color: Colors.amber,
                                    )
                                  : const Icon(
                                      Icons.lightbulb_outline,
                                      color: Colors.white,
                                    ),
                              key: Key(key),
                              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                              title: Row(
                                children: [
                                  Text(device.name),
                                ],
                              ),
                              onTap: () {
                                ref.read(lightDevicesProvider.notifier).toggleState(key);
                              },
                            )
                          : const Divider();
                    },
                    semanticIndexCallback: (Widget widget, int localIndex) {
                      if (localIndex.isEven) {
                        return localIndex ~/ 2;
                      }
                      return null;
                    },
                    childCount: math.max(0, lightDevices.length * 2 - 1),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     fit: BoxFit.fitWidth,
        //     image: AssetImage('assets/images/bar_pattern.jpg'),
        //     filterQuality: FilterQuality.high,
        //   ),
        // ),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black87,
              width: 1.0,
            ),
          ),
        ),
        // color: Colors.black26,
        child: const ConnectionBar(
          children: [
            SizedBox(width: 8.0),
            Temperatures(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
