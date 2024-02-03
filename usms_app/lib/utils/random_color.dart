import 'dart:math';

import 'package:flutter/material.dart';

Color getRandomColor() {
  Random random = Random();
  int red = random.nextInt(256);
  int green = random.nextInt(256);
  int blue = random.nextInt(256);

  return Color.fromARGB(255, red, green, blue);
}

List<Color?> colorList = [
  Colors.blue[100],
  Colors.blue[300],
  Colors.blue[500],
  Colors.blue[700],
  Colors.blue[900],
];
