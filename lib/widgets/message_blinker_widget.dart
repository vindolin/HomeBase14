import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/generic_providers.dart';

/// Lock symbol in the connection bar that binds to the message stream provider and blinks when a subscribed MQTT message is received
class MessageBlinker extends ConsumerWidget {
  const MessageBlinker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const int onDurationMs = 100;
    const int fadeDurationMs = 100;

    Color? flashColor;
    Color? targetColor;

    Future<void> setColor() async {
      targetColor = flashColor; // flash color
      await Future.delayed(const Duration(milliseconds: onDurationMs), () {
        targetColor = flashColor?.withAlpha(150); // and back
      });
    }

    ref.watch(counterProvider('mqtt_message')); // every time message stream provider fires, the icon will blink
    final sslStatus = ref.watch(togglerProvider('ssl'));

    // TODOs implicit animation?
    flashColor = sslStatus ? Colors.green : Colors.red;

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
            return Stack(
              children: [
                sslStatus
                    ? Icon(
                        Icons.lock,
                        color: iconColor,
                      )
                    : Icon(
                        Icons.lock_open,
                        color: iconColor,
                      )
              ],
            );
          },
        );
      },
    );
  }
}
