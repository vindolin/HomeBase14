import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:ir_sensor_plugin/ir_sensor_plugin.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '/utils.dart';

class RemotesWidget extends ConsumerWidget {
  final String? soundFile;

  const RemotesWidget({super.key, this.soundFile});

  Container createIconButton(String text, String hexCode, {String soundFile = 'button1.mp3'}) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 240),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onTap: () async {
          final player = AudioPlayer();
          await player.play(AssetSource('sounds/$soundFile'));
          await IrSensorPlugin.transmitString(pattern: hexCode);
        },
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontFamily: 'NerdFont', fontSize: 30),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('RemotesPage.build()');
    return Column(
      children: [
        Text('Samsung TV', style: Theme.of(context).textTheme.titleLarge),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: StaggeredGrid.count(
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              crossAxisCount: 2,
              children: [
                StaggeredGridTile.extent(
                  crossAxisCellCount: 1,
                  mainAxisExtent: 108,
                  child: createIconButton(
                    '⏻ ',
                    '0000 006d 0022 0003 00a9 00a8 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0040 0015 0015 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 0702 00a9 00a8 0015 0015 0015 0e6e',
                  ),
                ),
                StaggeredGridTile.extent(
                  crossAxisCellCount: 1,
                  mainAxisExtent: 50,
                  child: createIconButton(
                    ' ',
                    '0000 006d 0022 0003 00a9 00a8 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 0702 00a9 00a8 0015 0015 0015 0e6e',
                  ),
                ),
                StaggeredGridTile.extent(
                  crossAxisCellCount: 1,
                  mainAxisExtent: 50,
                  child: createIconButton(
                    ' ',
                    '0000 006d 0022 0003 00a9 00a8 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015 0015 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 0015 0015 003f 0015 003f 0015 003f 0015 003f 0015 0702 00a9 00a8 0015 0015 0015 0e6e',
                  ),
                ),
                StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: createIconButton(
                    '󰻂 ',
                    '0000 006D 0022 0000 00AC 00AE 0014 0043 0014 0043 0012 0044 0012 0018 0014 0016 0014 0018 0012 0018 0014 0018 0012 0043 0014 0043 0014 0043 0014 0016 0014 0018 0012 0018 0014 0016 0014 0018 0014 0016 0014 0018 0012 0018 0014 0043 0012 0018 0014 0043 0014 0043 0012 0018 0014 0043 0014 0043 0012 0044 0012 0018 0014 0043 0012 0018 0014 0018 0012 0044 0012 06C3',
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
        Text('Edifier Box', style: Theme.of(context).textTheme.titleLarge),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: StaggeredGrid.count(
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              crossAxisCount: 2,
              children: [
                StaggeredGridTile.extent(
                  crossAxisCellCount: 1,
                  mainAxisExtent: 108,
                  child: createIconButton(
                    '⏻ ',
                    '0000 006D 0022 0000 0155 00AE 0014 0018 0014 0016 0014 0016 0014 0018 0014 0016 0012 0018 0014 0018 0014 0016 0014 0043 0014 0043 0012 0043 0014 0043 0012 0043 0014 0043 0012 0044 0012 0043 0014 0018 0012 0043 0012 0044 0012 0018 0012 0018 0014 0018 0012 0043 0014 0016 0014 0044 0012 0016 0014 0018 0014 0041 0012 0044 0012 0044 0012 0018 0014 0043 0012 06C3',
                  ),
                ),
                StaggeredGridTile.extent(
                  crossAxisCellCount: 1,
                  mainAxisExtent: 50,
                  child: createIconButton(
                    ' ',
                    '0000 006D 0022 0000 0155 00AE 0014 0018 0014 0016 0014 0016 0014 0018 0014 0016 0014 0016 0014 0018 0014 0016 0014 0043 0012 0044 0012 0043 0014 0041 0014 0043 0014 0043 0014 0041 0014 0043 0014 0016 0014 0043 0014 0043 0014 0016 0014 0018 0012 0018 0014 0016 0014 0016 0014 0043 0014 0016 0014 0018 0012 0043 0014 0043 0014 0041 0014 0043 0014 0043 0014 06C3',
                  ),
                ),
                StaggeredGridTile.extent(
                  crossAxisCellCount: 1,
                  mainAxisExtent: 50,
                  child: createIconButton(
                    ' ',
                    '0000 006D 0022 0000 0155 00AE 0014 0018 0014 0016 0014 0016 0014 0018 0014 0016 0014 0016 0014 0018 0014 0016 0014 0043 0014 0041 0014 0043 0014 0041 0014 0043 0014 0043 0014 0041 0014 0043 0014 0043 0014 0016 0014 0016 0014 0043 0014 0016 0014 0018 0012 0043 0014 0018 0012 0018 0014 0043 0012 0043 0014 0018 0012 0043 0014 0043 0014 0018 0012 0043 0012 06C3',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
