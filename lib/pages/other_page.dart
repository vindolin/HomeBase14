import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/utils.dart';
import '/widgets/connection_bar_widget.dart';

class OtherPage extends ConsumerWidget {
  const OtherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('OtherPage.build()');

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('device_names.other')),
        actions: const [ConnectionBar()],
      ),
      body: const Center(child: Text('implement me')),
    );
  }
}
