import 'package:flutter/material.dart';
import 'package:luke_flow_diagram/utils/math.dart';

enum NodeSocketType { input, output, inputOutput }

class NodeSocketModel<E> {
  late String id;
  final String nodeId;
  final NodeSocketType type;
  Vector2 position;
  E? data;
  final int connectionLimit;

  NodeSocketModel({
    String? id,
    required this.nodeId,
    required this.type,
    required this.position,
    this.data,
    this.connectionLimit = 500,
  }) {
    this.id = id ?? UniqueKey().toString();
  }

  factory NodeSocketModel.fromJson(
    Map<String, dynamic> json, {
    E? Function(Map<String, dynamic> json)? fromJsonE,
  }) {
    return NodeSocketModel<E>(
      id: json['id'],
      nodeId: json["node_id"],
      type: NodeSocketType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NodeSocketType.inputOutput,
      ),
      position: Vector2(json['position']['x'], json['position']['y']),
      data: fromJsonE != null && json['data'] != null
          ? fromJsonE(json['data'])
          : null,
      connectionLimit: json["max_connections"],
    );
  }

  Map<String, dynamic> toJson({
    Map<String, dynamic> Function(E data)? toJsonE,
  }) {
    return {
      'id': id,
      'node_id': nodeId,
      'type': type.name,
      'position': {'x': position.x, 'y': position.y},
      'max_connections': connectionLimit,
      if (data != null && toJsonE != null) 'data': toJsonE(data as E),
    };
  }

  NodeSocketModel<E> copy() {
    return NodeSocketModel<E>(
      id: id,
      nodeId: nodeId,
      type: type,
      position: position.copy(),
      data: data,
      connectionLimit: connectionLimit,
    );
  }
}

class NodeModel<T, E> {
  late Vector2 position;
  late String id;
  late GlobalKey key;
  final T? data;
  late List<NodeSocketModel<E>> inputSockets;
  late List<NodeSocketModel<E>> outputSockets;

  NodeModel({
    Vector2? position,
    String? id,
    this.data,
    List<NodeSocketModel<E>>? inputSockets,
    List<NodeSocketModel<E>>? outputSockets,
  }) {
    this.id = id ?? UniqueKey().toString();
    this.key = GlobalKey();
    this.position = position ?? Vector2.zero;
    this.inputSockets = inputSockets ?? [];
    this.outputSockets = outputSockets ?? [];
    if (this.inputSockets.isEmpty && this.outputSockets.isEmpty) {
      this.inputSockets.addAll([
        NodeSocketModel<E>(
          nodeId: this.id,
          id: UniqueKey().toString(),
          type: NodeSocketType.input,
          position: Vector2.zero,
        ),
      ]);
      this.outputSockets.addAll([
        NodeSocketModel<E>(
          nodeId: this.id,
          id: UniqueKey().toString(),
          type: NodeSocketType.output,
          position: Vector2.zero,
        ),
      ]);
    }
  }

  NodeModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      data = null,
      key = GlobalKey(),
      position = Vector2(json['position']['x'], json['position']['y']),
      outputSockets = List<NodeSocketModel<E>>.from(
        (json["output_sockets"] as List).map(
          (ns) => NodeSocketModel<E>.fromJson(ns),
        ),
      ),
      inputSockets = List<NodeSocketModel<E>>.from(
        (json["input_sockets"] as List).map(
          (ns) => NodeSocketModel<E>.fromJson(ns),
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

  NodeModel<T, E> copy() {
    return NodeModel<T, E>(
      id: id,
      data: data,
      position: position.copy(), // assuming Vector2 has copy()
      inputSockets: inputSockets.map((s) => s.copy()).toList(),
      outputSockets: outputSockets.map((s) => s.copy()).toList(),
    );
  }
}
