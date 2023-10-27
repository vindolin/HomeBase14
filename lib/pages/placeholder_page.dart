import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceholderPage extends ConsumerWidget {
  const PlaceholderPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(color: Colors.green, child: const Text('placeholder')),
    );
  }
}
