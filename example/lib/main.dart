import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:ortho3d/ortho3d.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});
  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp>
    with SingleTickerProviderStateMixin {
  Vector3 angle = Vector3(0, 0, 0);
  Vector3 position = Vector3(0, 0, 0);
  static const double triangleDistance = 2*sqrt2;
  List<Triangle> triangles = [
    (
      a: Vector3(triangleDistance, 0, 0),
      b: Vector3(0, triangleDistance, 0),
      c: Vector3(0, 0, triangleDistance),
      color: Color(0xFFa0a0a0)
    ),
    (
      a: Vector3(triangleDistance, 0, 0),
      b: Vector3(0, triangleDistance, 0),
      c: Vector3(0, 0, -3),
      color: Color(0xFF0000FF)
    ),
    (
      a: Vector3(triangleDistance, 0, 0),
      b: Vector3(0, -3, 0),
      c: Vector3(0, 0, triangleDistance),
      color: Color(0xFF00FF00)
    ),
    (
      a: Vector3(triangleDistance, 0, 0),
      b: Vector3(0, -3, 0),
      c: Vector3(0, 0, -3),
      color: Color(0xFF00FFFF)
    ),
    (
      a: Vector3(-triangleDistance, 0, 0),
      b: Vector3(0, triangleDistance, 0),
      c: Vector3(0, 0, triangleDistance),
      color: Color(0xFFFF0000)
    ),
    (
      a: Vector3(-triangleDistance, 0, 0),
      b: Vector3(0, triangleDistance, 0),
      c: Vector3(0, 0, -3),
      color: Color(0xFFFF00FF)
    ),
    (
      a: Vector3(-triangleDistance, 0, 0),
      b: Vector3(0, -3, 0),
      c: Vector3(0, 0, triangleDistance),
      color: Color(0xFFFFFF00)
    ),
    (
      a: Vector3(-triangleDistance, 0, 0),
      b: Vector3(0, -3, 0),
      c: Vector3(0, 0, -3),
      color: Color(0xFFFFFFFF)
    ),
  ];

  late final Ticker ticker;
  @override
  void initState() {
    createTicker(tick).start();
    super.initState();
  }

  bool rotating = false;

  void tick(Duration d) {
    setState(() {
      if (rotating) {
        angle.y += .01;
        angle.x += .01;
      }
    });
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (details) {
        angle.y += details.delta.dx/100;
        angle.x = clampDouble(angle.x-details.delta.dy/100, -pi/2, pi/2);
      },
      child: KeyboardListener(
        focusNode: focusNode,
        onKeyEvent: (key) {
          switch(key.logicalKey) {
            case LogicalKeyboardKey.arrowLeft:
              setState(() {
                angle.y-=.05;
              });
            case LogicalKeyboardKey.arrowRight:
              setState(() {
                angle.y+=.05;
              });
            case LogicalKeyboardKey.arrowUp:
              setState(() {
                angle.x+=.05;
              });
            case LogicalKeyboardKey.arrowDown:
              setState(() {
                angle.x-=.05;
              });
          }
        },
        autofocus: true,
        child: TrianglesRenderer3D(
          triangles: triangles,
          angle: angle,
          position: position,
        ),
      ),
    );
  }
}
