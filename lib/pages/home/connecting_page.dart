import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/mqtt_providers.dart';

/// this page is a replacement for the login form which I don't need anymore.
class ConnectingPage extends ConsumerWidget {
  const ConnectingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Mqtt mqttProviderNotifier = ref.watch(mqttProvider.notifier);
    ref.watch(mqttProvider.notifier); // this triggers the mqtt connection

    Future(() async => await mqttProviderNotifier.connect());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connecting'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Connecting to the server...',
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
