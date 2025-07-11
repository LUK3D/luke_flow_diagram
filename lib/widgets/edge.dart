import 'dart:ui';

import 'package:flutter/material.dart';

class BezierEdge extends StatelessWidget {
  final Offset source;
  final Offset target;
  final bool isDashed;
  final Color color;
  final double strokeWidth;

  const BezierEdge({
    super.key,
    required this.source,
    required this.target,
    this.isDashed = false,
    this.color = Colors.black,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate bounding box to avoid drawing outside visible area
    final dx = (target.dx - source.dx).abs();
    final dy = (target.dy - source.dy).abs();
    final minX = source.dx < target.dx ? source.dx : target.dx;
    final minY = source.dy < target.dy ? source.dy : target.dy;

    return Positioned(
      left: minX,
      top: minY,
      child: CustomPaint(
        size: Size(dx, dy),
        painter: BezierEdgePainter(
          source: source - Offset(minX, minY),
          target: target - Offset(minX, minY),
          isDashed: isDashed,
          color: color,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class BezierEdgePainter extends CustomPainter {
  final Offset source;
  final Offset target;
  final bool isDashed;
  final Color color;
  final double strokeWidth;

  BezierEdgePainter({
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
  bool shouldRepaint(covariant BezierEdgePainter oldDelegate) {
    return source != oldDelegate.source ||
        target != oldDelegate.target ||
        isDashed != oldDelegate.isDashed ||
        color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
