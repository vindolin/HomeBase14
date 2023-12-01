import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tuple/tuple.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '/utils.dart';

part 'mqtt_devices.g.dart';
part 'mqtt_devices.freezed.dart';

@immutable
class MqttMessage {
  final String topic;
  final String payload;

  const MqttMessage({
    required this.topic,
    required this.payload,
  });
}

@riverpod
class MqttMessages extends _$MqttMessages {
  late Function publishCallback; // get's injected by the mqtt class  // TODO can this be done another way?

  @override
  IMap<String, MqttMessage> build() {
    return IMap();
  }
}

/// A generic MqttMessages family provider (instead of filtering the MqttMessages with .select())
// keepAlive is required here because the members are spun up on demand by the mqtt class and no reference is kept to them
@Riverpod(keepAlive: true)
class MqttMessagesFam extends _$MqttMessagesFam {
  @override
  dynamic build(topic) {
    return null;
  }
}

@Riverpod(keepAlive: true)
class DeviceNames extends _$DeviceNames {
  // Mapping of device id to device name
  @override
  IMap<String, String> build() {
    return IMap();
  }
}

@riverpod
class Prusa extends _$Prusa {
  @override
  IMap<String, dynamic> build() {
    return IMap(const {
      'percent_done': 0,
      'extruder_actual': 0.0,
      'extruder_target': 0.0,
      'mins_remaining': 0,
      'file_name': '',
    });
  }
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

@riverpod
class SingleCurtainDevices extends _$SingleCurtainDevices {
  @override
  IMap<String, SingleCurtainDevice> build() {
    return IMap();
  }
}

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

IMap<String, LightDevice> lightDevices = IMap(const {
  'kamin': LightDevice(
    id: 'kamin',
    name: 'Kamin',
    topicGet: 'stat/dose2/POWER',
    topicSet: 'cmnd/dose2/POWER',
    state: 'OFF',
  ),
  'sofa': LightDevice(
    id: 'sofa',
    name: 'Sofa',
    topicGet: 'stat/dose3/POWER',
    topicSet: 'cmnd/dose3/POWER',
    state: 'OFF',
  ),
  'esstisch': LightDevice(
    id: 'esstisch',
    name: 'Esstisch',
    topicGet: 'stat/dose11/POWER',
    topicSet: 'cmnd/dose11/POWER',
    state: 'OFF',
  ),
});

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

final mqttDeviceMap = IMap(const {
  'curtain': SingleCurtainDevice,
  'door': DoorDevice,
  'thermostat': ThermostatDevice,
});

// publish callback typedef
typedef F = void Function(String deviceId, String payload);

abstract class AbstractMqttDevice {
  late List<Tuple3<String, String, dynamic>> dataMapping = [];
  late Map<String, dynamic> data = {};

  late String deviceId;
  String deviceType;

  Map<String, dynamic> mqttPayload = {};
  F publishCallback;
  int linkQuality = 0;
  int? battery;
  bool followUpMessage = false; // the first message after a publish always has the old values, ignore

  AbstractMqttDevice(
    this.deviceId,
    this.deviceType,
    Map<String, dynamic> payload,
    this.publishCallback,
  ) {
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

      data[mapping.item2] = switch (mapping.item3) {
        double _ => value.toDouble(),
        int _ => value.toInt(),
        String _ => value.toString(),
        bool _ => value.toString() == 'true',
        _ => value,
      };
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
          battery = value.toInt();
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

@riverpod
class DualCurtainDevices extends _$DualCurtainDevices {
  @override
  IMap<String, DualCurtainDevice> build() {
    return IMap();
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

@riverpod
class DoorDevices extends _$DoorDevices {
  @override
  IMap<String, DoorDevice> build() {
    return IMap();
  }
}

class ThermostatDevice extends AbstractMqttDevice {
  double localTemperature = 0;
  int currentHeatingSetpoint = 0;

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
        currentHeatingSetpoint = value;
        break;
    }
    super.readValue(key, value);
  }

  @override
  void publishState() {
    super.publishState();
    String json = jsonEncode(
      {
        'current_heating_setpoint': currentHeatingSetpoint.toInt(),
      },
    );
    log('publish> $deviceId $json');

    publishCallback(
      deviceId,
      json,
    );
  }
}

@riverpod
class ThermostatDevices extends _$ThermostatDevices {
  @override
  IMap<String, ThermostatDevice> build() {
    return IMap();
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
