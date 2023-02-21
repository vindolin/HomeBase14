import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/mqtt_providers.dart';

class MessageBlinker extends ConsumerStatefulWidget {
  // symbol that binds to the message stream provider and blinks when a message is received
  const MessageBlinker({super.key});

  @override
  ConsumerState<MessageBlinker> createState() => _MessageBlinkerState();
}

class _MessageBlinkerState extends ConsumerState<MessageBlinker> {
  @override
  Widget build(BuildContext context) {
    const int onDurationMs = 100;
    const int fadeDurationMs = 100;

    Color flashColor = Colors.orange;
    Color? targetColor;

    Future<void> setColor() async {
      targetColor = flashColor; // flash color
      await Future.delayed(const Duration(milliseconds: onDurationMs));
      targetColor = Colors.transparent; // and back to transparent
    }

    ref.watch(messageProvider); // every time message stream provider fires, the icon will blink

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
            Color? iconColor,
            Widget? child,
          ) {
            return Icon(
              Icons.auto_awesome,
              color: iconColor,
            );
          },
        );
      },
    );
  }
}
