import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '/configuration.dart' as config;
import '/utils.dart';
import '/pages/cams/fullscreen_video_page.dart';

import '/util/logger.dart';

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
  final VoidCallback? onTap;

  const MediaKitVideoWidget({
    super.key,
    required this.videoUrls,
    this.muted = false,
    this.controls,
    this.onTap,
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
  Timer? _reloadTimer;

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
    _startReloadTimer();
  }

  void _startReloadTimer() {
    _reloadTimer?.cancel(); // Cancel any existing timer
    _reloadTimer = Timer.periodic(Duration(minutes: 10), (timer) {
      _reloadVideo();
    });
  }

  void _reloadVideo() {
    _player.stop();
    _player.open(widget.videoUrls);
    _player.play();
  }

  @override
  void dispose() {
    _reloadTimer?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        child: Video(
          filterQuality: FilterQuality.medium,
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
          if (widget.onTap == null) {
            logger.d('MediaKitVideoWidget onTap');
            // play next video in playlist
            _player.next();
          } else {
            widget.onTap!();
          }
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
