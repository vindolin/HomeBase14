import 'dart:async';
import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nanoid/nanoid.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart';

import '/utils.dart';
import 'mqtt_connection_state_provider.dart';
import 'app_settings.dart';
import 'mqtt_devices.dart';

part 'mqtt_providers.g.dart';

const subscribeTopics = [
  'zigbee2mqtt/#', // all the zigbee devices registered in zigbee2mqtt
  'stat/#', // all the tasmota devices
  'garagedoor/state', // an esp32 controlling the garage door
  'home/burglar_alarm', // node-red controlling the burglar alarm
  'garden/cistern_pump/get', // node-red controlling the cistern pump
  'kittycam/privacy', // node-red controlling the privacy mode of the cat cam
  'instar/10D1DC228582/status/alarm/triggered/object', // motion detection of the door cam
  'leech/#', // a node red flow controlling a python/mqtt daemon running on leech, setting the sleep mode to sleep or hibernate, or selects the display
  'greenhouse/temp_inside',
  'greenhouse/temp_outside',
  'greenhouse/humidity',
  'prusa/progress',
  'prusa/file',
  'prusa/temp',
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
  late Leech leech;
  late MqttMessages mqttMessages;

  @override
  build() {
    log('building mqtt');
    lightDevices = ref.watch(lightDevicesProvider.notifier);
    switchDevices = ref.watch(switchDevicesProvider.notifier);
    curtainDevices = ref.watch(curtainDevicesProvider.notifier);
    dualCurtainDevices = ref.watch(dualCurtainDevicesProvider.notifier);
    doorDevices = ref.watch(doorDevicesProvider.notifier);
    thermostatDevices = ref.watch(thermostatDevicesProvider.notifier);
    leech = ref.watch(leechProvider.notifier);

    mqttMessages = ref.watch(mqttMessagesProvider.notifier);

    // inject publish function
    lightDevices.publishCallback = publish;
    switchDevices.publishCallback = publishRetained;
    mqttMessages.publishCallback = publish;

    ref.onDispose(() {
      disconnect();
    });
  }

  FutureOr<mqtt.MqttConnectionState> connect() async {
    log('connecting');

    final connectionData = ref.watch(appSettingsProvider.notifier);

    client = MqttServerClient.withPort(
      connectionData.state.mqttAddress,
      clientIdentifier,
      connectionData.state.mqttPort,
    );

    client.autoReconnect = true;

    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;

    ref.read(mqttConnectionStateProvider.notifier).state = mqtt.MqttConnectionState.connecting;

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    mqtt.MqttClientConnectionStatus? mqttConnectionStatus =
        await client.connect(connectionData.state.mqttUsername, connectionData.state.mqttPassword).catchError(
      (error) {
        ref.read(appSettingsProvider.notifier).setValid(false);
        ref.read(mqttConnectionStateProvider.notifier).state = mqtt.MqttConnectionState.faulted;
        return null;
      },
    );
    ref.read(appSettingsProvider.notifier).setValid(mqttConnectionStatus?.state == mqtt.MqttConnectionState.connected);

    return mqttConnectionStatus?.state ?? mqtt.MqttConnectionState.faulted;
    // .connected is set in the onConnected handler
  }

  // generic publish function
  void publish(String topic, String payload, {bool retain = false}) {
    log('publishing $topic: $payload');
    final builder = mqtt.MqttClientPayloadBuilder();
    builder.addString(payload);
    client.publishMessage(topic, mqtt.MqttQos.atLeastOnce, builder.payload!, retain: retain);
  }

  // generic publish function with retain (for dependency injection)
  void publishRetained(String topic, String payload) {
    log('publishing $topic: $payload');
    final builder = mqtt.MqttClientPayloadBuilder();
    builder.addString(payload);
    client.publishMessage(topic, mqtt.MqttQos.atLeastOnce, builder.payload!, retain: true);
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
      client.subscribe(topic, mqtt.MqttQos.atLeastOnce);
    }

    client.pongCallback = () {
      log('ping response client callback invoked');
    };

    client.updates?.listen((List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>> messages) {
      // iterate over all new messages
      for (mqtt.MqttReceivedMessage mqttReceivedMessage in messages) {
        final mqtt.MqttPublishMessage message = mqttReceivedMessage.payload as mqtt.MqttPublishMessage;
        final String payload = const Utf8Decoder().convert(message.payload.message);
        dynamic payloadDecoded;
        // try to parse the payload as json
        try {
          payloadDecoded = jsonDecode(payload);
          // if the payload is not json, it's probably a string
        } on FormatException catch (_) {
          payloadDecoded = payload;
        }
        mqttMessages.state = {
          ...mqttMessages.state,
          mqttReceivedMessage.topic: MqttMessage(topic: mqttReceivedMessage.topic, payload: payload)
        };

        // look for topics that look like our schema zigbee2mqtt/curtain/i001 for devices and add them to the mqttDevices
        RegExpMatch? match = RegExp(r'zigbee2mqtt/(?<type>\w+)/(?<id>i\d+)$').firstMatch(mqttReceivedMessage.topic);
        if (match != null) {
          // it's a zigbee2mqtt message
          String deviceType = match.namedGroup('type')!; // e.g. curtain
          String deviceId = '$deviceType/${match.namedGroup('id')!}'; // e.g. curtain/001

          if (deviceType == 'curtain' || deviceType == 'curtainU') {
            // underwall curtain switch
            curtainDevices.state = {
              ...curtainDevices.state,
              deviceId: SingleCurtainDevice(deviceId, deviceType, payloadDecoded, publishZ2M),
            };
          } else if (deviceType == 'dualCurtain') {
            // dual curtain switch
            dualCurtainDevices.state = {
              ...dualCurtainDevices.state,
              deviceId: DualCurtainDevice(deviceId, deviceType, payloadDecoded, publishZ2M),
            };
          } else if (deviceType == 'door') {
            // door contact
            doorDevices.state = {
              ...doorDevices.state,
              deviceId: DoorDevice(deviceId, deviceType, payloadDecoded, publishZ2M),
            };
          } else if (deviceType == 'thermostat') {
            // thermostat
            thermostatDevices.state = {
              ...thermostatDevices.state,
              deviceId: ThermostatDevice(deviceId, deviceType, payloadDecoded, publishZ2M),
            };
          }

          // send the message to the message stream
          messageController.sink.add({
            deviceId: {
              '_device_type': deviceType,
              ...payloadDecoded,
            },
          });
        } else if (mqttReceivedMessage.topic == 'instar/10D1DC228582/status/alarm/triggered/object') {
          doorMovementController.sink.add(
            int.parse(payloadDecoded['val']),
          );

          var objectValue = int.parse(payloadDecoded['val']);
          if (objectValue != 0) {
            doorAlarmController.sink.add(objectValue);
          }
        } else if (mqttReceivedMessage.topic == 'zigbee2mqtt/bridge/devices') {
          // we find the device name (description) in the zigbee2mqtt/bridge/devices message
          setDeviceNameMap(payloadDecoded);
        } else {
          print(mqttReceivedMessage.topic);
        }

        // tasmota switches, plugs, bulps, etc
        lightDevices.state.forEach((key, lightDevice) {
          if (lightDevice.topicGet == mqttReceivedMessage.topic) {
            lightDevices.state = {
              ...lightDevices.state,
              key: lightDevice.copyWith(state: payload),
            };
          }
        });

        // armed switches like garage door
        switchDevices.state.forEach((key, switchDevice) {
          if (switchDevice.topicGet == mqttReceivedMessage.topic) {
            dynamic devicePayload = payload;

            // if the device has a stateKey, we need to parse the json and set the payload to that key's value (e.g. zigbee2mqtt plugs)
            if (switchDevice.stateKey != null) {
              payloadDecoded = jsonDecode(payload);
              devicePayload = payloadDecoded[switchDevice.stateKey!];
            }
            switchDevices.state = {
              ...switchDevices.state,
              key: switchDevice.copyWith(state: devicePayload, transitioning: false),
            };
          }
        });
      }
    });

    ref.read(mqttConnectionStateProvider.notifier).state = mqtt.MqttConnectionState.connected;
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
      } catch (_) {
        //
      }
    }
    mqttDescriptions.state = {...mqttDescriptions.state, ...deviceNames};
  }

  void onDisconnected() {
    log('disconnected');
    ref.read(mqttConnectionStateProvider.notifier).state = mqtt.MqttConnectionState.disconnected;
  }
}
