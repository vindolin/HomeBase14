import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class FullscreenVideo extends StatefulWidget {
  final String videoUrl;
  const FullscreenVideo({super.key, required this.videoUrl});

  @override
  State<FullscreenVideo> createState() => FullscreenVideoState();
}

class FullscreenVideoState extends State<FullscreenVideo> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    player.open(Media(
      widget.videoUrl,
    ));
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
      appBar: Platform.isWindows ? AppBar() : null,
      body: Platform.isWindows
          ? Video(
              controller: controller,
              controls: NoVideoControls,
            )
          : RotatedBox(
              quarterTurns: MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 0,
              child: GestureDetector(
                child: Video(
                  controller: controller,
                  controls: NoVideoControls,
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
    );
  }
}
