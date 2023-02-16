import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/utils.dart';
import '/models/mqtt_devices.dart';
import '/widgets/connection_bar_widget.dart';

class LightPage extends ConsumerWidget {
  const LightPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('LightPage.build()');

    final deviceNames = ref.read(deviceNamesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Curtains'),
      ),
      body: Text('meep'),
      floatingActionButton: const ConnectionBar(),
    );
  }
}
