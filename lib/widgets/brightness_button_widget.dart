import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'brightness_button_widget.g.dart';

@Riverpod(keepAlive: true)
class BrightnessSetting extends _$BrightnessSetting {
  @override
  Brightness build() => MediaQueryData.fromWindow(
        WidgetsBinding.instance.window,
      ).platformBrightness;

  void toggle() => state = state == Brightness.dark ? Brightness.light : Brightness.dark;
}

class BrightnessButton extends ConsumerWidget {
  const BrightnessButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = ref.watch(brightnessSettingProvider);

    return IconButton(
      onPressed: () => ref.read(brightnessSettingProvider.notifier).toggle(),
      color: brightness == Brightness.dark ? Colors.white : Colors.black,
      icon: Container(
        color: brightness == Brightness.dark ? Colors.black : Colors.transparent,
        child: const Icon(
          Icons.brightness_medium,
        ),
      ),
    );
  }
}
