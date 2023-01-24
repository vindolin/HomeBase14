import 'package:flutter/material.dart';

AppBar mkAppBar() {
  return AppBar(
    flexibleSpace: const Image(
      image: AssetImage('assets/images/home_bar.jpg'),
      colorBlendMode: BlendMode.hue,
      fit: BoxFit.cover,
    ),
  );
}
