// ignore_for_file: avoid_public_notifier_properties
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '/utils.dart';
import 'abstract_devices.dart';

export 'curtain_devices.dart';
export 'switch_devices.dart';
export 'light_devices.dart';

part 'mqtt_devices.g.dart';

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

  void set(dynamic payload) {
    state = payload;
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

typedef DataMapping = ({
  dynamic item1,
  dynamic item2,
  dynamic type,
});

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
