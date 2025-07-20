import 'dart:ui';
import 'package:flutter/material.dart';

class LukeEdgePainter extends CustomPainter {
  final Offset source;
  final Offset target;
  final bool isDashed;
  final Color color;
  final double strokeWidth;

  LukeEdgePainter({
    required this.source,
    required this.target,
    required this.isDashed,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();

    final dx = (target.dx - source.dx) * 0.5;

    // Create a cubic Bézier curve
    path.moveTo(source.dx, source.dy);
    path.cubicTo(
      source.dx + dx,
      source.dy,
      target.dx - dx,
      target.dy,
      target.dx,
      target.dy,
    );

    if (isDashed) {
      _drawDashedPath(canvas, path, paint);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;

    final PathMetrics pathMetrics = path.computeMetrics();
    for (final PathMetric metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final nextDash = dashWidth + dashSpace;
        final extracted = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extracted, paint);
        distance += nextDash;
      }
    }
  }

  @override
  bool shouldRepaint(covariant LukeEdgePainter oldDelegate) {
    return source != oldDelegate.source ||
        target != oldDelegate.target ||
        isDashed != oldDelegate.isDashed ||
        color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
