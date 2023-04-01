import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '/widgets/video_widget.dart';
import 'webview_door_video.dart';

class CamVideoPage extends ConsumerWidget {
  final String camId;

  const CamVideoPage({super.key, required this.camId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('cams.$camId')),
      ),
      body: Center(
        child: camId == 'door'
            ? const RotatedBox(
                quarterTurns: 1,
                child: DoorCamVideo(),
              )
            : const Text('...'), //CamWidget(camId),
      ),
    );
  }
}
