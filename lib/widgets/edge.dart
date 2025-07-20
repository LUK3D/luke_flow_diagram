import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:luke_flow_diagram/models/node_model.dart';
import 'package:luke_flow_diagram/widgets/edges/bezier.dart';

class BezierEdge extends StatefulWidget {
  final NodeSocketModel source;
  final NodeSocketModel target;
  final bool isAnimated;
  final double dashAnimationSpeed;

  final LukeEdgePainter Function(
    Offset source,
    Offset target,
    bool isAnimated,
    double dashAnimationSpeed,
  )
  painterBuilder;

  const BezierEdge({
    super.key,
    required this.source,
    required this.target,
    required this.painterBuilder,
    this.isAnimated = false,
    this.dashAnimationSpeed = 1,
  });

  @override
  State<BezierEdge> createState() => _BezierEdgeState();
}

class _BezierEdgeState extends State<BezierEdge> with TickerProviderStateMixin {
  late final Ticker _ticker;
  double _dashOffset = 0.0;

  late final double dashSpeed = widget.dashAnimationSpeed;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    setState(() {
      _dashOffset += dashSpeed;
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate bounding box to avoid drawing outside visible area
    final dx =
        (widget.target.position.toOffset().dx -
                widget.source.position.toOffset().dx)
            .abs();
    final dy =
        (widget.target.position.toOffset().dy -
                widget.source.position.toOffset().dy)
            .abs();
    final minX =
        widget.source.position.toOffset().dx <
            widget.target.position.toOffset().dx
        ? widget.source.position.toOffset().dx
        : widget.target.position.toOffset().dx;
    final minY =
        widget.source.position.toOffset().dy <
            widget.target.position.toOffset().dy
        ? widget.source.position.toOffset().dy
        : widget.target.position.toOffset().dy;

    return Positioned(
      left: minX,
      top: minY,
      child: CustomPaint(
        size: Size(dx, dy),
        painter: widget.painterBuilder(
          widget.source.position.toOffset() - Offset(minX, minY),
          widget.target.position.toOffset() - Offset(minX, minY),
          widget.isAnimated,
          _dashOffset,
        ),
      ),
    );
  }
}
