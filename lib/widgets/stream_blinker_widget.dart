import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

class StreamContainerBlinker extends ConsumerStatefulWidget {
  final StreamProvider streamProvider;
  final bool vibrate;
  // container that binds to the message stream provider and blinks when a message is received
  const StreamContainerBlinker(this.streamProvider, {super.key, this.vibrate = false});

  @override
  ConsumerState<StreamContainerBlinker> createState() => _StreamContainerBlinkerState();
}

class _StreamContainerBlinkerState extends ConsumerState<StreamContainerBlinker> {
  @override
  Widget build(BuildContext context) {
    if (widget.vibrate) {
      HapticFeedback.vibrate();
    }
    const int onDurationMs = 100;
    const int fadeDurationMs = 100;

    Color flashColor = Colors.pink;
    Color? targetColor;

    Future<void> setColor() async {
      targetColor = flashColor; // flash color
      await Future.delayed(const Duration(milliseconds: onDurationMs));
      targetColor = Colors.transparent; // and back to transparent
    }

    ref.watch(widget.streamProvider); // every time message stream provider fires, the icon will blink

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
