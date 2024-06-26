// ignore_for_file: dead_code, avoid_public_notifier_properties, avoid_manual_providers_as_generated_provider_dependency, protected_notifier_properties

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt5_client/mqtt5_client.dart' as mqtt;
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:nanoid/nanoid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/models/app_settings_provider.dart';
import '/models/encrypted_key.dart';
import '/models/encryption.dart' as encryption;
import '/utils.dart';
import 'generic_providers.dart';
import 'mqtt_connection_state_provider.dart';
import 'mqtt_devices.dart';

part 'mqtt_providers.g.dart';

const subscribeTopics = [
  'garagedoor/state', // an esp32 controlling the garage door
  'garden/cistern_pump/get', // node-red controlling the cistern pump
  'greenhouse/humidity',
  'greenhouse/temp_inside',
  'greenhouse/temp_outside',
  'home/#', // node-red controlling the burglar alarm
  'incubator/+',
  'instar/10D1DC228582/status/alarm/triggered/object', // motion detection of the door cam
  'irrigator/+',
  'kittycam/privacy', // node-red controlling the privacy mode of the cat cam
  'leech/#', // a node red flow controlling a python/mqtt daemon running on leech, setting the sleep mode to sleep or hibernate, or selects the display
  'meep/#', // test device
  'prusa/file',
  'prusa/progress',
  'prusa/temp',
  'sma/b3b461c9/total_w',
  'sma/tripower/totw',
  'stat/#', // all the tasmota devices
  'tulpe/spray_last',
  'z2mSwitch/#',
  'zigbee2mqtt/#', // all the zigbee devices registered in zigbee2mqtt
];

// generate a random mqtt client identifier
final clientIdentifier = 'HB14${nanoid()}';

typedef Message = ({String topic, String payload});

// used for the flashing message icon
StreamController<Message> messageController = StreamController<Message>.broadcast();
final messageProvider = StreamProvider<Message>((ref) async* {
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

@Riverpod(keepAlive: true)
class LastMessageTime extends _$LastMessageTime {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void update() {
    state = DateTime.now();
  }
}

// wraps the whole mqtt client and connection callbacks
@riverpod
class Mqtt extends _$Mqtt {
  // TODO find a way to fix all these linter warnings,
  late MqttServerClient client;
  late SingleCurtainDevices curtainDevices;
  late DualCurtainDevices dualCurtainDevices;
  late DoorDevices doorDevices;
  late ThermostatDevices thermostatDevices;
  late HumiTempDevices humiTempDevices;
  late LightDevices lightDevices;
  late SmartBulbDevices ikeaBulbDevices;
  late SwitchDevices switchDevices;
  late MqttMessages mqttMessages;
  late Prusa prusa;
  late LastMessageTime lastMessageTime;
  late Counter counter;
  late DeviceNames mqttDescriptions;

  @override
  build() {
    log('building mqtt');
    lastMessageTime = ref.watch(lastMessageTimeProvider.notifier);
    counter = ref.watch(counterProvider('mqtt_message').notifier);
    mqttDescriptions = ref.watch(deviceNamesProvider.notifier);

    lightDevices = ref.watch(lightDevicesProvider.notifier);
    ikeaBulbDevices = ref.watch(smartBulbDevicesProvider.notifier);
    switchDevices = ref.watch(switchDevicesProvider.notifier);
    curtainDevices = ref.watch(singleCurtainDevicesProvider.notifier);
    dualCurtainDevices = ref.watch(dualCurtainDevicesProvider.notifier);
    doorDevices = ref.watch(doorDevicesProvider.notifier);
    thermostatDevices = ref.watch(thermostatDevicesProvider.notifier);
    humiTempDevices = ref.watch(humiTempDevicesProvider.notifier);

    prusa = ref.watch(prusaProvider.notifier);

    mqttMessages = ref.watch(mqttMessagesProvider.notifier);

    // inject publish function //TODOs find a better way
    lightDevices.publishCallback = publish;
    switchDevices.publishCallback = publish;
    mqttMessages.publishCallback = publish;

    ref.onDispose(() {
      disconnect();
    });
    return null;
  }

  FutureOr<mqtt.MqttConnectionState> connect(dynamic secrets) async {
    final appSettings = ref.read(appSettingsProvider);
    log('connecting...');

    final useEncryption = secrets['network']['mqttEncrypt'];

    if (useEncryption) {
      log('mqtt encrypted');
      client = MqttServerClient.withPort(
        secrets['network']['mqttAddress'],
        clientIdentifier,
        secrets['network']['mqttPort'],
      );

      final cert = await rootBundle.load('assets/certs/ca.crt');
      final clientCrt = await rootBundle.load('assets/certs/homebase14.crt');

      final clientKey = encryption.decrypt(appSettings.encryptionKey, hbk);
      // log(clientKey);
      SecurityContext context;

      try {
        context = SecurityContext.defaultContext;
        context.setTrustedCertificatesBytes(cert.buffer.asUint8List());
        context.setClientAuthoritiesBytes(cert.buffer.asInt8List());
        context.useCertificateChainBytes(clientCrt.buffer.asInt8List());
        context.usePrivateKeyBytes(clientKey.codeUnits);

        ref.read(togglerProvider('ssl').notifier).set(true);

        log('SSL enabled');
      } catch (_) {
        // print(_);
        // already set
        context = SecurityContext.defaultContext;
      }

      client.securityContext = context;
      client.secure = true;
    } else {
      log('mqtt unencrypted');
      client = MqttServerClient.withPort(
        secrets['network']['mqttAddress'],
        clientIdentifier,
        secrets['network']['mqttPort'],
      );
      ref.read(togglerProvider('ssl').notifier).set(false);
    }
    // client.logging(on: true);
    // client.autoReconnect = true;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;

    ref.read(mqttConnectionStateProvider.notifier).state = mqtt.MqttConnectionState.connecting;

    // await Future.delayed(
    //   const Duration(seconds: 5),
    // );

    mqtt.MqttConnectionStatus? mqttConnectionStatus =
        await client.connect(secrets['network']['mqttUsername'], secrets['network']['mqttPassword']).catchError(
      // await client.connect().catchError(
      (error) {
        log('error connecting: $error');
        ref.read(mqttConnectionStateProvider.notifier).state = mqtt.MqttConnectionState.faulted;
        return null;
      },
    );

    return mqttConnectionStatus?.state ?? mqtt.MqttConnectionState.faulted;
    // .connected is set in the onConnected handler
  }

  // generic publish function
  void publish(String topic, String payload, {bool retain = false}) {
    log('publishing $topic: $payload');
    final builder = mqtt.MqttPayloadBuilder();
    builder.addString(payload);
    client.publishMessage(topic, mqtt.MqttQos.atLeastOnce, builder.payload!, retain: retain);
  }

  // generic publish function with retain (for dependency injection)
  void publishRetained(String topic, String payload) {
    log('publishing $topic: $payload');
    final builder = mqtt.MqttPayloadBuilder();
    builder.addString(payload);
    client.publishMessage(topic, mqtt.MqttQos.atLeastOnce, builder.payload!, retain: true);
  }

  // zigbee2mqtt publish function
  void publishZ2M(String deviceId, String payload) {
    publish('zigbee2mqtt/$deviceId/set', payload);
  }

  void disconnect() {
    log('disconnect');
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

    client.updates.listen((List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>> messages) {
      // iterate over all new messages
      for (mqtt.MqttReceivedMessage mqttReceivedMessage in messages) {
        counter.increment();
        lastMessageTime.update();

        final payload = mqttReceivedMessage.payload as mqtt.MqttPublishMessage;
        final String message = utf8.decode(payload.payload.message!);

        dynamic payloadDecoded;
        // try to parse the payload as json
        try {
          payloadDecoded = jsonDecode(message);
          // if the payload is not json, it's probably a string
        } on FormatException catch (_) {
          payloadDecoded = message;
        }

        final topic = mqttReceivedMessage.topic!;

        // send the message to the message stream (used by the log)
        if (!topic.contains('/_info/')) {
          messageController.sink.add((topic: topic, payload: payloadDecoded.toString()));
        }

        // add all messages to this generic mqttMessages provider
        ref.read(mqttMessagesFamProvider(topic).notifier).state = payloadDecoded;

        mqttMessages.state = mqttMessages.state.add(
          topic,
          MqttMessage(
            topic: topic,
            payload: message,
          ),
        );

        // look for topics that look like our schema zigbee2mqtt/curtain/i001 for devices and add them to the mqttDevices
        RegExpMatch? match = RegExp(r'zigbee2mqtt/(?<type>\w+)/(?<id>i\d+)$').firstMatch(topic);
        if (match != null) {
          // it's a zigbee2mqtt message
          String deviceType = match.namedGroup('type')!; // e.g. curtain
          String deviceId = '$deviceType/${match.namedGroup('id')!}'; // e.g. curtain/001
          // log(deviceId);

          if (deviceType == 'curtain' || deviceType == 'curtainU') {
            // underwall curtain switch
            curtainDevices.state = curtainDevices.state.add(
              deviceId,
              SingleCurtainDevice(
                deviceId,
                deviceType,
                payloadDecoded,
                publishZ2M,
              ),
            );
          } else if (deviceType == 'dualCurtain') {
            // dual curtain switch
            dualCurtainDevices.state = dualCurtainDevices.state.add(
              deviceId,
              DualCurtainDevice(deviceId, deviceType, payloadDecoded, publishZ2M),
            );
          } else if (deviceType == 'bulb') {
            // dual curtain switch
            ikeaBulbDevices.state = ikeaBulbDevices.state.add(
              deviceId,
              SmartBulbDevice(deviceId, deviceType, payloadDecoded, publishZ2M),
            );
          } else if (deviceType == 'door') {
            // door contact
            doorDevices.state = doorDevices.state.add(
              deviceId,
              DoorDevice(
                deviceId,
                deviceType,
                payloadDecoded,
                publishZ2M,
              ),
            );
          } else if (deviceType == 'thermostat') {
            // thermostat
            thermostatDevices.state = thermostatDevices.state.add(
              deviceId,
              ThermostatDevice(deviceId, deviceType, payloadDecoded, publishZ2M),
            );
          } else if (deviceType == 'humitemp') {
            // thermostat
            humiTempDevices.state = humiTempDevices.state.add(
              deviceId,
              HumiTempDevice(deviceId, deviceType, payloadDecoded, publishZ2M),
            );
          }
        } else if (topic == 'instar/10D1DC228582/status/alarm/triggered/object') {
          doorMovementController.sink.add(
            int.parse(payloadDecoded['val']),
          );

          var objectValue = int.parse(payloadDecoded['val']);
          if (objectValue != 0) {
            doorAlarmController.sink.add(objectValue);
          }
        } else if (topic == 'zigbee2mqtt/bridge/devices') {
          /// we find the device name (description) in the zigbee2mqtt/bridge/devices message
          setDeviceNameMap(payloadDecoded);
        } else if (topic.startsWith('prusa/')) {
          /// Prusa i3 MK3S
          final attribute = topic.split('/').last;

          Map<String, dynamic> data = switch (attribute) {
            'file' => {
                'file_name': payloadDecoded['file_name'],
              },
            'temp' => {
                'extruder_actual': double.tryParse(payloadDecoded['extruder_actual']) ?? 0,
                'extruder_target': double.tryParse(payloadDecoded['extruder_target']) ?? 0,
              },
            'progress' => {
                'percent_done': int.tryParse(payloadDecoded['percent_done']) ?? 0,
                'mins_remaining': int.tryParse(payloadDecoded['mins_remaining']) ?? 0,
              },
            _ => {},
          };

          prusa.addAll(data);
        } else {
          // print(topic);
        }

        // tasmota switches, plugs, bulps, etc
        lightDevices.state.forEach((key, lightDevice) {
          if (lightDevice.topicGet == topic) {
            lightDevices.state = lightDevices.state.add(
              key,
              lightDevice.copyWith(state: message),
            );
          }
        });

        // armed switches like garage door
        switchDevices.state.forEach((key, switchDevice) {
          if (switchDevice.topicState == topic) {
            dynamic devicePayload = message;

            // if the device has a stateKey, we need to parse the json and set the payload to that key's value (e.g. zigbee2mqtt plugs)
            if (switchDevice.stateKey != null) {
              payloadDecoded = jsonDecode(message);
              devicePayload = payloadDecoded[switchDevice.stateKey!];
            }
            switchDevices.state = switchDevices.state.add(
              key,
              switchDevice.copyWith(state: devicePayload, transitioning: false),
            );
          }
        });
      }
    });

    ref.read(mqttConnectionStateProvider.notifier).state = mqtt.MqttConnectionState.connected;
  }

  /// get the device names from the zigbee2mqtt/bridge/devices message
  void setDeviceNameMap(List devices) {
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
        // log('${device['friendly_name']}: ${device['description']}');
      } catch (_) {
        //
      }
    }
    mqttDescriptions.state = IMap({...mqttDescriptions.state.unlock, ...deviceNames});
  }

  void onDisconnected() {
    log('disconnected');

    ref.read(mqttConnectionStateProvider.notifier).state = mqtt.MqttConnectionState.disconnected;
  }
}

/// filter the messageProvider by topic
/// TODOs use the family provider
dynamic getMessage(ProviderBase provider, WidgetRef ref, String topic) {
  dynamic payload;
  final mqttMessage = ref.watch(
    provider.select(
      (mqttMessages) {
        return mqttMessages[topic];
      },
    ),
  );
  if (mqttMessage?.payload != null) {
    payload = mqttMessage!.payload;
  }

  return payload;
}
