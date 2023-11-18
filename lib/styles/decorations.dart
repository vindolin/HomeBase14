import 'package:flutter/material.dart';

const fancyBackground = BoxDecoration(
  gradient: LinearGradient(
    stops: [0.0, 0.6, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(150, 0, 0, 0),
      Color.fromARGB(10, 0, 0, 0),
      Color.fromARGB(150, 0, 0, 0),
    ],
  ),
  image: DecorationImage(
    repeat: ImageRepeat.repeat,
    image: AssetImage('assets/images/bg_pattern.png'),
  ),
);
