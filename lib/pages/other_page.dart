import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/utils.dart';
import '/models/mqtt_devices.dart';
import '/pages/curtain_detail_page.dart';
import '/pages/dual_curtain_detail_page.dart';
import '/widgets/connection_bar_widget.dart';

import '/widgets/curtain_icon_widgets.dart';

class OtherPage extends ConsumerWidget {
  const OtherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('OtherPage.build()');

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
