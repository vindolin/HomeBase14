import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/models/secrets.dart';
import '/models/mqtt_providers.dart';
import '/pages/thermostat_list_page.dart';
import '/pages/curtain_list_page.dart';
import '/pages/light_list_page.dart';
import '/pages/other_page.dart';
// import '/pages/video_page.dart';

import '/widgets/video_widget.dart';
import '/widgets/refreshable_image_widget.dart';
import '/widgets/stream_blinker_widget.dart';
import '/widgets/armed_switch_widget.dart';
import '/widgets/connection_bar_widget.dart';

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
class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  final visualDensity = const VisualDensity(horizontal: 0, vertical: -3);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          StreamContainerBlinker(
            doorAlarmProvider,
            vibrate: true,
            ignoreFirstBuild: true,
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(
                  translate('app_bar.title'),
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black54,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                floating: true,
                snap: true,
                expandedHeight: 80.0,
                flexibleSpace: const FlexibleSpaceBar(
                  background: Image(
                    image: AssetImage('assets/images/homebase.jpg'),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
              ),
              // const SliverHeader(Colors.red, 'SliverPersistentHeader 1'),
              SliverList(
                delegate: SliverChildListDelegate([
                  ListTile(
                    title: Text(translate('device_names.thermostats')),
                    leading: const Icon(Icons.thermostat),
                    visualDensity: visualDensity,
                    // tileColor: Colors.amber,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ThermostatListPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(translate('device_names.curtains')),
                    leading: const Icon(Icons.blinds),
                    visualDensity: visualDensity,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CurtainListPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(translate('device_names.lights')),
                    leading: const Icon(Icons.lightbulb),
                    visualDensity: visualDensity,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LightPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(translate('device_names.other')),
                    leading: const Icon(Icons.extension),
                    visualDensity: visualDensity,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OtherPage(),
                        ),
                      );
                    },
                  ),
                  // const Divider(),
                  // ListTile(
                  //   title: Text(translate('device_names.video')),
                  //   leading: const Icon(Icons.lightbulb),
                  //   visualDensity: visualDensity,
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => VideoPage(),
                  //       ),
                  //     );
                  //   },
                  // ),
                ]),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(2.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 110,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 2.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final buttons = [
                        const ArmedSwitch(
                          'garage',
                          Icons.garage,
                          Icons.garage,
                          Colors.pink,
                          Colors.green,
                        ),
                        const ArmedSwitch(
                          'burglar',
                          Icons.remove_red_eye,
                          Icons.remove_red_eye,
                          Colors.pink,
                          Colors.orange,
                        ),
                        const ArmedSwitch(
                          'pump',
                          Icons.water_drop_outlined,
                          Icons.water_drop_outlined,
                          Colors.pink,
                          Colors.blue,
                        ),
                      ];

                      return index >= buttons.length ? null : buttons[index];
                    },
                    childCount: 3,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 110,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 2.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final buttons = [
                        Stack(
                          children: [
                            RefreshableImage(doorCamUrl),
                            // const CamWidget(),
                          ],
                        ),
                        ...List.generate(
                          3 * 10,
                          (index) => const Icon(
                            Icons.image_not_supported,
                            size: 64,
                          ),
                        ),
                      ];

                      return index >= buttons.length ? null : buttons[index];
                    },
                    childCount: 2 * 5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const ConnectionBar(),
    );
  }
}
