import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/utils.dart';
import '/widgets/connection_bar_widget.dart';

class ThomasPage extends ConsumerWidget {
  const ThomasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('ThomasPage.build()');

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('device_names.thomas')),
        actions: const [ConnectionBar()],
      ),
      body: const Center(child: Text('implement me')),
    );
  }
}
