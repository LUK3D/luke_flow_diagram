import 'dart:math';

import 'package:luke_flow_diagram/luke_flow_diagram.dart';

Vector2 getRandomPositionNearCenter({
  double spread = 200.0,
  double canvasSize = 2024 * 5,
}) {
  final centerX = canvasSize / 2;
  final centerY = canvasSize / 2;

  final rand = Random();

  final dx = (rand.nextDouble() * spread) - (spread / 2);
  final dy = (rand.nextDouble() * spread) - (spread / 2);

  return Vector2(centerX + dx, centerY + dy);
}
