import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt5_client/mqtt5_client.dart' as mqtt;

typedef MqttConnectionState = mqtt.MqttConnectionState;

// we need the X suffix to shadow the class name
class MqttConnectionStateX extends _$MqttConnectionState {
  @override
  mqtt.MqttConnectionState build() {
    return mqtt.MqttConnectionState.disconnected;
  }
}

final mqttConnectionStateProvider = AutoDisposeNotifierProvider<MqttConnectionStateX, mqtt.MqttConnectionState>(
  MqttConnectionStateX.new,
  name: r'mqttConnectionStateProvider',
);
typedef MqttConnectionStateRef = Ref<mqtt.MqttConnectionState>;

abstract class _$MqttConnectionState extends AutoDisposeNotifier<mqtt.MqttConnectionState> {
  @override
  mqtt.MqttConnectionState build();
}


// TODOs file a bug report:
// Code generation fails when the return value type is imported with the "as" keyword.
