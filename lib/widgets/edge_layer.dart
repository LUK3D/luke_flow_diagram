import 'package:flutter/material.dart';
import '../models/edge_connections_model.dart';
import 'edge.dart';
import 'edges/bezier.dart';
import 'edges/step.dart';

class EdgeLayer<E> extends StatelessWidget {
  final List<EdgeConnectionsModel<E>> connections;
  final LukeEdgePainter Function(
    Offset source,
    Offset target,
    EdgeConnectionsModel<E> edgeConnection,
    double dashOffset,
  )?
  edgeBuilder;

  const EdgeLayer({super.key, required this.connections, this.edgeBuilder});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: connections.map((c) {
        return BezierEdge(
          source: c.source,
          target: c.target,
          isAnimated: c.isAnimated,
          dashAnimationSpeed: c.animationSpeed,
          painterBuilder: (source, target, isAnimated, dashOffset) {
            return edgeBuilder?.call(source, target, c, dashOffset) ??
                c.painter ??
                LukeStepEdgePainter(
                  source: source,
                  target: target,
                  isDashed: true,
                  color: Colors.pink,
                  strokeWidth: 4,
                  horizontalStepPercent: 0.7,
                  cornerRadius: 30,
                  isAnimated: c.isAnimated,
                  dashAnimationSpeed: c.animationSpeed,
                  dashOffset: dashOffset,
                );
          },
        );
      }).toList(),
    );
  }
}
