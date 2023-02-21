import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:video_player/video_player.dart';

import '/utils.dart';
import '/widgets/connection_bar_widget.dart';

class VideoPage extends ConsumerWidget {
  final VideoPlayerController _controller =
      VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
  VideoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      ;
    });
    log('VideoPage.build()');

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('device_names.videos')),
        actions: const [ConnectionBar()],
      ),
      body: VideoPlayer(_controller),
    );
  }
}
