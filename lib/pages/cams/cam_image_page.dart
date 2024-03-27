import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
// import '/widgets/refreshable_image_widget.dart';

class CamImagePage extends StatelessWidget {
  final String camId;

  const CamImagePage({super.key, required this.camId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('cams.$camId')),
      ),
      body: RotatedBox(
        quarterTurns: MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 0,
        // replaced with MjpegCamImage
        // child: RefreshableImage(
        //   secrets.camData[camId]!['snapshotUrl']!,
        //   autoRefresh: true,
        // ),
        // child: MjpegCamImage(
        //   camSettings[camId]!['mjpegUrlHigh']!,
        // ),
        child: const Card(),
      ),
    );
  }
}
