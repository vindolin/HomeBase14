import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mqtt_providers.dart';

class MessageBlinker extends ConsumerStatefulWidget {
  const MessageBlinker({super.key});

  @override
  ConsumerState<MessageBlinker> createState() => _MessageBlinkerState();
}

class _MessageBlinkerState extends ConsumerState<MessageBlinker> {
  @override
  void initState() {
    super.initState();
  }

  static const int durationMs = 200;
  late Color targetColor;
  late Color flashColor;

  Future<void> resetColor() async {
    targetColor = flashColor;
    await Future.delayed(const Duration(milliseconds: durationMs));
    targetColor = Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    flashColor = Colors.orange;

    ref.watch(messageProvider);

    targetColor = Theme.of(context).colorScheme.surface;

    // every time message stream provider fires, the icon will blink

    return FutureBuilder<void>(
      future: resetColor(),
      builder: (context, AsyncSnapshot<void> _) {
        return TweenAnimationBuilder<Color?>(
          tween: ColorTween(
            begin: null,
            end: targetColor,
          ),
          duration: const Duration(milliseconds: durationMs),
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
