import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/configuration.dart' as config;
import '/utils.dart';

part 'network_type_provider.g.dart';

const networkTypeLocal = 'local';
const networkTypeMobile = 'mobile';

String initialNetworkType = networkTypeMobile;

void setInitialNetworkType() async {
  initialNetworkType = await inLocalNetwork() ? networkTypeLocal : networkTypeMobile;
  log('initialNetworkType: $initialNetworkType');
}

Future inLocalNetwork() async {
  bool result = false;
  await Socket.connect(config.localServer, 80, timeout: const Duration(seconds: 3)).then((socket) {
    socket.destroy();
    // homebase14 responds, so we are on a local network
    result = true;
  }).catchError((error) {
    // nah, we're not in Kansas anymore
  });

  return result;
}

@Riverpod(keepAlive: true)
class NetworkType extends _$NetworkType {
  @override
  String build() {
    return initialNetworkType;
  }

  void setNetworkType(String newState) {
    state = newState;
  }

  void toggleNetworkType() {
    state = state == networkTypeLocal ? networkTypeMobile : networkTypeLocal;
  }
}
