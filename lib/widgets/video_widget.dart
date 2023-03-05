import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

import '/models/secrets.dart' as secrets;

class CamWidget extends ConsumerStatefulWidget {
  final String camId;
  const CamWidget(this.camId, {super.key});

  @override
  ConsumerState<CamWidget> createState() => CamWidgetState();
}

class CamWidgetState extends ConsumerState<CamWidget> {
  late VlcPlayerController _videoPlayerController;

  Future<void> initializePlayer() async {}

  @override
  void initState() {
    super.initState();
    // print(secrets.camData[widget.camId]!);
    _videoPlayerController = VlcPlayerController.network(
      secrets.camData[widget.camId]!['videoUrl']!,
      options: VlcPlayerOptions(
        video: VlcVideoOptions(
          [
            // '--network-caching=1000',
            // '--live-caching=1000',
            '--clock-jitter=500',
            '--udp-caching=0',
            '--http-caching=0',
          ],
        ),
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
    await _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: RotatedBox(
        quarterTurns: 1,
        child: VlcPlayer(
          controller: _videoPlayerController,
          aspectRatio: 16 / 9,
          placeholder: const Center(child: CircularProgressIndicator()),
        ),
      ),
      onTap: () async {
        final isPlaying = await _videoPlayerController.isPlaying();
        if (isPlaying!) {
          await _videoPlayerController.pause();
        } else {
          await _videoPlayerController.play();
        }
      },
    );
  }
}
