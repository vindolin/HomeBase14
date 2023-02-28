import 'package:flutter_riverpod/flutter_riverpod.dart';

dynamic watchMqttMessage(ProviderBase provider, WidgetRef ref, String topic) {
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
