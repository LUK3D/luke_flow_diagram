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
    this.xDensity = 15.0,
    this.yDensity = 15.0,
    this.showLines,
    this.showDots,
    this.lineColor,
    this.lineWidth,
    this.dotRadius,
    this.dotColor,
  });
}
