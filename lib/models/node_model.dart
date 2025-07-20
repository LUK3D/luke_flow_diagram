import 'package:flutter/material.dart';
import 'package:luke_flow_diagram/utils/math.dart';

enum NodeSocketType { input, output, inputOutput }

class NodeSocketModel {
  late String id;
  final String nodeId;
  final NodeSocketType type;
  Vector2 position;
  dynamic data;
  final int connectionLimit;

  NodeSocketModel({
    String? id,
    required this.nodeId,
    required this.type,
    required this.position,
    this.data,
    this.connectionLimit = 500,
    GlobalKey? key,
  }) {
    this.id = id ?? UniqueKey().toString();
  }

  NodeSocketModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      nodeId = json["node_id"],
      connectionLimit = json["max_connections"],
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
      'max_connections': connectionLimit,
    };
  }

  NodeSocketModel copy() {
    return NodeSocketModel(
      id: id,
      nodeId: nodeId,
      type: type,
      position: position.copy(), // assuming Vector2 has copy()
      data: data, // shallow copy; consider deep copy if needed
      connectionLimit: connectionLimit,
    );
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
    this.id = id ?? DateTime.now().microsecondsSinceEpoch.toString();
    this.key = GlobalKey();
    this.position = position ?? Vector2.zero;
    this.inputSockets = inputSockets ?? [];
    this.outputSockets = outputSockets ?? [];
    if (this.inputSockets.isEmpty && this.outputSockets.isEmpty) {
      this.inputSockets.addAll([
        NodeSocketModel(
          nodeId: this.id,
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          type: NodeSocketType.input,
          position: Vector2.zero,
          data: {},
        ),
      ]);
      this.outputSockets.addAll([
        NodeSocketModel(
          nodeId: this.id,
          id: DateTime.now().microsecondsSinceEpoch.toString(),
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
        (json["output_sockets"] as List).map(
          (ns) => NodeSocketModel.fromJson(ns),
        ),
      ),
      inputSockets = List<NodeSocketModel>.from(
        (json["input_sockets"] as List).map(
          (ns) => NodeSocketModel.fromJson(ns),
        ),
      );

  Map<String, dynamic> toJson() {
    return {
      'position': {'x': position.x, 'y': position.y},
      'id': id,
      'input_sockets': inputSockets.map((s) => s.toJson()).toList(),
      'output_sockets': outputSockets.map((s) => s.toJson()).toList(),
    };
  }

  NodeModel<T> copy() {
    return NodeModel<T>(
      id: id,
      data: data,
      position: position.copy(), // assuming Vector2 has copy()
      inputSockets: inputSockets.map((s) => s.copy()).toList(),
      outputSockets: outputSockets.map((s) => s.copy()).toList(),
    );
  }
}
