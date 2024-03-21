// ignore_for_file: avoid_public_notifier_properties

import 'package:freezed_annotation/freezed_annotation.dart';

// publish callback typedef
typedef F = void Function(String deviceId, String payload);

abstract class AbstractMqttDevice {
  // late List<DataMapping> dataMapping = [];
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
  void readValue(String key, dynamic value) {}

  // // TODOs find a better way to cast the values, mirror system?
  // void parseData(key, value) {
  //   try {
  //     final mapping = dataMapping.firstWhere((element) => element.item1 == key);
  //     print(mapping.item1);

  //     data[mapping.item2] = switch (mapping.type) {
  //       double _ => value.toDouble(),
  //       int _ => value.toInt(),
  //       String _ => value.toString(),
  //       bool _ => value.toString() == 'true',
  //       _ => value,
  //     };
  //   } catch (_) {}
  // }

  @protected
  void readValues(Map<String, dynamic> payload) {
    mqttPayload = payload;
    if (followUpMessage) {
      followUpMessage = false;
      return;
    }

    // unpack the payload, one level deep
    payload.forEach((key, value) {
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
