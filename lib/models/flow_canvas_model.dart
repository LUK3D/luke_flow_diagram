import 'node_model.dart';
import 'edge_connections_model.dart';

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
}
