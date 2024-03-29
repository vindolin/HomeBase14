import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/network_type_provider.dart';
import '/models/app_settings_provider.dart';
import '/models/mqtt_providers.dart';
import '/models/mqtt_connection_state_provider.dart';
import '/widgets/message_blinker_widget.dart';
import '/widgets/brightness_button_widget.dart';

class ConnectionBar extends ConsumerWidget {
  final List<Widget>? children;
  const ConnectionBar({this.children, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mqttConnectionState = ref.watch(mqttConnectionStateProvider);
    ref.watch(mqttProvider.notifier);
    final appSettings = ref.watch(appSettingsProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...?children,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (mqttConnectionState == MqttConnectionState.connected) ...[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      ref.read(networkTypeProvider.notifier).toggleNetworkType();
                    },
                    child: const Icon(
                      color: Colors.green,
                      Icons.wifi,
                    ),
                  ),
                )
              ] else if (mqttConnectionState == MqttConnectionState.disconnected) ...[
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    color: Colors.red,
                    Icons.wifi_off,
                  ),
                )
              ] else if (mqttConnectionState == MqttConnectionState.faulted) ...[
                const Icon(Icons.wifi_off, color: Colors.red)
              ] else ...[
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(),
                )
              ],
              if (appSettings.showBrightness) const BrightnessButton(),
              IgnorePointer(
                ignoring: true,
                child: MessageBlinker(
                  color: ref.watch(networkTypeProvider) == networkTypeLocal ? Colors.blue : Colors.green,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
