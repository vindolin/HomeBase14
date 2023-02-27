import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:homer/pages/home/widgets/temperatures_widget.dart';

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
      body: Stack(
        children: [
          StreamContainerBlinker(
            doorMovementProvider,
            vibrate: true,
            ignoreFirstBuild: true,
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Row(
                  children: [
                    Text(
                      translate('app_bar.title'),
                      style: const TextStyle(
                        // fontFamily: FontFa,
                        fontSize: 30,
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
                    const Spacer(),
                    const Temperatures(),
                  ],
                ),
                // actions: const [Text('1')],
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
      bottomNavigationBar: const ConnectionBar(),
    );
  }
}
