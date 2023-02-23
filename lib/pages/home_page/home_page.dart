import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'armed_buttons.dart';
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
              deviceGroups(context, visualDensity),
              armedButtons(),
              // SliverPadding(
              //   padding: const EdgeInsets.all(2.0),
              //   sliver: SliverGrid(
              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 4,
              //       mainAxisExtent: 110,
              //       mainAxisSpacing: 8.0,
              //       crossAxisSpacing: 10.0,
              //       childAspectRatio: 2.0,
              //     ),
              //     delegate: SliverChildBuilderDelegate(
              //       (BuildContext context, int index) {
              //         final buttons = [Container(child:Text('meep')),];

              //         return index >= buttons.length ? null : buttons[index];
              //       },
              //       childCount: 4,
              //     ),
              //   ),
              // ),
              cameras(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const ConnectionBar(),
    );
  }
}
