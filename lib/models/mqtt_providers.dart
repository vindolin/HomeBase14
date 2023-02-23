import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nanoid/nanoid.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../utils.dart';
import 'mqtt_connection_data.dart';
import 'mqtt_devices.dart';

part 'mqtt_providers.g.dart';

const subscribeTopics = [
  'zigbee2mqtt/#',
  'stat/#',
  'garagedoor/state',
  'home/burglar_alarm',
  'garden/cistern_pump/get',
  'kittycam/privacy',
  'instar/10D1DC228582/status/alarm/triggered/object',
  'leech/sleep_',
];

final clientIdentifier = 'K${nanoid()}';

// used for the flashing message icon
StreamController<Map<String, dynamic>> messageController = StreamController<Map<String, dynamic>>.broadcast();

final messageProvider = StreamProvider<Map<String, dynamic>>((ref) async* {
  await for (final message in messageController.stream) {
    yield message;
  }
});

// used for vibration on door movement
StreamController<int> doorMovementController = StreamController<int>.broadcast();

final doorMovementProvider = StreamProvider<int>((ref) async* {
  await for (final message in doorMovementController.stream) {
    yield message;
  }
});

// used for refreshing the preview image
StreamController<int> doorAlarmController = StreamController<int>.broadcast();

final doorAlarmProvider = StreamProvider<int>((ref) async* {
  await for (final message in doorAlarmController.stream) {
    yield message;
  }
});

// wraps the whole mqtt client and and connection callbacks
@riverpod
class Mqtt extends _$Mqtt {
  late MqttServerClient client;
  late CurtainDevices curtainDevices;
  late DualCurtainDevices dualCurtainDevices;
  late DoorDevices doorDevices;
  late ThermostatDevices thermostatDevices;
  late LightDevices lightDevices;
  late SwitchDevices switchDevices;

  @override
  build() {
    log('building mqtt');
    lightDevices = ref.watch(lightDevicesProvider.notifier);
    switchDevices = ref.watch(switchDevicesProvider.notifier);
    curtainDevices = ref.watch(curtainDevicesProvider.notifier);
    dualCurtainDevices = ref.watch(dualCurtainDevicesProvider.notifier);
    doorDevices = ref.watch(doorDevicesProvider.notifier);
    thermostatDevices = ref.watch(thermostatDevicesProvider.notifier);

    ref.read(lightDevicesProvider.notifier).publishCallback = publish; // inject publish function
    ref.read(switchDevicesProvider.notifier).publishCallback = publishRetained; // inject publish function

    ref.onDispose(() {
      disconnect();
    });
  }

  FutureOr<MqttConnectionState> connect() async {
    log('connecting');

    final connectionData = ref.watch(mqttConnectionDataXProvider.notifier);

    client = MqttServerClient.withPort(
      connectionData.state.address,
      clientIdentifier,
      connectionData.state.port,
    );

    // mqtt.autoReconnect = true;

    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;

    ref.read(mqttConnectionStateXProvider.notifier).state = MqttConnectionState.connecting;

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    MqttClientConnectionStatus? mqttConnectionStatus =
        await client.connect(connectionData.state.username, connectionData.state.password).catchError(
      (error) {
        ref.read(mqttConnectionDataXProvider.notifier).setValid(false);
        ref.read(mqttConnectionStateXProvider.notifier).state = MqttConnectionState.faulted;
        return null;
      },
    );
    ref
        .read(mqttConnectionDataXProvider.notifier)
        .setValid(mqttConnectionStatus?.state == MqttConnectionState.connected);

    return mqttConnectionStatus?.state ?? MqttConnectionState.faulted;
    // .connected is set in the onConnected handler
  }

  // generic publish function
  void publish(String topic, String payload) {
    log('publishing $topic: $payload');
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  // generic publish function
  void publishRetained(String topic, String payload) {
    log('publishing $topic: $payload');
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!, retain: true);
  }

  // zigbee2mqtt publish function
  void publishZ2M(String deviceId, String payload) {
    publish('zigbee2mqtt/$deviceId/set', payload);
  }

  void disconnect() {
    log('disconnected');
    client.disconnect();
  }

  void onConnected() {
    log('connected');

    for (var topic in subscribeTopics) {
      client.subscribe(topic, MqttQos.atLeastOnce);
    }

    client.pongCallback = () {
      log('ping response client callback invoked');
    };

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (MqttReceivedMessage mqttReceivedMessage in messages) {
        final MqttPublishMessage message = mqttReceivedMessage.payload as MqttPublishMessage;
        final String payload = const Utf8Decoder().convert(message.payload.message);
        try {
          final payloadJson = jsonDecode(payload);

          // look for topics that look like our schema zigbee2mqtt/curtain/i001 for devices and add them to the mqttDevices
          RegExpMatch? match = RegExp(r'zigbee2mqtt/(?<type>\w+)/(?<id>i\d+)$').firstMatch(mqttReceivedMessage.topic);
          if (match != null) {
            String deviceType = match.namedGroup('type')!; // e.g. curtain
            String deviceId = '$deviceType/${match.namedGroup('id')!}'; // e.g. curtain/001

            if (deviceType == 'curtain' || deviceType == 'curtainU') {
              curtainDevices.state = {
                ...curtainDevices.state,
                deviceId: SingleCurtainDevice(deviceId, deviceType, payloadJson, publishZ2M),
              };
            } else if (deviceType == 'dualCurtain') {
              dualCurtainDevices.state = {
                ...dualCurtainDevices.state,
                deviceId: DualCurtainDevice(deviceId, deviceType, payloadJson, publishZ2M),
              };
            } else if (deviceType == 'door') {
              doorDevices.state = {
                ...doorDevices.state,
                deviceId: DoorDevice(deviceId, deviceType, payloadJson, publishZ2M),
              };
            } else if (deviceType == 'thermostat') {
              thermostatDevices.state = {
                ...thermostatDevices.state,
                deviceId: ThermostatDevice(deviceId, deviceType, payloadJson, publishZ2M),
              };
            }

            // send the message to the message stream
            messageController.sink.add({
              deviceId: {
                '_device_type': deviceType,
                ...payloadJson,
              },
            });
          } else if (mqttReceivedMessage.topic == 'instar/10D1DC228582/status/alarm/triggered/object') {
            doorMovementController.sink.add(
              int.parse(payloadJson['val']),
            );

            var objectValue = int.parse(payloadJson['val']);
            if (objectValue != 0) {
              doorAlarmController.sink.add(objectValue);
            }
          } else if (mqttReceivedMessage.topic == 'zigbee2mqtt/bridge/devices') {
            // we find the device name (description) in the zigbee2mqtt/bridge/devices message
            setDeviceNameMap(payloadJson);
          } else if (mqttReceivedMessage.topic == 'leech/sleep_') {
            print('sleep_');
          } else {
            print(mqttReceivedMessage.topic);
          }
        } on FormatException catch (e) {
          e;
        }

        // tasmota switches, plugs, bulps, etc
        lightDevices.state.forEach((key, value) {
          if (value.topicGet == mqttReceivedMessage.topic) {
            lightDevices.state = {
              ...lightDevices.state,
              key: value.copyWith(state: payload),
            };
          }
        });

        // armed switches like garage door
        switchDevices.state.forEach((key, value) {
          if (value.topicGet == mqttReceivedMessage.topic) {
            switchDevices.state = {
              ...switchDevices.state,
              key: value.copyWith(state: payload, transitioning: false),
            };
          }
        });
      }
    });

    ref.read(mqttConnectionStateXProvider.notifier).state = MqttConnectionState.connected;
  }

  void setDeviceNameMap(List devices) {
    final mqttDescriptions = ref.watch(deviceNamesProvider.notifier);

    Map<String, String> deviceNames = {}; // temporary map to hold the changed device names

    for (final device in devices) {
      try {
        // the description can be multiple lines and we only want the first line
        var ls = const LineSplitter();
        final description = ls.convert(device['description'])[0];

        // only update if the description has changed
        if (description != mqttDescriptions.state[device['friendly_name']]) {
          deviceNames[device['friendly_name']] = description;
        }
        log('${device['friendly_name']}: ${device['description']}');
      } catch (e) {
        //
      }
    }
    mqttDescriptions.state = {...mqttDescriptions.state, ...deviceNames};
  }

  void onDisconnected() {
    log('disconnected');
    ref.read(mqttConnectionStateXProvider.notifier).state = MqttConnectionState.disconnected;
  }
}

@riverpod
class MqttConnectionStateX extends _$MqttConnectionStateX {
  // The X at the end of the class name is to avoid a conflict with the MqttConnectionState enum
  @override
  MqttConnectionState build() {
    return MqttConnectionState.disconnected;
  }
}
