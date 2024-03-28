import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '/styles/styles.dart';
import '/utils.dart';
import '/widgets/connection_bar_widget.dart';

/// Random stuff for Mona
class MonaPage extends ConsumerWidget {
  const MonaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('MonaPage.build()');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mona'),
        actions: const [ConnectionBar()],
      ),
      body: Container(
        decoration: fancyBackground,
        child: GridView.count(
          padding: const EdgeInsets.all(8),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          children: const [
            Card(),
          ],
        ),
      ),
    );
  }
}
