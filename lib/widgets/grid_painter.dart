import 'package:flutter/material.dart';
import '../models/grid_background_settings.dart';

class GridPainter extends CustomPainter {
  final double xDensity;
  final double yDensity;
  final bool showLines;
  final bool showDots;
  final Color lineColor;
  final double lineWidth;
  final double dotRadius;
  final Color dotColor;

  GridPainter({
    required this.xDensity,
    required this.yDensity,
    this.showLines = true,
    this.showDots = false,
    this.lineColor = const Color(0xFFE0E0E0),
    this.lineWidth = 1.0,
    this.dotColor = const Color(0xFFE0E0E0),
    this.dotRadius = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (showLines) _drawLines(canvas, size);
    if (showDots) _drawDots(canvas, size);
  }

  void _drawLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth;

    for (double x = 0; x < size.width; x += xDensity) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += yDensity) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawDots(Canvas canvas, Size size) {
    final paint = Paint()..color = dotColor;

    for (double x = 0; x < size.width; x += xDensity) {
      for (double y = 0; y < size.height; y += yDensity) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter old) {
    return old.xDensity != xDensity ||
        old.yDensity != yDensity ||
        old.showLines != showLines ||
        old.showDots != showDots ||
        old.lineColor != lineColor ||
        old.lineWidth != lineWidth ||
        old.dotColor != dotColor ||
        old.dotRadius != dotRadius;
  }
}

class BackgroundGrid extends StatelessWidget {
  final BackgroundGridSettings settings;

  const BackgroundGrid({
    super.key,
    this.settings = const BackgroundGridSettings(
      xDensity: 15.0,
      yDensity: 15.0,
      showLines: false,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GridPainter(
        xDensity: settings.xDensity,
        yDensity: settings.yDensity,
        lineColor: settings.lineColor ?? Colors.grey.withAlpha(150),
        lineWidth: settings.lineWidth ?? 0.5,
        showDots: settings.showDots ?? false,
        showLines: settings.showLines ?? true,
        dotColor: settings.dotColor ?? Colors.grey.withAlpha(150),
        dotRadius: settings.dotRadius ?? 1.5,
      ),
      size: Size.infinite,
    );
  }
}
