import 'dart:convert';
// ignore_for_file: avoid_public_notifier_properties
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '/utils.dart';
import 'abstract_devices.dart';

part 'light_devices.g.dart';
part 'light_devices.freezed.dart';

@freezed
class LightDevice with _$LightDevice {
  const factory LightDevice({
    required String id,
    required String name,
    required String topicGet,
    required String topicSet,
    required String state,
  }) = _LightDevice;
}

IMap<String, LightDevice> lightDevices = IMap(
  const {
    'esstisch': LightDevice(
      id: 'esstisch',
      name: 'Esstisch',
      topicGet: 'stat/dose11/POWER',
      topicSet: 'cmnd/dose11/POWER',
      state: 'OFF',
    ),
    'kamin': LightDevice(
      id: 'kamin',
      name: 'Kamin (klein)',
      topicGet: 'stat/dose2/POWER',
      topicSet: 'cmnd/dose2/POWER',
      state: 'OFF',
    ),
    'keller': LightDevice(
      id: 'keller',
      name: 'Keller Decke',
      topicGet:
          'z2mSwitch/i012/get', // use the nodered bridge function to convert the zigbee2mqtt json payload to the tasmota state
      topicSet: 'zigbee2mqtt/switch/i012/set',
      state: 'OFF',
    ),
    'wohnzimmerdecke': LightDevice(
      id: 'wohnzimmerdecke',
      name: 'Wohnzimmer Decke',
      topicGet: 'z2mSwitch/i010/get',
      topicSet: 'zigbee2mqtt/switch/i010/set',
      state: 'OFF',
    ),
  },
);

@riverpod
class LightDevices extends _$LightDevices {
  late Function publishCallback; // get's injected by the mqtt class

  @override
  IMap<String, LightDevice> build() {
    return lightDevices; // figure out why I can't the map directly here...
  }

  void allOff() {
    state.forEach((key, value) {
      if (value.state == 'ON') {
        toggleState(key);
      }
    });
  }

  void toggleState(key) {
    LightDevice lightDevice = state[key]!;
    String newState = lightDevice.state == 'ON' ? 'OFF' : 'ON';
    publishCallback(
      lightDevice.topicSet,
      newState,
    );
  }
}

class SmartBulbDevice extends AbstractMqttDevice {
  String state = 'OFF';
  int brightness = 0;
  int? colorTemp;

  SmartBulbDevice(
    super.deviceId,
    super.deviceType,
    super.payload,
    super.publishCallback,
  );

  @override
  void readValue(String key, dynamic value) {
    switch (key) {
      case 'state':
        state = value;
        break;
      case 'brightness':
        brightness = value.toInt();
        break;
      case 'color_temp':
        colorTemp = value.toInt();
        break;
    }
    super.readValue(key, value);
  }

  void setState(String newState) {
    state = newState;
    publishState();
  }

  void toggleState() {
    state == 'ON' ? 'OFF' : 'ON';
    publishState();
  }

  @override
  void publishState() {
    super.publishState();
    String json = jsonEncode(
      {
        'state': state,
        'brightness': brightness.toInt(),
        ...colorTemp != null ? {'color_temp': colorTemp!.toInt()} : {} // some bulbs only support brightness
      },
    );
    log('publish> $deviceId $json');

    publishCallback(
      deviceId,
      json,
    );
  }
}

@Riverpod(keepAlive: true)
// @riverpod
class SmartBulbDevices extends _$SmartBulbDevices {
  late Function publishCallback; // get's injected by the mqtt class

  @override
  IMap<String, SmartBulbDevice> build() {
    return IMap();
  }

  void allOff() {
    state.forEach((key, value) {
      if (value.state == 'ON') {
        toggleState(key);
      }
    });
  }

  void toggleState(key) {
    SmartBulbDevice smartBulbDevice = state[key]!;
    String newState = smartBulbDevice.state == 'ON' ? 'OFF' : 'ON';
    smartBulbDevice.setState(newState);
  }
}

class HumiTempDevice extends AbstractMqttDevice {
  String state = 'OFF';
  double humidity = 0.0;
  double temperature = 0.0;

  HumiTempDevice(
    super.deviceId,
    super.deviceType,
    super.payload,
    super.publishCallback,
  );

  @override
  void readValue(String key, dynamic value) {
    switch (key) {
      case 'humidity':
        humidity = value.toDouble();
        break;
      case 'temperature':
        temperature = value.toDouble();
        break;
    }
    super.readValue(key, value);
  }
}

@Riverpod(keepAlive: true)
class HumiTempDevices extends _$HumiTempDevices {
  @override
  IMap<String, HumiTempDevice> build() {
    return IMap();
  }
}
