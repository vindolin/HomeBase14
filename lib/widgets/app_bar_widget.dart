import 'package:flutter/material.dart';
import '/widgets/connection_bar_widget.dart';

class AppBarWithIcons extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;

  const AppBarWithIcons({
    super.key,
    required this.title,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      alignment: Alignment.center,
      child: Stack(
        children: [
          AppBar(title: Text(title)),
          const Positioned(
            right: 8.0,
            top: 8.0,
            child: ConnectionBar(),
          ),
        ],
      ),
    );
  }
}
