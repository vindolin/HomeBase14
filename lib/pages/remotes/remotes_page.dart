import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:home_base_14/pages/remotes/remotes_widget.dart';

import '/utils.dart';
import '/widgets/connection_bar_widget.dart';

class RemotesPage extends ConsumerWidget {
  const RemotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('RemotesPage.build()');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Remotes'),
          actions: const [ConnectionBar()],
        ),
        body: const SingleChildScrollView(
          child: RemotesWidget(),
        ));
  }
}
