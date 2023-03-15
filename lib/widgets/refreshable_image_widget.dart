import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '/models/connectivity_provider.dart';

// import 'package:cached_network_image/cached_network_image.dart';
import 'image_fade_refresh.dart';

const refreshTimeMobile = 120;
const refreshTimeWifi = 10;

/// Image Container that refreshes the image when tapped or when a stream emits
///
class RefreshableImage extends ConsumerStatefulWidget {
  final String imageUrl;
  final StreamProvider? streamProvider; // refreshes the image when the stream emits
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final double? widthFactor;
  final bool autoRefresh;

  const RefreshableImage(
    this.imageUrl, {
    this.streamProvider,
    this.onTap,
    this.onDoubleTap,
    super.key,
    this.widthFactor,
    this.autoRefresh = true,
  });

  @override
  ConsumerState<RefreshableImage> createState() => _RefreshableImageState();
}

class _RefreshableImageState extends ConsumerState<RefreshableImage> {
  Timer? timer;

  void setTimer(int seconds) {
    timer?.cancel();
    timer = Timer.periodic(
      Duration(seconds: seconds),
      (Timer t) => setState(
        () {},
      ),
    );
  }

  @override
  void initState() {
    setTimer(refreshTimeMobile);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conn = ref.watch(connProvider);

    if (widget.autoRefresh) {
      if (conn == ConnectivityResult.mobile) {
        setTimer(refreshTimeMobile);
      } else {
        setTimer(refreshTimeWifi);
      }
    }

    if (widget.streamProvider != null) {
      ref.watch(widget.streamProvider!);
    }

    return InkWell(
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      onLongPress: () => setState(() {}), // just refresh image
      child: ImageFadeRefresh(
        '${widget.imageUrl}&${DateTime.now().millisecondsSinceEpoch}',
        widthFactor: widget.widthFactor,
      ),
    );
  }
}
