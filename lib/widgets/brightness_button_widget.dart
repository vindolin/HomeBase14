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

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () => ref.read(brightnessSettingProvider.notifier).toggle(),
        child: Icon(
          color: brightness == Brightness.dark ? Colors.white : Colors.black,
          Icons.brightness_medium,
        ),
      ),
    );
  }
}
