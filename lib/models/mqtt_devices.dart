// ignore_for_file: overridden_fields

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuple/tuple.dart';
import 'mqtt_providers.dart';
import '/utils.dart';
part 'mqtt_devices.g.dart';

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

// Map<String, dynamic> mqttDevices = {
//   'curtain': CurtainDevice,

// };
final mqttDeviceMap = {
  'curtain': SingleCurtainDevice,
  'door': DoorDevice,
  'thermostat': ThermostatDevice,
};

typedef F = void Function(String deviceId, String payload);

abstract class AbstractMqttDevice {
  late Mqtt mqtt;

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
          print(value);
          battery = value.toDouble();
          break;
        default:
          readValue(key, value);
      }
    });
  }

  void publishState() {
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
