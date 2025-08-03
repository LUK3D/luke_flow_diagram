// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'edge_connections_model.dart';
import 'node_model.dart';

class FlowCanvasModel<T, E> {
  final List<NodeModel<T>> nodes;
  final List<EdgeConnectionsModel<E>> connections;

  FlowCanvasModel({required this.nodes, required this.connections});

  FlowCanvasModel<T, E> copy() {
    return FlowCanvasModel<T, E>(
      nodes: nodes.map((node) => node.copy()).toList(),
      connections: List<EdgeConnectionsModel<E>>.from(
        connections.map((c) => c.copy()).toList(),
      ),
    );
  }

  FlowCanvasModel<T, E> copyWith({
    List<NodeModel<T>>? nodes,
    List<EdgeConnectionsModel>? connections,
  }) {
    return FlowCanvasModel<T, E>(
      nodes: nodes ?? this.nodes.map((n) => n.copy()).toList(),
      connections: List<EdgeConnectionsModel<E>>.from(
        connections ?? this.connections.map((c) => c.copy()).toList(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nodes': nodes.map((x) => x.toJson()).toList(),
      'connections': connections.map((x) => x.toJson()).toList(),
    };
  }

  factory FlowCanvasModel.fromMap(Map<String, dynamic> map) {
    return FlowCanvasModel<T, E>(
      nodes: List<NodeModel<T>>.from(
        (map['nodes'] as List<Map<String, Object>>).map<NodeModel<T>>(
          (x) => NodeModel<T>.fromJson(x as Map<String, dynamic>),
        ),
      ),
      connections: List<EdgeConnectionsModel<E>>.from(
        (map['connections'] as List<Map<String, Object>>)
            .map<EdgeConnectionsModel<E>>(
              (x) => EdgeConnectionsModel.fromJson(x as Map<String, dynamic>),
            ),
      ),
    );
  }

  String toJsonString() => json.encode(toMap());

  factory FlowCanvasModel.fromJsonString(String source) =>
      FlowCanvasModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
