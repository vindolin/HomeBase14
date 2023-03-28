import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:flutter/material.dart';
import '/widgets/shader_widget.dart';

class MjpegCamImage extends HookWidget {
  final String url;
  const MjpegCamImage(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    final isRunning = useState(true);
    return Mjpeg(
      timeout: const Duration(seconds: 600),
      isLive: isRunning.value,
      loading: (context) => const ShaderWidget('tv_static.frag'),
      error: (context, error, stack) {
        return Text(error.toString(), style: const TextStyle(color: Colors.red));
      },
      stream: url,
    );
  }
}
