import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:simple_shadow/simple_shadow.dart';

import '/pages/home/widgets/temperatures_widget.dart';
import '/pages/home/armed_switch_buttons/armed_switch_buttons.dart';

import '/models/app_settings.dart';
import '/models/mqtt_providers.dart';

import '/widgets/stream_blinker_widget.dart';
import '/widgets/connection_bar_widget.dart';

import 'device_group_slivers.dart';
import 'thomas_group_slivers.dart';
import 'cameras.dart';
import 'widgets/solar_watts_widget.dart';
import 'user_select_widget.dart';

class Delegate extends SliverPersistentHeaderDelegate {
  final Color _backgroundColor;
  final String _title;

  Delegate(this._backgroundColor, this._title);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: _backgroundColor,
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
  final Color _backgroundColor;
  final String _title;

  const SliverHeader(this._backgroundColor, this._title, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: Delegate(_backgroundColor, _title),
    );
  }
}

@immutable
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);

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
                    iconTheme: const IconThemeData(color: Colors.black),
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
                        Positioned(
                          right: 0,
                          top: -5,
                          child: Transform.rotate(
                            angle: 0.4,
                            child: SimpleShadow(
                              opacity: 1.0,
                              offset: const Offset(2, 2),
                              child: SvgPicture.asset(
                                'assets/images/svg/14.svg',
                                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                width: 42,
                                height: 42,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Text(
                            Platform.operatingSystemVersion,
                            style: const TextStyle(fontSize: 8),
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
                  const ArmedButtons(),
                  const DeviceGroups(),
                  const Cameras(),
                  if (appSettings.user == User.thomas) const ThomasGroups(),
                ],
              ),
            ],
          ),
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
            Temperatures(),
            SolarWatts(),
          ],
        ),
      ),
    );
  }
}
