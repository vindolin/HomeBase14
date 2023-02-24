// ignore_for_file: overridden_fields

import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tuple/tuple.dart';

import '/utils.dart';

part 'mqtt_devices.g.dart';
part 'mqtt_devices.freezed.dart';

@freezed
class SimpleMqttMessage with _$SimpleMqttMessage {
  const factory SimpleMqttMessage({
    required String topic,
    required String payload,
  }) = _SimpleMqttMessage;
}

@riverpod
class SimpleMqttMessages extends _$SimpleMqttMessages {
  late Function publishCallback; // get's injected by the mqtt class
  @override
  Map<String, SimpleMqttMessage> build() {
    return {};
  }
}

@riverpod
class Leech extends _$Leech {
  late Function publishCallback; // get's injected by the mqtt class

  @override
  Map<String, String> build() {
    return {'sleep_state': 'none'};
  }
}

@riverpod
class DoorDevices extends _$DoorDevices {
  @override
  Map<String, DoorDevice> build() {
    return {};
  }
}

@riverpod
class ThermostatDevices extends _$ThermostatDevices {
  @override
  Map<String, ThermostatDevice> build() {
    return {};
  }
}

@riverpod
class CurtainDevices extends _$CurtainDevices {
  @override
  Map<String, SingleCurtainDevice> build() {
    return {};
  }
}

@riverpod
class DualCurtainDevices extends _$DualCurtainDevices {
  @override
  Map<String, DualCurtainDevice> build() {
    return {};
  }
}

@riverpod
class DeviceNames extends _$DeviceNames {
  // Mapping of device id to device name
  @override
  Map<String, String> build() {
    return {};
  }
}

@unfreezed
class ArmedSwitchDevice with _$ArmedSwitchDevice {
  factory ArmedSwitchDevice({
    required final String topicGet,
    required final String topicSet,
    required final String onState,
    required final String offState,
    @Default(null) final String? state,
    @Default(false) bool transitioning,
  }) = _SwitchDevice;
}

Map<String, ArmedSwitchDevice> switchDevices = {
  'garage': ArmedSwitchDevice(
    topicGet: 'garagedoor/state',
    topicSet: 'garagedoor/set',
    onState: 'open',
    offState: 'close',
  ),
  'burglar': ArmedSwitchDevice(
    topicGet: 'home/burglar_alarm',
    topicSet: 'home/burglar_alarm',
    onState: '1',
    offState: '0',
  ),
  'camera': ArmedSwitchDevice(
    topicGet: 'kittycam/privacy',
    topicSet: 'kittycam/privacy',
    onState: 'ON',
    offState: 'OFF',
  ),
  'pump': ArmedSwitchDevice(
    topicGet: 'garden/cistern_pump/get',
    topicSet: 'garden/cistern_pump/set',
    onState: '1',
    offState: '0',
  ),
  'tv': ArmedSwitchDevice(
    topicGet: 'zigbee2mqtt/plug/i002',
    topicSet: 'zigbee2mqtt/plug/i002/set',
    onState: '1',
    offState: '0',
  ),
};

@riverpod
class SwitchDevices extends _$SwitchDevices {
  late Function publishCallback; // get's injected by the mqtt class

  @override
  Map<String, ArmedSwitchDevice> build() {
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

Map<String, LightDevice> lightDevices = {
  'kamin': const LightDevice(
    id: 'kamin',
    name: 'Kamin',
    topicGet: 'stat/dose2/POWER',
    topicSet: 'cmnd/dose2/POWER',
    state: 'OFF',
  ),
  'sofa': const LightDevice(
    id: 'sofa',
    name: 'Sofa',
    topicGet: 'stat/dose3/POWER',
    topicSet: 'cmnd/dose3/POWER',
    state: 'OFF',
  ),
  'esstisch': const LightDevice(
    id: 'esstisch',
    name: 'Esstisch',
    topicGet: 'stat/dose4/POWER',
    topicSet: 'cmnd/dose4/POWER',
    state: 'OFF',
  ),
};

@riverpod
class LightDevices extends _$LightDevices {
  late Function publishCallback; // get's injected by the mqtt class

  @override
  Map<String, LightDevice> build() {
    return lightDevices; // figure out why I can't the map directly here...
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

final mqttDeviceMap = {
  'curtain': SingleCurtainDevice,
  'door': DoorDevice,
  'thermostat': ThermostatDevice,
};

typedef F = void Function(String deviceId, String payload);

abstract class AbstractMqttDevice {
  late List<Tuple3<String, String, dynamic>> dataMapping = [];
  late Map<String, dynamic> data = {};

  late String deviceId;
  String deviceType;
  Map<String, dynamic> mqttPayload = {};
  F publishCallback;
  int linkQuality = 0;
  double? battery;
  bool followUpMessage = false; // the first message after a publish always has the old values, ignore

  AbstractMqttDevice(this.deviceId, this.deviceType, Map<String, dynamic> payload, this.publishCallback) {
    readValues(payload);
  }

  @protected
  void readValue(String key, dynamic value) {
    // log('$key> $value');
  }

  // TODOs find a better way to cast the values, mirror system?
  void parseData(key, value) {
    try {
      final mapping = dataMapping.firstWhere((element) => element.item1 == key);
      if (mapping.item3 == double) {
        data[mapping.item2] = value.toDouble();
      } else if (mapping.item3 == int) {
        data[mapping.item2] = value.toInt();
      } else if (mapping.item3 == String) {
        data[mapping.item2] = value.toString();
      } else if (mapping.item3 == bool) {
        data[mapping.item2] = value.toString() == 'true';
      } else {
        data[mapping.item2] = value;
      }
    } catch (_) {}
  }

  @protected
  void readValues(Map<String, dynamic> payload) {
    mqttPayload = payload;
    // print(followUpMessage);
    if (followUpMessage) {
      followUpMessage = false;
      return;
    }

    payload.forEach((key, value) {
      // parseData(key, value);

      switch (key) {
        case 'linkquality':
          linkQuality = value;
          break;
        case 'battery':
          battery = value.toDouble();
          break;
        default:
          readValue(key, value);
      }
    });
  }

  void publishState() {
    // print('followUpMessage');
    followUpMessage = true;
  }
}

abstract class CurtainDevice extends AbstractMqttDevice {
  bool motorReversal = false;

  CurtainDevice(
    super.deviceId,
    super.deviceType,
    super.payload,
    super.publishCallback,
  );
}

class SingleCurtainDevice extends CurtainDevice {
  double position = 0.0;

  // @override
  // final dataMapping = [
  //   const Tuple3('position', 'position', double),
  // ];

  SingleCurtainDevice(
    super.deviceId,
    super.deviceType,
    super.payload,
    super.publishCallback,
  );

  @override
  void readValue(String key, dynamic value) {
    switch (key) {
      case 'position':
        position = value.toDouble();
        break;
      case 'motor_reversal':
        motorReversal = value == 'ON';
        break;
    }
    super.readValue(key, value);
  }

  @override
  void publishState() {
    super.publishState();
    String json = jsonEncode(
      {
        'position': position.toInt(),
      },
    );
    log('publish> $deviceId $json');

    publishCallback(
      deviceId,
      json,
    );
  }

  void open() {
    publishCallback(deviceId, jsonEncode({'state': 'OPEN'}));
  }

  void close() {
    publishCallback(deviceId, jsonEncode({'state': 'CLOSE'}));
  }

  void stop() {
    publishCallback(deviceId, jsonEncode({'state': 'STOP'}));
  }
}

class DualCurtainDevice extends CurtainDevice {
  double positionLeft = 0.0;
  double positionRight = 0.0;

  // @override
  // final dataMapping = [
  //   const Tuple3('position_left', 'positionLeft', double),
  //   const Tuple3('position_right', 'positionRight', double),
  // ];

  DualCurtainDevice(
    super.deviceId,
    super.deviceType,
    super.payload,
    super.publishCallback,
  );

  @override
  void readValue(String key, dynamic value) {
    switch (key) {
      case 'position_left':
        positionLeft = value.toDouble();
        break;
      case 'position_right':
        positionRight = value.toDouble();
        break;
      case 'motor_reversal':
        motorReversal = value == 'ON';
        break;
    }
    super.readValue(key, value);
  }

  @override
  void publishState() {
    super.publishState();
    String json = jsonEncode(
      {
        'position_left': positionLeft.toInt(),
        'position_right': positionRight.toInt(),
      },
    );

    publishCallback(
      deviceId,
      json,
    );
  }

  void openLeft() {
    publishCallback(deviceId, jsonEncode({'state_left': 'OPEN'}));
  }

  void closeLeft() {
    publishCallback(deviceId, jsonEncode({'state_left': 'CLOSE'}));
  }

  void stopLeft() {
    publishCallback(deviceId, jsonEncode({'state_left': 'STOP'}));
  }

  void openRight() {
    publishCallback(deviceId, jsonEncode({'state_right': 'OPEN'}));
  }

  void closeRight() {
    publishCallback(deviceId, jsonEncode({'state_right': 'CLOSE'}));
  }

  void stopRight() {
    publishCallback(deviceId, jsonEncode({'state_right': 'STOP'}));
  }
}

class DoorDevice extends AbstractMqttDevice {
  double position = 0.0;

  // @override
  // final dataMapping = [
  //   const Tuple3('position', 'position', double),
  // ];

  DoorDevice(
    super.deviceId,
    super.deviceType,
    super.payload,
    super.publishCallback,
  );

  @override
  void readValue(String key, dynamic value) {
    switch (key) {
      case 'position':
        position = value.toDouble();
        break;
    }
    super.readValue(key, value);
  }

  @override
  void publishState() {
    super.publishState();
    String json = jsonEncode(
      {
        'position': position.toInt(),
      },
    );
    log('publish> $deviceId $json');

    publishCallback(
      deviceId,
      json,
    );
  }
}

class ThermostatDevice extends AbstractMqttDevice {
  double localTemperature = 0;
  double currentHeatingSetpoint = 0;

  // @override
  // final dataMapping = [
  //   const Tuple3('local_temperature', 'localTemperature', double),
  //   const Tuple3('current_heating_setpoint', 'currentHeatingSetpoint', double),
  // ];

  ThermostatDevice(
    super.deviceId,
    super.deviceType,
    super.payload,
    super.publishCallback,
  );

  @override
  void readValue(String key, dynamic value) {
    switch (key) {
      case 'local_temperature':
        localTemperature = value.toDouble();
        break;
      case 'current_heating_setpoint':
        currentHeatingSetpoint = value.toDouble();
        break;
    }
    super.readValue(key, value);
  }

  @override
  void publishState() {
    super.publishState();
    String json = jsonEncode(
      {
        'local_temperature': localTemperature.toDouble(),
        'current_heating_setpoint': currentHeatingSetpoint.toDouble(),
      },
    );
    log('publish> $deviceId $json');

    publishCallback(
      deviceId,
      json,
    );
  }
}
