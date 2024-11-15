import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '/configuration.dart' as config;
import '/utils.dart';
import '/pages/cams/fullscreen_video_page.dart';

void portraitOrientation() {
  if (!platformIsDesktop) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}

void landscapeOrientation() {
  if (!platformIsDesktop) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}

class MediaKitVideoWidget extends StatefulWidget {
  final Playlist videoUrls;
  final bool muted;
  final dynamic controls;

  const MediaKitVideoWidget({
    super.key,
    required this.videoUrls,
    this.muted = false,
    this.controls,
  });
  @override
  MediaKitVideoWidgetState createState() => MediaKitVideoWidgetState();
}

class MediaKitVideoWidgetState extends State<MediaKitVideoWidget> {
  late final _player = Player(
    configuration: const PlayerConfiguration(
      logLevel: config.mediakitPlayerLogLevl,
    ),
  );
  late final controller = VideoController(_player);
  bool isBuffering = true;

  @override
  void initState() {
    super.initState();
    _player.open(widget.videoUrls);
    if (widget.muted) {
      _player.setVolume(0);
    }
    _player.stream.buffering.listen((buffering) {
      if (mounted) {
        setState(() {
          isBuffering = buffering;
        });
      }
    });
    _player.setPlaylistMode(PlaylistMode.loop);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        child: Video(
          controller: controller,
          onEnterFullscreen: () async {
            _player.setVolume(0.5);
            landscapeOrientation();
          },
          onExitFullscreen: () async {
            _player.setVolume(0.0);
            portraitOrientation();
          },
          controls: widget.controls,
        ),
        onTap: () {
          // play next video in playlist
          _player.next();
        },
        onDoubleTap: () {
          // open video in fullscreen mode
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullscreenVideo(
                videoUrls: widget.videoUrls,
              ),
            ),
          );
        },
      ),
    );
  }
}
