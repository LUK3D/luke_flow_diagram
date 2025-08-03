// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:luke_flow_diagram/models/node_model.dart';
import 'package:luke_flow_diagram/widgets/edges/bezier.dart';

class EdgeConnectionsModel<E> {
  late final String id;
  final NodeSocketModel source;
  final NodeSocketModel target;
  final E? data;
  final LukeEdgePainter? painter;
  final double animationSpeed;
  final bool isAnimated;

  EdgeConnectionsModel({
    String? id,
    required this.source,
    required this.target,
    this.data,
    this.painter,
    this.isAnimated = false,
    this.animationSpeed = 1,
  }) {
    this.id = "${source.id}-${target.id}";
  }

  /// Returns a new copy with updated source and/or target sockets.
  EdgeConnectionsModel<E> copy({
    NodeSocketModel? source,
    NodeSocketModel? target,
    E? data,
    LukeEdgePainter? painter,
    double? animationSpeed,
    bool? isAnimated,
  }) {
    final newSource = source ?? this.source.copy();
    final newTarget = target ?? this.target.copy();
    return EdgeConnectionsModel<E>(
      source: newSource,
      target: newTarget,
      data: data ?? this.data,
      painter: painter ?? this.painter,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      isAnimated: isAnimated ?? this.isAnimated,
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "source": source.toJson(), "target": target.toJson()};
  }

  static EdgeConnectionsModel<E> fromJson<E>(Map<String, dynamic> json) {
    return EdgeConnectionsModel<E>(
      source: NodeSocketModel.fromJson(json["source"]),
      target: NodeSocketModel.fromJson(json["target"]),
    );
  }

  EdgeConnectionsModel<E> copyWith({
    String? id,
    NodeSocketModel? source,
    NodeSocketModel? target,
    E? data,
    LukeEdgePainter? painter,
    double? animationSpeed,
    bool? isAnimated,
  }) {
    return EdgeConnectionsModel<E>(
      id: id ?? this.id,
      source: source ?? this.source,
      target: target ?? this.target,
      data: data ?? this.data,
      painter: painter ?? this.painter,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      isAnimated: isAnimated ?? this.isAnimated,
    );
  }
}
