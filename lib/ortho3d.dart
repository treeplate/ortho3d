import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart';
export 'package:vector_math/vector_math.dart';

/// This class renders triangles using an orthographic renderer with a width of 2 units.
class TrianglesRenderer3D extends StatelessWidget {
  const TrianglesRenderer3D({
    super.key,
    required this.triangles,
    required this.angle,
    required this.position,
  });

  /// The triangles to render. Triangles that intersect each other somewhere other than the edge will not render correctly.
  final List<Triangle> triangles;

  /// The angle of the camera. The x value is rotation around the x axis, y around the y axis, and z around the z axis. With zero angle, the x axis goes left-to-right, the y axis up-to-down, and the z axis is perpendicular to your screen.
  final Vector3 angle;

  /// The position of the camera.
  final Vector3 position;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PointPainter(triangles, angle, position),
    );
  }
}

/// A triangle with color [color] and vertices [a], [b], and [c].
typedef Triangle = ({Color color, Vector3 a, Vector3 b, Vector3 c});

class _PointPainter extends CustomPainter {
  final Iterable<Triangle> triangles;
  final Vector3 angle;
  final Vector3 offset;

  _PointPainter(this.triangles, this.angle, this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    final List<Triangle> newTriangles = [];
    for (Triangle triangle in triangles) {
      newTriangles.add((
        a: rotatePoint(triangle.a + offset, angle),
        b: rotatePoint(triangle.b + offset, angle),
        c: rotatePoint(triangle.c + offset, angle),
        color: triangle.color,
      ));
    }
    newTriangles.sort((a, b) {
      if (a.a.z != b.a.z) {
        return a.a.z.compareTo(b.a.z);
      }
      if (a.b.z != b.b.z) {
        return a.b.z.compareTo(b.b.z);
      }
      return a.c.z.compareTo(b.c.z);
    });
    Offset vector3ToOffset(Vector3 vector) => Offset(
        (vector.x + 1) * size.width / 2, (vector.y + 1) * size.height / 2);
    for (Triangle triangle in newTriangles) {
      if (triangle.a.z < 0 && triangle.b.z < 0 && triangle.c.z < 0) continue;
      canvas.drawVertices(
        Vertices(VertexMode.triangles, [
          vector3ToOffset(triangle.a),
          vector3ToOffset(triangle.b),
          vector3ToOffset(triangle.c)
        ]),
        BlendMode.src,
        Paint()..color = triangle.color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// The underlying function for rotating a point in 3D space around the origin.
/// The angle's x value is rotation around the x axis, y around the y axis, and z around the z axis.
Vector3 rotatePoint(Vector3 point, Vector3 angle) {
  var (double a, double b, double c) = (angle.z, angle.y, angle.x);
  // https://en.wikipedia.org/wiki/Rotation_matrix#In_three_dimensions
  // intrinsic rotation
  Matrix3 rotation = Matrix3(
    cos(a) * cos(b),
    cos(a) * sin(b) * sin(c) - sin(a) * cos(c),
    cos(a) * sin(b) * cos(c) + sin(a) * sin(c),
    sin(a) * cos(b),
    sin(a) * sin(b) * sin(c) + cos(a) * cos(c),
    sin(a) * sin(b) * cos(c) - cos(a) * sin(c),
    -sin(b),
    cos(b) * sin(c),
    cos(b) * cos(c),
  );

  Vector3 result = point.xyz;
  result.applyMatrix3(rotation);
  return result;
}
