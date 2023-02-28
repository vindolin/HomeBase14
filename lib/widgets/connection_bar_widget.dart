import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/mqtt_providers.dart';
import '/models/mqtt_connection_state_provider.dart';
import '/pages/home/widgets/temperatures_widget.dart';
import '/widgets/message_blinker_widget.dart';

class ConnectionBar extends ConsumerWidget {
  const ConnectionBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mqttConnectionState = ref.watch(mqttConnectionStateProvider);
    final mqttProviderNotifier = ref.watch(mqttProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 8.0),
        const Temperatures(),
        const Spacer(),
        if (mqttConnectionState == MqttConnectionState.connected) ...[
          TextButton(
            onPressed: () => mqttProviderNotifier.disconnect(),
            child: const Icon(
              Icons.wifi,
            ),
          ),
        ] else if (mqttConnectionState == MqttConnectionState.disconnected) ...[
          TextButton(
            onPressed: () => mqttProviderNotifier.connect(),
            child: const Icon(
              Icons.wifi_off,
            ),
          ),
        ] else if (mqttConnectionState == MqttConnectionState.faulted) ...[
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
        const SizedBox(width: 8.0)
      ],
    );
  }
}
