import 'package:flutter/material.dart';
import 'package:luke_flow_diagram/utils/math.dart';

enum NodeSocketType { input, output, inputOutput }

class NodeSocketModel {
  late String id;
  final String nodeId;
  final NodeSocketType type;
  Vector2 position;
  dynamic data;
  late GlobalKey key;

  NodeSocketModel({
    String? id,
    required this.nodeId,
    required this.type,
    required this.position,
    this.data,
  }) {
    this.id = id ?? UniqueKey().toString();
    key = GlobalKey();
  }

  NodeSocketModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      key = GlobalKey(),
      nodeId = json["node_id"],
      type = NodeSocketType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NodeSocketType.inputOutput,
      ),
      position = Vector2(json['position']['x'], json['position']['y']);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'node_id': nodeId,
      'type': type.name,
      'position': {'x': position.x, 'y': position.y},
    };
  }
}

class NodeModel<T> {
  late Vector2 position;
  late String id;
  late GlobalKey key;
  final T? data;
  late List<NodeSocketModel> inputSockets;
  late List<NodeSocketModel> outputSockets;

  NodeModel({
    Vector2? position,
    String? id,
    this.data,
    List<NodeSocketModel>? inputSockets,
    List<NodeSocketModel>? outputSockets,
  }) {
    this.id = id ?? UniqueKey().toString();
    this.key = GlobalKey();
    this.position = position ?? Vector2.zero;
    this.inputSockets = inputSockets ?? [];
    this.outputSockets = outputSockets ?? [];
    if (this.inputSockets.isEmpty) {
      this.inputSockets.addAll([
        NodeSocketModel(
          nodeId: this.id,
          id: UniqueKey().toString(),
          type: NodeSocketType.input,
          position: Vector2.zero,
          data: {},
        ),
      ]);
      this.outputSockets.addAll([
        NodeSocketModel(
          nodeId: this.id,
          id: UniqueKey().toString(),
          type: NodeSocketType.output,
          position: Vector2.zero,
          data: {},
        ),
      ]);
    }
  }

  NodeModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      data = null,
      key = GlobalKey(),
      position = Vector2(json['position']['x'], json['position']['y']),
      outputSockets = List<NodeSocketModel>.from(
        (json["output_sockets"] as List<Map<String, dynamic>>)
            .map((ns) => NodeSocketModel.fromJson(ns))
            .toList(),
      ),
      inputSockets = List<NodeSocketModel>.from(
        (json["input_sockets"] as List<Map<String, dynamic>>)
            .map((ns) => NodeSocketModel.fromJson(ns))
            .toList(),
      );

  Map<String, dynamic> toJson() {
    return {
      'position': {'x': position.x, 'y': position.y},
      'id': id,
      'input_sockets': inputSockets.map((s) => s.toJson()).toList(),
      'output_sockets': outputSockets.map((s) => s.toJson()).toList(),
    };
  }
}
