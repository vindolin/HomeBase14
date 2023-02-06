import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '/utils.dart';
import '/models/mqtt_providers.dart';
import '/widgets/message_blinker_widget.dart';

class ConnectionBar extends ConsumerWidget {
  const ConnectionBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('ConnectionBar.build()');
    final mqttConnectionStateX = ref.watch(mqttConnectionStateXProvider);
    final mqttProviderX = ref.watch(mqttProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (mqttConnectionStateX == MqttConnectionState.connected) ...[
          TextButton(
              onPressed: () => mqttProviderX.disconnect(),
              child: const Icon(
                Icons.wifi,
              )),
        ] else if (mqttConnectionStateX == MqttConnectionState.disconnected) ...[
          TextButton(
              onPressed: () => mqttProviderX.connect(),
              child: const Icon(
                Icons.wifi_off,
              )),
        ] else if (mqttConnectionStateX == MqttConnectionState.faulted) ...[
          const Icon(Icons.wifi_off, color: Colors.red)
        ] else ...[
          const TextButton(
            onPressed: null,
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(),
            ),
          ),
        ],
        const IgnorePointer(
          ignoring: true,
          child: MessageBlinker(),
        ),
      ],
    );
  }
}
