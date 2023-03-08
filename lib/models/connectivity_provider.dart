import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StreamController<ConnectivityResult> connectivityController = StreamController<ConnectivityResult>.broadcast();

final connectivityProvider = StreamProvider<ConnectivityResult>(
  (ref) async* {
    await for (final result in connectivityController.stream) {
      yield result;
    }
  },
);
