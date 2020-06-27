import 'package:flutter/material.dart';

class ColorList {
  List<Color> _colors = [
    Colors.white,
    Colors.black,
    Colors.grey,
    Colors.red[800],
    Colors.green[900],
    Colors.blue[900],
    Color(int.parse("0xff" + "fcb103")),
    Color(0xff009688),
    Color(0xfff36c26),
  ];

  bool isPreset(Color c) {
    return _colors.contains(c);
  }

  List<Color> getColors() {
    return [..._colors];
  }
}
