import 'package:flutter/material.dart';

GlobalKey generateSocketKey(String nodeId, String socketId) {
  return GlobalKey(debugLabel: '$nodeId-$socketId');
}
