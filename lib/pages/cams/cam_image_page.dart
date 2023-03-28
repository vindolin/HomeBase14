import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/pages/cams/mjpeg_cam_image.dart';
// import '/widgets/refreshable_image_widget.dart';
import '/models/secrets.dart' as secrets;

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
        quarterTurns: 1,
        // replaced with MjpegCamImage
        // child: RefreshableImage(
        //   secrets.camData[camId]!['snapshotUrl']!,
        //   autoRefresh: true,
        // ),
        child: MjpegCamImage(
          secrets.camData[camId]!['mjpegUrlHigh']!,
        ),
      ),
    );
  }
}
