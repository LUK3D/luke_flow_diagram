import 'package:flutter/material.dart';

/// # Vector2
/// A simple 2D vector class for representing points or directions in a 2D space.
class Vector2 {
  final double x;
  final double y;

  static const zero = Vector2(0, 0);

  const Vector2(this.x, this.y);

  Vector2 operator +(Vector2 other) => Vector2(x + other.x, y + other.y);

  Vector2 operator -(Vector2 other) => Vector2(x - other.x, y - other.y);

  Vector2 operator *(double scalar) => Vector2(x * scalar, y * scalar);

  Vector2 operator /(double scalar) {
    if (scalar == 0) {
      throw ArgumentError("Division by zero is not allowed.");
    }
    return Vector2(x / scalar, y / scalar);
  }

  Vector2 add(Vector2 other) => Vector2(x + other.x, y + other.y);

  /// Creates a new instance with the same values.
  Vector2 copy() => Vector2(x, y);

  /// Creates a new instance with optional updates.
  Vector2 copyWith({double? x, double? y}) => Vector2(x ?? this.x, y ?? this.y);

  /// Create from Flutter's Offset
  factory Vector2.fromOffset(Offset offset) => Vector2(offset.dx, offset.dy);

  /// Convert to Offset (optional but useful)
  Offset toOffset() => Offset(x, y);

  @override
  String toString() => 'Vector2(x: $x, y: $y)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vector2 &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
