import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceholderPage extends ConsumerWidget {
  const PlaceholderPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Placeholder'),
      ),
      body: const Center(
        child: Text('Placeholder'),
      ),
    );
  }
}
