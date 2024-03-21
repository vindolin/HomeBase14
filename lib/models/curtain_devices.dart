// ignore_for_file: avoid_public_notifier_properties
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'abstract_devices.dart';
part 'curtain_devices.g.dart';

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
