// ignore_for_file: avoid_public_notifier_properties
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'switch_devices.g.dart';
part 'switch_devices.freezed.dart';

@unfreezed
class ArmedSwitchDevice with _$ArmedSwitchDevice {
  factory ArmedSwitchDevice({
    required final String topicState,
    required final String topicSet,
    required final String onState,
    required final String offState,
    @Default(null) final String? state,
    @Default(false) bool transitioning,
    @Default(null) final String? stateKey,
  }) = _SwitchDevice;
}

IMap<String, ArmedSwitchDevice> switchDevices = IMap({
  'garage': ArmedSwitchDevice(
    topicState: 'garagedoor/state',
    topicSet: 'garagedoor/set',
    onState: 'open',
    offState: 'close',
  ),
  'burglar': ArmedSwitchDevice(
    topicState: 'home/burglar_alarm',
    topicSet: 'home/burglar_alarm',
    onState: '1',
    offState: '0',
  ),
  'camera': ArmedSwitchDevice(
    topicState: 'kittycam/privacy',
    topicSet: 'kittycam/privacy',
    onState: 'ON',
    offState: 'OFF',
  ),
  'pump': ArmedSwitchDevice(
    topicState: 'garden/cistern_pump/get',
    topicSet: 'garden/cistern_pump/set',
    onState: 'ON',
    offState: 'OFF',
  ),
  'silence': ArmedSwitchDevice(
    topicState: 'home/silence',
    topicSet: 'home/silence',
    onState: '1',
    offState: '0',
  ),
  'tv': ArmedSwitchDevice(
    topicState: 'zigbee2mqtt/plug/i002',
    topicSet: 'zigbee2mqtt/plug/i002/set',
    onState: 'ON',
    offState: 'OFF',
    stateKey: 'state',
  ),
});
// Don't forget to subscribe to the topics in the mqtt class! 😅

@riverpod
class SwitchDevices extends _$SwitchDevices {
  late Function publishCallback; // get's injected by the mqtt class

  @override
  IMap<String, ArmedSwitchDevice> build() {
    return switchDevices; // figure out why I can't use the map directly here...
  }

  void toggleState(key) {
    ArmedSwitchDevice switchDevice = state[key]!;
    switchDevice.transitioning = true;
    String newState = switchDevice.state == switchDevice.onState ? switchDevice.offState : switchDevice.onState;
    publishCallback(
      switchDevice.topicSet,
      newState,
    );
  }
}
