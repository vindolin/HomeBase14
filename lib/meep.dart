//  generate code for a widget with the name MeepWidget that initially shows the number 0 and increments the number every 10 seconds by 1 and refreshes.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meep.g.dart';

@Riverpod(keepAlive: true)
class Meep extends _$Meep {
  @override
  int build() => 0;

  void increment() => state++;
}

class MeepWidget extends ConsumerWidget {
  const MeepWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meep = ref.watch(meepProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 10), () {
        ref.read(meepProvider.notifier).increment();
      });
    });
    return Center(child: Text(meep.toString()));
  }
}
