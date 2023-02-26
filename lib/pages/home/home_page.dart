import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/pages/home/armed_switch_buttons/armed_switch_buttons.dart';
import 'device_group_slivers.dart';
import 'cameras.dart';

import '/models/mqtt_providers.dart';
import '/widgets/stream_blinker_widget.dart';
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
      endDrawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/rivig.jpg'), fit: BoxFit.fitWidth),
              ),
              child: Text('Settings'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
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
                title: Text(
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
                // actions: [],
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
              deviceGroups(context, visualDensity),
              cameras(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const ConnectionBar(),
    );
  }
}
