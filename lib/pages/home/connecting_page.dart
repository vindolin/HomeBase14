import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/app_settings.dart';

import '/models/mqtt_providers.dart';

/// this page is a replacement for the login form which I don't need anymore.
class ConnectingPage extends ConsumerWidget {
  const ConnectingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appSettingsProvider);
    ref.watch(mqttProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connecting'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Connecting to the Homebase...\n',
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
