import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '/configuration.dart' as config;
import '/utils.dart';

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
  bool muted = true;

  @override
  void initState() {
    super.initState();
    player.open(
      widget.videoUrls,
    );
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            child: platformIsDesktop
                ? CallbackShortcuts(
                    // TODO: how can this be done globally?
                    bindings: <ShortcutActivator, VoidCallback>{
                      const SingleActivator(LogicalKeyboardKey.escape): () {
                        Navigator.pop(context);
                      },
                    },
                    child: Focus(
                      autofocus: true,
                      child: buildVideoWidget(),
                    ),
                  )
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
    );
  }
}
