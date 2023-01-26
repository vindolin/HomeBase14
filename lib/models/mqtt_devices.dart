import 'dart:convert';
import 'dart:developer' as d;
import 'package:flutter/material.dart';

import 'mqtt_providers.dart';

typedef F = void Function(String deviceId, String payload);

abstract class AbstractMqttDevice {
  late Mqtt mqtt;

  late String deviceId;
  String deviceType;
  Map<String, dynamic> data = {};
  F publishCallback;
  int linkQuality = 0;
  int? battery;
  bool followUpMessage = false; // the first message after a publish always has the old values, ignore

  AbstractMqttDevice(this.deviceId, this.deviceType, Map<String, dynamic> payload, this.publishCallback) {
    readValues(payload);
  }

  @protected
  void readValue(String key, dynamic value) {
    d.log('$key> $value');
  }

  void readValues(Map<String, dynamic> payload) {
    if (followUpMessage) {
      followUpMessage = false;
      return;
    }

    payload.forEach((key, value) {
      switch (key) {
        case 'linkquality':
          linkQuality = value;
          break;
        case 'battery':
          battery = value;
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

class CurtainDevice extends AbstractMqttDevice {
  double position = 0.0;

  CurtainDevice(
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
      default:
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
    d.log('publish> $deviceId $json');

    publishCallback(
      deviceId,
      json,
    );
  }
}

class DoorDevice extends AbstractMqttDevice {
  double position = 0.0;

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
      default:
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
    d.log('publish> $deviceId $json');

    publishCallback(
      deviceId,
      json,
    );
  }
}

class ThermostatDevice extends AbstractMqttDevice {
  double? localTemperature;
  double? currentHeatingSetpoint;

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
      default:
    }
    super.readValue(key, value);
  }

  @override
  void publishState() {
    super.publishState();
    String json = jsonEncode(
      {
        'local_temperature': localTemperature?.toDouble(),
        'current_heating_setpoint': currentHeatingSetpoint?.toDouble(),
      },
    );
    d.log('publish> $deviceId $json');

    publishCallback(
      deviceId,
      json,
    );
  }
}
