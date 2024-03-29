import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/utils.dart';
part 'network_type_provider.g.dart';

const networkTypeLocal = 'local';
const networkTypeMobile = 'mobile';

@riverpod
class InitialNetworkType extends _$InitialNetworkType {
  @override
  String build() {
    final inL = inLocalNetwork();
    log('inLocalNetwork: $inL');
    return inL ? networkTypeLocal : networkTypeMobile;
  }
}

@Riverpod(keepAlive: true)
class NetworkType extends _$NetworkType {
  @override
  String build() {
    String initialNetworkType = ref.read(initialNetworkTypeProvider);
    log('initial: $initialNetworkType');
    return initialNetworkType;
  }

  void setNetworkType(String newState) {
    state = newState;
  }

  void toggleNetworkType() {
    state = state == networkTypeLocal ? networkTypeMobile : networkTypeLocal;
    log('networkTypeProvider: $state');
  }
}
