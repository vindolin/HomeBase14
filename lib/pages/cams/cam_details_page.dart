import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/widgets/video_widget.dart';

class CamDetailPage extends ConsumerWidget {
  final String camId;

  const CamDetailPage({super.key, required this.camId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('cams.$camId')),
      ),
      body: Center(child: CamWidget(camId)),
    );
  }
}
