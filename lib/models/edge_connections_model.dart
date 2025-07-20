import 'package:luke_flow_diagram/models/node_model.dart';

class EdgeConnectionsModel {
  late final String id;
  final NodeSocketModel source;
  final NodeSocketModel target;
  final dynamic data;

  EdgeConnectionsModel({
    required this.source,
    required this.target,
    this.data,
  }) {
    id = "${source.id}-${target.id}";
  }

  /// Returns a new copy with updated source and/or target sockets.
  EdgeConnectionsModel copy({
    NodeSocketModel? source,
    NodeSocketModel? target,
    dynamic data,
  }) {
    final newSource = source ?? this.source.copy();
    final newTarget = target ?? this.target.copy();
    return EdgeConnectionsModel(
      source: newSource,
      target: newTarget,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "source": source.toJson(), "target": target.toJson()};
  }

  static EdgeConnectionsModel fromJson(Map<String, dynamic> json) {
    return EdgeConnectionsModel(
      source: NodeSocketModel.fromJson(json["source"]),
      target: NodeSocketModel.fromJson(json["target"]),
    );
  }
}
