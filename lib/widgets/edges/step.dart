import 'package:luke_flow_diagram/widgets/edges/bezier.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

class LukeStepEdgePainter extends LukeEdgePainter {
  final double cornerRadius;

  /// Percentage [0-1] of horizontal distance where the horizontal step is placed
  final double horizontalStepPercent;

  /// Percentage [0-1] of vertical distance where the vertical step is placed
  final double verticalStepPercent;

  final double dashWidth;
  final double dashSpace;

  final bool isAnimated;
  final double dashAnimationSpeed; // e.g., 60.0 (pixels per second)
  final double dashOffset; // dynamic value, controlled externally

  LukeStepEdgePainter({
    required super.source,
    required super.target,
    required super.isDashed,
    required super.color,
    required super.strokeWidth,
    this.cornerRadius = 8.0,
    this.horizontalStepPercent = 0.5,
    this.verticalStepPercent = 0.5,
    this.dashWidth = 8.0,
    this.dashSpace = 8.0,
    this.dashAnimationSpeed = 1,
    this.isAnimated = false,
    this.dashOffset = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    final startX = source.dx;
    final startY = source.dy;
    final endX = target.dx;
    final endY = target.dy;

    final verticalDistance = (endY - startY).abs();
    final horizontalDistance = (endX - startX).abs();

    final verticalThreshold = 5;

    // Only draw steps if vertical distance is above threshold
    final enableSteps = verticalDistance > verticalThreshold;

    if (!enableSteps) {
      path.moveTo(startX, startY);
      path.lineTo(endX, endY);
    } else {
      final isGoingRight = (endX - startX) >= 0;
      final isGoingDown = (endY - startY) >= 0;

      // Calculate dynamic step sizes based on percentages of distances
      final horizontalStep =
          horizontalDistance * horizontalStepPercent * (isGoingRight ? 1 : -1);
      final verticalStep =
          verticalDistance * verticalStepPercent * (isGoingDown ? 1 : -1);

      // Clamp corner radius to reasonable range (e.g. no more than min(horizontalStep, verticalStep))
      final maxCorner = [
        horizontalStep.abs(),
        verticalStep.abs(),
      ].reduce((a, b) => a < b ? a : b);
      final corner = cornerRadius.clamp(0.0, maxCorner);

      path.moveTo(startX, startY);

      // Horizontal segment before corner
      path.lineTo(
        startX + horizontalStep - corner * (isGoingRight ? 1 : -1),
        startY,
      );

      // Quadratic bezier corner (horizontal to vertical)
      path.quadraticBezierTo(
        startX + horizontalStep,
        startY,
        startX + horizontalStep,
        startY + verticalStep * 0.5,
      );

      // Vertical segment
      path.lineTo(startX + horizontalStep, endY - verticalStep * 0.5);

      // Quadratic bezier corner (vertical to horizontal)
      path.quadraticBezierTo(
        startX + horizontalStep,
        endY,
        startX + horizontalStep + corner * (isGoingRight ? 1 : -1),
        endY,
      );

      // Final horizontal segment to target
      path.lineTo(endX, endY);
    }

    if (isDashed) {
      _drawDashedPath(canvas, path, paint);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = isAnimated ? dashOffset % (dashWidth + dashSpace) : 0.0;
      while (distance < metric.length) {
        final end = distance + dashWidth;
        final extracted = metric.extractPath(
          distance.clamp(0.0, metric.length),
          end.clamp(0.0, metric.length),
        );
        canvas.drawPath(extracted, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant LukeStepEdgePainter oldDelegate) {
    return source != oldDelegate.source ||
        target != oldDelegate.target ||
        isDashed != oldDelegate.isDashed ||
        color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        cornerRadius != oldDelegate.cornerRadius ||
        horizontalStepPercent != oldDelegate.horizontalStepPercent ||
        verticalStepPercent != oldDelegate.verticalStepPercent ||
        dashWidth != oldDelegate.dashWidth ||
        dashSpace != oldDelegate.dashSpace ||
        dashAnimationSpeed != oldDelegate.dashAnimationSpeed ||
        dashOffset != oldDelegate.dashOffset ||
        isAnimated != oldDelegate.isAnimated;
  }
}
