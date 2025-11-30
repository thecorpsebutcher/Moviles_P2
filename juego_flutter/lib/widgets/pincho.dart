import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'dart:math' as math;

class Pincho extends StatelessWidget {
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation; // en radianes
   final String assetPath;

  const Pincho({
    Key? key,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.rotation = 0,
    required this.assetPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      width: width,
      height: height,
      child: Transform.rotate(
        angle: rotation,
        child: Image.asset(
          assetPath,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
