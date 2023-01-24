import 'dart:convert';
import 'dart:developer' as d;
import 'package:nanoid/nanoid.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'mqtt_connection_data.dart';

part 'mqtt_providers.g.dart';

// typedef Callback = void Function();

final clientIdentifier = 'K${nanoid()}';

// class MqttDevices {}
// final mqttDevices = MqttDevices();

@riverpod
class MqttDevices extends _$MqttDevices {
  @override
  Map<String, dynamic> build() {
    print('building mqttDevices');
    ref.onDispose(() {
      print('disposing mqttDevices');
    });
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

// wraps the whole mqtt client and and connection callbacks
@riverpod
class Mqtt extends _$Mqtt {
  late MqttServerClient mqtt;
  late MqttDevices mqttDevices;

  @override
  build() {
    mqttDevices = ref.watch(mqttDevicesProvider.notifier);
    print('building mqtt');
    ref.onDispose(() {
      disconnect();
    });
  }

  FutureOr<MqttConnectionState> connect() async {
    print('connecting');

    final connectionData = ref.watch(mqttConnectionDataXProvider.notifier);

    mqtt = MqttServerClient.withPort(
      connectionData.state.address,
      clientIdentifier,
      connectionData.state.port,
    );

    mqtt.onConnected = onConnected;
    mqtt.onDisconnected = onDisconnected;

    ref.read(mqttConnectionStateXProvider.notifier).state = MqttConnectionState.connecting;

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    MqttClientConnectionStatus? mqttConnectionStatus =
        await mqtt.connect(connectionData.state.username, connectionData.state.password).catchError(
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

  void disconnect() {
    print('disconnected');
    mqtt.disconnect();
  }

  void onConnected() {
    print('connected');
    mqtt.subscribe('zigbee2mqtt/#', MqttQos.atMostOnce);
    // mqtt.subscribe('zigbee2mqtt/curtain/#', MqttQos.atMostOnce);

    mqtt.pongCallback = () {
      print('ping response client callback invoked');
    };

    mqtt.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (MqttReceivedMessage mqttReceivedMessage in messages) {
        final MqttPublishMessage message = mqttReceivedMessage.payload as MqttPublishMessage;
        final String payload = const Utf8Decoder().convert(message.payload.message);
        final payloadJson = jsonDecode(payload);

        print(mqttReceivedMessage.topic);

        // look for topics that look like our schema zigbee2mqtt/curtain/i001 for devices and add them to the mqttDevices
        if (RegExp(r'zigbee2mqtt/\w+/i\d+').hasMatch(mqttReceivedMessage.topic)) {
          final parts = mqttReceivedMessage.topic.split('/'); // e.g. zigbee2mqtt/curtain001
          String deviceType = parts[1]; // e.g. curtain
          d.log('deviceType: $deviceType');
          String deviceId = '$deviceType/${parts[2]}'; // e.g. curtain/001
          mqttDevices.state = {
            ...mqttDevices.state,
            deviceId: {'_device_type': deviceType, ...payloadJson},
          };

          // final parts = mqttReceivedMessage.topic.split('/'); // e.g. zigbee2mqtt/curtain001
          // final deviceId = '${parts[1]}/${parts[2]}';
          // mqttDevices.state = {...mqttDevices.state, deviceId: payloadJson};

          // we find the device name (description) in the zigbee2mqtt/bridge/devices message
        } else if (mqttReceivedMessage.topic == 'zigbee2mqtt/bridge/devices') {
          setDeviceNameMap(payloadJson);
        }
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
        d.log('${device['friendly_name']}: ${device['description']}');
      } catch (e) {
        //
      }
    }
    mqttDescriptions.state = {...mqttDescriptions.state, ...deviceNames};
  }

  void onDisconnected() {
    print('disconnected');
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
