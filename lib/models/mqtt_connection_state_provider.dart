import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mqtt_client/mqtt_client.dart';

part 'mqtt_connection_state_provider.g.dart';

@riverpod
class MqttConnectionStateX extends _$MqttConnectionStateX {
  // The X at the end of the class name is to avoid a conflict with the MqttConnectionState enum
  @override
  MqttConnectionState build() {
    return MqttConnectionState.disconnected;
  }
}
