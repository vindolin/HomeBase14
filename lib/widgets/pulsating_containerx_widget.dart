import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PulsatingContainer extends HookWidget {
  final Color color;
  const PulsatingContainer({
    this.color = Colors.pink,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    useEffect(() {
      animationController.repeat(reverse: true);
      return null;
    }, const []);

    useAnimation(
      animationController.drive(
        Tween(
          begin: 0.0,
          end: 0.2,
        ),
      ),
    );
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(animationController.value),
            spreadRadius: 3,
            blurRadius: 3,
          ),
        ],
      ),
    );
  }

  // @override
  // State<PulsatingContainer> createState() => PulsatingContainerState();
}

// class PulsatingContainerState extends State<PulsatingContainer> with SingleTickerProviderStateMixin {
//   late AnimationController controller;
//   late Animation animation;

//   @override
//   initState() {
//     super.initState();
//     controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..repeat(reverse: true);
//     animation = Tween(
//       begin: 0.0,
//       end: 0.2,
//     ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
//   }

//   @override
//   dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: animation,
//       builder: (context, child) {
//         return Container(
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: widget.color.withOpacity(animation.value),
//                 spreadRadius: 3,
//                 blurRadius: 3,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
