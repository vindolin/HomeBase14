import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '/widgets/shader_widget.dart';

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
        child: isBuffering ? const ShaderWidget('tv_static.frag') : Video(controller: controller),
      ),
    );
  }
}
