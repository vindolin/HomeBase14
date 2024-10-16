// DEPRECATED: use fullscreen_video_page.dart instead

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '/configuration.dart' as config;
import '/utils.dart';

class FullscreenVideo extends StatefulWidget {
  final Playlist videoUrls;
  const FullscreenVideo({super.key, required this.videoUrls});

  @override
  State<FullscreenVideo> createState() => FullscreenVideoState();
}

class FullscreenVideoState extends State<FullscreenVideo> {
  late final player = Player(
    configuration: const PlayerConfiguration(
      logLevel: config.mediakitPlayerLogLevl,
    ),
  );

  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    player.open(
      widget.videoUrls,
    );
    player.setPlaylistMode(PlaylistMode.loop);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: platformIsDesktop ? AppBar() : null,
      body: platformIsDesktop
          ? Video(
              controller: controller,
              controls: NoVideoControls,
              // TODO:low wrap in gesture detector to play next video
            )
          : RotatedBox(
              quarterTurns: MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 0,
              child: GestureDetector(
                child: Video(
                  controller: controller,
                  controls: NoVideoControls,
                ),
                // onTap: () => Navigator.pop(context),
                onTap: () {
                  // play next
                  player.next();
                },
              ),
            ),
    );
  }
}
