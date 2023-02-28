import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';

import '/pages/home/widgets/temperatures_widget.dart';
import '/pages/home/armed_switch_buttons/armed_switch_buttons.dart';
import 'device_group_slivers.dart';
import 'cameras.dart';

import '/models/mqtt_providers.dart';
import '/widgets/stream_blinker_widget.dart';
import '/widgets/connection_bar_widget.dart';
import 'user_select_widget.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      endDrawer: const Drawer(
        child: UserSelect(),
      ),
      body: RefreshIndicator(
        // reload home page on pull down
        onRefresh: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
        child: Container(
          // glance effect of background
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              stops: [0.0, 0.6, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(150, 0, 0, 0),
                Color.fromARGB(10, 0, 0, 0),
                Color.fromARGB(150, 0, 0, 0),
              ],
            ),
            image: DecorationImage(
              repeat: ImageRepeat.repeat,
              image: AssetImage('assets/images/bg_pattern.png'),
            ),
          ),
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
                    title: Stack(
                      children: [
                        Text(
                          translate('app_bar.title'),
                          style: GoogleFonts.robotoCondensed(
                            textStyle: const TextStyle(
                              fontSize: 40,
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
                        ),
                      ],
                    ),
                    forceElevated: true,
                    pinned: true,
                    floating: true,
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
                  armedButtons(),
                  const DeviceGroups(),
                  cameras(),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ConnectionBar(
        children: [
          SizedBox(width: 8.0),
          Temperatures(),
          Spacer(),
        ],
      ),
    );
  }
}
