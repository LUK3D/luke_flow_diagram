// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'edge_connections_model.dart';
import 'node_model.dart';

class FlowCanvasModel<T> {
  final List<NodeModel<T>> nodes;
  final List<EdgeConnectionsModel> connections;

  FlowCanvasModel({required this.nodes, required this.connections});

  FlowCanvasModel<T> copy() {
    return FlowCanvasModel<T>(
      nodes: nodes.map((node) => node.copy()).toList(),
      connections: connections.map((c) => c.copy()).toList(),
    );
  }

  FlowCanvasModel<T> copyWith({
    List<NodeModel<T>>? nodes,
    List<EdgeConnectionsModel>? connections,
  }) {
    return FlowCanvasModel<T>(
      nodes: nodes ?? this.nodes.map((n) => n.copy()).toList(),
      connections:
          connections ?? this.connections.map((c) => c.copy()).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nodes': nodes.map((x) => x.toJson()).toList(),
      'connections': connections.map((x) => x.toJson()).toList(),
    };
  }

  factory FlowCanvasModel.fromMap(Map<String, dynamic> map) {
    return FlowCanvasModel<T>(
      nodes: List<NodeModel<T>>.from(
        (map['nodes'] as List<Map<String, Object>>).map<NodeModel<T>>(
          (x) => NodeModel<T>.fromJson(x as Map<String, dynamic>),
        ),
      ),
      connections: List<EdgeConnectionsModel>.from(
        (map['connections'] as List<Map<String, Object>>)
            .map<EdgeConnectionsModel>(
              (x) => EdgeConnectionsModel.fromJson(x as Map<String, dynamic>),
            ),
      ),
    );
  }

  String toJsonString() => json.encode(toMap());

  factory FlowCanvasModel.fromJsonString(String source) =>
      FlowCanvasModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
