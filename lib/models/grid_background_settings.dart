import 'package:flutter/material.dart';

class BackgroundGridSettings {
  final double xDensity;
  final double yDensity;
  final bool? showLines;
  final bool? showDots;
  final Color? lineColor;
  final double? lineWidth;
  final double? dotRadius;
  final Color? dotColor;

  const BackgroundGridSettings({
    required this.xDensity,
    required this.yDensity,
    this.showLines,
    this.showDots,
    this.lineColor,
    this.lineWidth,
    this.dotRadius,
    this.dotColor,
  });
}
