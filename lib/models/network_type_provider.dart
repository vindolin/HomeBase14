import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/configuration.dart' show defaultNetworkType;
import '/utils.dart';
part 'network_type_provider.g.dart';

const networkTypeLocal = 'local';
const networkTypeMobile = 'mobile';

@Riverpod(keepAlive: true)
class NetworkType extends _$NetworkType {
  @override
  String build() {
    return defaultNetworkType;
  }

  void setNetworkType(String newState) {
    state = newState;
  }

  void toggleNetworkType() {
    state = state == networkTypeLocal ? networkTypeMobile : networkTypeLocal;
    log('networkTypeProvider: $state');
  }
}
