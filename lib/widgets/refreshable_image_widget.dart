import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:focus_detector/focus_detector.dart';

import '/models/app_settings.dart';
import '/models/connectivity_provider.dart';
import 'image_fade_refresh.dart';

const refreshTimeMobile = 120;
const refreshTimeWifi = 10;

/// Image Container that refreshes the image when tapped or when a stream emits
/// Uses the
class RefreshableImage extends ConsumerStatefulWidget {
  final String imageUrl;
  final StreamProvider? streamProvider; // refreshes the image when the stream emits
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final bool autoRefresh;

  const RefreshableImage(
    this.imageUrl, {
    this.streamProvider,
    this.onTap,
    this.onDoubleTap,
    super.key,
    this.autoRefresh = true,
  });

  @override
  ConsumerState<RefreshableImage> createState() => _RefreshableImageState();
}

class _RefreshableImageState extends ConsumerState<RefreshableImage> {
  Timer? timer;
  int? refreshRate;

  void startTimer() {
    timer?.cancel();

    timer = Timer(
      Duration(seconds: refreshRate!),
      () => setState(() {}),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final camRefreshRateMobile = ref.watch(
      appSettingsProvider.select((appSettings) => appSettings.camRefreshRateMobile),
    );
    final camRefreshRateWifi = ref.watch(
      appSettingsProvider.select((appSettings) => appSettings.camRefreshRateWifi),
    );
    final conn = ref.watch(connectivityProvider);
    refreshRate = conn == ConnectivityResult.mobile ? camRefreshRateMobile : camRefreshRateWifi;

    // this timer triggers a build() which in turn starts the timer again
    // this way the timer can instantly react to changes of the refresh rate
    startTimer();

    // when the Instar camera detects motion, it sends a MQTT message, this causes an instant refresh
    if (widget.streamProvider != null) ref.watch(widget.streamProvider!);

    return FocusDetector(
      onVisibilityLost: () {
        timer?.cancel();
      },
      onVisibilityGained: () {
        if (widget.autoRefresh) {
          startTimer();
        }
      },
      child: InkWell(
        onTap: widget.onTap,
        onDoubleTap: widget.onDoubleTap,
        onLongPress: () => setState(() {}), // just refresh image
        child: ImageFadeRefresh(
          '${widget.imageUrl}&${DateTime.now().millisecondsSinceEpoch}',
        ),
      ),
    );
  }
}
