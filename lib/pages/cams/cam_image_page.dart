import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/widgets/refreshable_image_widget.dart';
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
      body: Center(
        child: RotatedBox(
          quarterTurns: 1,
          child: RefreshableImage(
            secrets.camData[camId]!['snapshotUrl']!,
          ),
        ),
      ),
    );
  }
}
