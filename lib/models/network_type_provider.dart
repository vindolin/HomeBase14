import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/utils.dart';
part 'network_type_provider.g.dart';

const networkTypeLocal = 'local';
const networkTypeMobile = 'mobile';

/// check if we are running on a local or mobile network
/// intentionally use a blocking socket because this is only called once at the beginning
bool inLocalNetworkB() {
  bool result = false;
  try {
    var socket = RawSynchronousSocket.connectSync(
      InternetAddress('192.168.178.113'),
      80,
    );
    socket.closeSync();
    // homebase14 responds, so we are on a local network
    result = true;
  } catch (error) {
    // nah, we're not in Kansas anymore
  }
  return result;
}

Future inLocalNetwork() async {
  bool result = false;
  await Socket.connect('192.168.178.113', 80, timeout: const Duration(seconds: 10)).then((socket) {
    socket.destroy();
    // homebase14 responds, so we are on a local network
    result = true;
  }).catchError((error) {
    // nah, we're not in Kansas anymore
  });

  return result;
}

@riverpod
class InitialNetworkType extends _$InitialNetworkType {
  @override
  String build() {
    return inLocalNetworkB() ? networkTypeLocal : networkTypeMobile;
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
