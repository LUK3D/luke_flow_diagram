import 'package:flutter/semantics.dart';

/// # Vector2
/// A simple 2D vector class for representing points or directions in a 2D space.
class Vector2 {
  final double x;
  final double y;
  static final zero = Vector2(0, 0);

  Vector2(this.x, this.y);

  Vector2 operator +(Vector2 other) {
    return Vector2(x + other.x, y + other.y);
  }

  Vector2 operator -(Vector2 other) {
    return Vector2(x - other.x, y - other.y);
  }

  Vector2 operator *(double scalar) {
    return Vector2(x * scalar, y * scalar);
  }

  Vector2 operator /(double scalar) {
    if (scalar == 0) {
      throw ArgumentError("Division by zero is not allowed.");
    }
    return Vector2(x / scalar, y / scalar);
  }

  Vector2 add(Vector2 other) {
    return Vector2(x + other.x, y + other.y);
  }

  Vector2 fromOffset(Offset offset) {
    return Vector2(offset.dx, offset.dy);
  }

  @override
  String toString() {
    return 'Vector2(x: $x, y: $y)';
  }
}
