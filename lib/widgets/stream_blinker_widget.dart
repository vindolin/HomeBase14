import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

// container that binds to the message stream provider and blinks when a message is received
class StreamContainerBlinker extends ConsumerWidget {
  final StreamProvider streamProvider;
  final bool vibrate;
  final bool ignoreFirstBuild;
  final Color color;

  // prevent the first build from blinking because of the retained MQTT message
  final firstBuildProvider = StateProvider<bool>((ref) => true);

  StreamContainerBlinker(
    this.streamProvider, {
    super.key,
    this.vibrate = false,
    this.ignoreFirstBuild = false,
    this.color = const Color(0xFFAD1457),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(streamProvider); // every time message stream provider fires, the icon will blink

    // the future is needed to move the provider state change to the next frame
    if (ignoreFirstBuild && ref.read(firstBuildProvider)) {
      Future(() => ref.read(firstBuildProvider.notifier).state = false);
      return Container();
    }

    if (vibrate) {
      HapticFeedback.vibrate();
    }
    const int onDurationMs = 100;
    const int fadeDurationMs = 100;

    Color flashColor = color;
    Color? targetColor;

    Future<void> setColor() async {
      targetColor = flashColor; // flash color
      await Future.delayed(const Duration(milliseconds: onDurationMs));
      targetColor = Colors.transparent; // and back to transparent
    }

    return FutureBuilder<void>(
      future: setColor(),
      builder: (context, AsyncSnapshot<void> _) {
        return TweenAnimationBuilder<Color?>(
          tween: ColorTween(
            begin: null,
            end: targetColor,
          ),
          duration: const Duration(milliseconds: fadeDurationMs),
          curve: Curves.easeInOut,
          builder: (
            BuildContext context,
            Color? color,
            Widget? child,
          ) {
            return Container(
              color: color,
            );
          },
        );
      },
    );
  }
}
