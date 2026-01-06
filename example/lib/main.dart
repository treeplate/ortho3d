import 'dart:js_interop';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ortho3d/ortho3d.dart';
import 'package:web/web.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});
  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

List<Triangle> square(Vector3 a, Vector3 b, Vector3 c, Vector3 d, Color color) {
  return [(a: a, b: b, c: d, color: color), (a: c, b: b, c: d, color: color)];
}

class _ExampleAppState extends State<ExampleApp> {
  Vector3 angle = Vector3(0, 0, 0);
  Vector3 position = Vector3(0, 0, 0);
  static const double triangleDistance = 2;
  static final Vector3 p111 =
      Vector3(triangleDistance, triangleDistance, triangleDistance);
  static final Vector3 p110 =
      Vector3(triangleDistance, triangleDistance, -triangleDistance);
  static final Vector3 p101 =
      Vector3(triangleDistance, -triangleDistance, triangleDistance);
  static final Vector3 p100 =
      Vector3(triangleDistance, -triangleDistance, -triangleDistance);
  static final Vector3 p011 =
      Vector3(-triangleDistance, triangleDistance, triangleDistance);
  static final Vector3 p010 =
      Vector3(-triangleDistance, triangleDistance, -triangleDistance);
  static final Vector3 p001 =
      Vector3(-triangleDistance, -triangleDistance, triangleDistance);
  static final Vector3 p000 =
      Vector3(-triangleDistance, -triangleDistance, -triangleDistance);
  List<Triangle> triangles = [
    ...square(p000, p010, p011, p001, Color(0xffff0000)), // 00
    ...square(p000, p010, p110, p100, Color(0xff0000ff)), // 20
    ...square(p000, p100, p101, p001, Color(0xff00ff00)), // 10
    ...square(p111, p011, p010, p110, Color(0xffff00ff)), // 11
    ...square(p111, p101, p001, p011, Color(0xffffff00)), // 21
    ...square(p111, p101, p100, p110, Color(0xff00ffff)), // 01
  ];

  void onMouseMove(MouseEvent mouseEvent) {
    setState(() {
      angle.y -= mouseEvent.movementX / 100;
      angle.x =
          clampDouble(angle.x + mouseEvent.movementY / 100, -pi / 2, pi / 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        document.body!.requestPointerLock().toDart.then((value) {
          document.onmousemove = onMouseMove.toJS;
        });
      },
      child: TrianglesRenderer3D(
        triangles: triangles,
        angle: angle,
        position: position,
      ),
    );
  }
}
