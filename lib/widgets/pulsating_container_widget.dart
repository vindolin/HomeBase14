import 'package:flutter/material.dart';

class PulsatingContainer extends StatefulWidget {
  final Color color;
  const PulsatingContainer({
    this.color = Colors.pink,
    super.key,
  });

  @override
  State<PulsatingContainer> createState() => PulsatingContainerState();
}

class PulsatingContainerState extends State<PulsatingContainer> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0.0,
      upperBound: 0.3,
    )..repeat(reverse: true);

    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(animation.value),
                spreadRadius: 3,
                blurRadius: 3,
              ),
            ],
          ),
        );
      },
    );
  }
}
