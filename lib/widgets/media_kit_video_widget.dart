import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '/pages/cams/fullscreen_video_page.dart';
import '/widgets/shader_widget.dart';

void portaitOrientation() {
  if (Platform.isAndroid) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}

void landscapeOrientation() {
  if (Platform.isAndroid) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}

class MediaKitVideoWidget extends StatefulWidget {
  final String videoUrl;
  final bool muted;

  const MediaKitVideoWidget({super.key, required this.videoUrl, this.muted = false});
  @override
  MediaKitVideoWidgetState createState() => MediaKitVideoWidgetState();
}

class MediaKitVideoWidgetState extends State<MediaKitVideoWidget> {
  late final player = Player();
  late final controller = VideoController(player);
  bool isBuffering = true;

  @override
  void initState() {
    super.initState();
    player.open(Media(widget.videoUrl));
    if (widget.muted) {
      player.setVolume(0);
    }
    player.stream.buffering.listen((buffering) {
      if (mounted) {
        setState(() {
          isBuffering = buffering;
        });
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.width * 9.0 / 16.0,
        // Use [Video] widget to display video output.
        child: isBuffering
            ? const ShaderWidget('tv_static.frag')
            : GestureDetector(
                child: Video(
                  controller: controller,
                  onEnterFullscreen: () async {
                    player.setVolume(0.5);
                    landscapeOrientation();
                  },
                  onExitFullscreen: () async {
                    player.setVolume(0.0);
                    portaitOrientation();
                  },
                  controls: NoVideoControls,
                ),
                onTap: () {
                  // set video to fullscreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullscreenVideo(videoUrl: widget.videoUrl),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
