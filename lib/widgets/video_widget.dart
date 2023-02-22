import 'package:flutter/material.dart';
import '/models/secrets.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class CamWidget extends StatefulWidget {
  const CamWidget({super.key});

  @override
  State<CamWidget> createState() => CamWidgetState();
}

class CamWidgetState extends State<CamWidget> {
  late VlcPlayerController _videoPlayerController;

  Future<void> initializePlayer() async {}

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VlcPlayerController.network(
      'rtsp://$doorCamUser:$doorCamPassword@$doorCamIp:554/livestream/11',
      hwAcc: HwAcc.auto,
      autoPlay: false,
      options: VlcPlayerOptions(
        video: VlcVideoOptions(
          [
            '--network-caching=10000',
            '--live-caching=10000',
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
      child: VlcPlayer(
        controller: _videoPlayerController,
        aspectRatio: 16 / 9,
        placeholder: const Center(child: CircularProgressIndicator()),
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
