import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/utils.dart';

part 'connectivity_provider.g.dart';

@riverpod
class Connectivity extends _$Connectivity {
  @override
  List<ConnectivityResult> build() {
    return List<ConnectivityResult>.empty(growable: true);
  }

  void setResult(List<ConnectivityResult> result) {
    log(result.toString());
    state = result;
  }
}
