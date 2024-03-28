import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/utils.dart';
part 'network_type_provider.g.dart';

const networkTypeLocal = 'local';
const networkTypeMobile = 'mobile';

const networkTypes = [networkTypeLocal, networkTypeMobile];

@Riverpod(keepAlive: true)
class NetworkType extends _$NetworkType {
  @override
  String build() {
    // return networkTypeLocal;
    return networkTypeMobile;
  }

  void toggleNetworkType() {
    state = state == networkTypeLocal ? networkTypeMobile : networkTypeLocal;
    log('networkTypeProvider: $state');
  }
}
