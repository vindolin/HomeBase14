import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

@riverpod
class Connectivity extends _$Connectivity {
  @override
  ConnectivityResult build() {
    return ConnectivityResult.none;
  }

  void setResult(ConnectivityResult result) => state = result;
}

// StreamController<ConnectivityResult> connectivityController = StreamController<ConnectivityResult>.broadcast();

// final connectivityProvider = StreamProvider<ConnectivityResult>(
//   (ref) async* {
//     await for (final result in connectivityController.stream) {
//       yield result;
//     }
//   },
// );
