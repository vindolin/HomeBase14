import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '/utils.dart';
import '/shortcut_wrapper.dart';
import '/widgets/shader_widget.dart';
import '/configuration.dart' as config;

class FullscreenCamVideo extends StatefulWidget {
  final Playlist videoUrls;
  const FullscreenCamVideo({super.key, required this.videoUrls});

  @override
  State<FullscreenCamVideo> createState() => FullscreenCamVideoState();
}

class FullscreenCamVideoState extends State<FullscreenCamVideo> {
  final player = Player(
    configuration: const PlayerConfiguration(
      logLevel: config.mediakitPlayerLogLevl,
    ),
  );
  late final controller = VideoController(player);
  bool muted = true; // start video muted
  bool isBuffering = true; // used to show tv static when buffering

  @override
  void initState() {
    super.initState();
    player.open(
      widget.videoUrls,
    );
    player.stream.buffering.listen((buffering) {
      if (mounted) {
        setState(() {
          isBuffering = buffering;
        });
      }
    });
    player.setPlaylistMode(PlaylistMode.loop);
    player.setVolume(0.0);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  // setVolume method
  void toggleMuted() {
    setState(() {
      muted = !muted;
    });
    player.setVolume(muted ? 0.0 : 100.0);
  }

  Widget buildVideoWidget() {
    return Stack(
      children: [
        Video(
          controller: controller,
          controls: NoVideoControls,
        ),
        Positioned(
          top: 5,
          right: 5,
          child: IconButton(
            icon: Icon(
              muted ? Icons.volume_off : Icons.volume_up,
              color: muted ? Colors.red : Colors.green,
            ),
            onPressed: toggleMuted,
          ),
        ),
        if (isBuffering)
          Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Opacity(
                opacity: 0.7,
                child: ShaderWidget('tv_static.frag'),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return shortcutWrapper(
      context,
      Scaffold(
        body: Stack(
          children: [
            GestureDetector(
              child: platformIsDesktop
                  ? buildVideoWidget()
                  : RotatedBox(
                      quarterTurns: MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 0,
                      child: buildVideoWidget(),
                    ),
              onTap: () {
                player.next();
              },
              onDoubleTap: () => toggleMuted(),
            ),
          ],
        ),
      ),
    );
  }
}
