@riverpod
class Mqtt extends _$Mqtt {
  final MqttClient mqtt = MqttClient();
  @override
  FutureOr<void> build() {
    print('building mqtt');
    mqtt.onConnected = onConnected;
    mqtt.onDisconnected = onDisconnected;
  }

  Future<void> connect() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard<void>(
      () async {
        // connecting
        ref.read(mqttConnectionStateXProvider.notifier).state = MqttConnectionState.connecting;
        Future.delayed(
          const Duration(seconds: 2),
          () {
            mqtt.connect(config.username, config.password);
          },
        );
      },
    );
  }

  void disconnect() {
    mqtt.disconnect();
  }

  void onConnected() {
    print('connected');
    mqtt.subscribe('homer/#', MqttQos.atMostOnce);

    mqtt.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final message = c![0].payload as MqttPublishMessage;
      final payload = const Utf8Decoder().convert(message.payload.message);

      print(message);
      print(payload);
    });

    ref.read(mqttConnectionStateXProvider.notifier).state = MqttConnectionState.connected;
  }

  void onDisconnected() {
    print('disconnected');
    ref.read(mqttConnectionStateXProvider.notifier).state = MqttConnectionState.disconnected;
  }
}


@riverpod
class MqttConnectionDataXXX extends _$MqttConnectionDataXXX {
  // Future<MqttConnectionDataClass> build() async {
  @override
  FutureOr<MqttConnectionDataClass> build() {
    return const MqttConnectionDataClass(
      username: config.username,
      password: config.password,
      address: config.server,
      port: config.port,
    );
  }

  Future<void> save(Map<String, dynamic> data) async {
    state = const AsyncLoading();

    state = await Future(
      () => AsyncValue.data(
        state.value!.copyWith(
          username: data['username'],
          password: data['password'],
          address: data['address'],
          port: data['port'],
        ),
      ),
    );
  }
}

    // final mqttConnectionData = ref.watch(mqttConnectionDataXXXProvider);
    // Map<String, dynamic> formData = {
    //   'username': mqttConnectionData.value?.username,
    //   'password': mqttConnectionData.value?.password,
    //   'address': mqttConnectionData.value?.address,
    //   'port': mqttConnectionData.value?.port,
    // };


    final thermostatDevicesProvider = Provider<Map<String, dynamic>>((ref) {
      return Map.fromEntries(
        ({...mqttDevicesX}..removeWhere((_, device) => device is! ThermostatDevice)).entries.toList()
          ..sort(
            (a, b) => deviceNames[a.key]!.compareTo(
              deviceNames[b.key]!,
            ),
          )
          ..sort(
            // then sort by local temperature
            (a, b) => b.value.localTemperature.compareTo(
              a.value.localTemperature,
            ),
          ),
      );
    });

@riverpod
Map<String, AbstractMqttDevice> curtainDevices(CurtainDevicesRef ref) {
  final mqttDevices = ref.watch(mqttDevicesXProvider);
  return {
    ...Map.fromEntries(
      ({...mqttDevices}..removeWhere(
              (key, value) {
                return value is! CurtainDevice;
              },
            ))
          .entries
          .toList(),
    ),
  };
}

@riverpod
Map<String, dynamic> curtainDevices(CurtainDevicesRef ref) {
  final curtainDevices = ref.watch(curtainDevicesProvider);
  return {
    ...Map.fromEntries(
      ({...curtainDevices}..removeWhere(
              (key, value) {
                return !key.startsWith('dualCurtain');
              },
            ))
          .entries
          .toList(),
    ),
  };
}


class MyFancyPainter extends CustomPainter {
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      // ..style = PaintingStyle.stroke
      ..style = PaintingStyle.fill
      // ..strokeWidth = 4.0
      ..color = Colors.indigo
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.indigo,
          Colors.blue,
        ],
      ).createShader(const Rect.fromLTWH(0, 0, 24, 24));
    // ..blendMode = BlendMode.color;

    // canvas.drawRect(
    //   const Rect.fromLTWH(0, 0, 24, 24),
    //   paint,
    // );
  }
}


import 'package:flutter_svg/flutter_svg.dart';

const String assetName = 'assets/images/svg/blinds.svg';
final Widget svg = SvgPicture.asset(
  assetName,
  // semanticsLabel: 'blinds',
  color: Colors.white,
  width: 24,
  height: 24,
);

final paint = Paint()..color = Colors.transparent;
canvas.drawRect(
  Rect.fromLTWH(0, 0, size.width, size.height),
  paint,
);
