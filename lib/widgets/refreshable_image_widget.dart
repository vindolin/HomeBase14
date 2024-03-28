import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:focus_detector/focus_detector.dart';

// import '/utils.dart' as d;
import '/models/app_settings_provider.dart';
import '/models/connectivity_provider.dart';
import 'image_fade_refresh.dart';

const refreshTimeMobile = 120;
const refreshTimeWifi = 10;

/// Image Container that refreshes the image when tapped or when a stream emits
/// The timer is halted when the widget is not visible
/// It uses my patched version of FocusDetector (faster reaction) to detect when the widget is visible.
class RefreshableImage extends ConsumerStatefulWidget {
  final String imageUrl;
  final StreamProvider? streamProvider; // refreshes the image when the stream emits
  final bool autoRefresh;

  const RefreshableImage(
    this.imageUrl, {
    this.streamProvider,
    super.key,
    this.autoRefresh = true,
  });

  @override
  ConsumerState<RefreshableImage> createState() => _RefreshableImageState();
}

class _RefreshableImageState extends ConsumerState<RefreshableImage> {
  bool _isVisible = false;
  Timer? _timer;
  int? _refreshRate;

  void startTimer() {
    // d.log('RefreshableImage: startTimer()');
    _timer?.cancel();

    _timer = Timer(
      Duration(seconds: _refreshRate!),
      () => setState(() {}),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
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
    _refreshRate = conn == ConnectivityResult.mobile ? camRefreshRateMobile : camRefreshRateWifi;

    // this timer triggers a build() which in turn starts the timer again
    // this way the timer can instantly react to changes of the refresh rate
    if (_isVisible) startTimer();

    // when the Instar camera detects motion, it sends a MQTT message, this causes an instant refresh
    if (widget.streamProvider != null) ref.watch(widget.streamProvider!);

    return FocusDetector(
      onVisibilityLost: () {
        _isVisible = false;
        _timer?.cancel();
      },
      onVisibilityGained: () {
        _isVisible = true;
        if (widget.autoRefresh) {
          startTimer();
        }
      },
      child: ImageFadeRefresh(
        '${widget.imageUrl}?${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
  }
}
