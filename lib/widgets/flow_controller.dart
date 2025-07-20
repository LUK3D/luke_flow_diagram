import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:luke_flow_diagram/luke_flow_diagram.dart';
import 'package:luke_flow_diagram/models/flow_canvas_model.dart';

class LukeFlowCanvasController<T> {
  /// Internal data storage and reactive notifier
  late ValueNotifier<FlowCanvasModel<T>> _notifier;

  LukeFlowCanvasController() {
    _notifier = ValueNotifier(FlowCanvasModel(nodes: [], connections: []));
    debugPrint("[LukeFlow] Controller initialized");
  }

  /// Exposes the current model
  FlowCanvasModel<T> get data => _notifier.value;

  /// Listen to value changes using ValueListenableBuilder
  ValueListenable<FlowCanvasModel<T>> get listenable => _notifier;

  final _viewerController = CustomInteractiveViewerController();

  CustomInteractiveViewerController get viewController => _viewerController;

  List<NodeModel<T>> get nodes => data.nodes;
  List<EdgeConnectionsModel> get connections => data.connections;
  final Map<String, GlobalKey> _socketKeys = {};

  final GlobalKey _canvasKey = GlobalKey();

  GlobalKey get canvasKey => _canvasKey;

  GlobalKey getOrCreateSocketKey(String socketId) {
    return _socketKeys.putIfAbsent(
      socketId,
      () => GlobalKey(debugLabel: socketId),
    );
  }

  void dispose() {
    _notifier.dispose();
  }

  /// Force trigger a UI update (e.g., after in-place mutation — avoid if possible)
  void update() {
    _notifier.value = _notifier.value.copy();
  }

  void setNodes(List<NodeModel<T>> nodes) {
    _notifier.value = data.copyWith(nodes: List<NodeModel<T>>.from(nodes));
  }

  void setConnections(List<EdgeConnectionsModel> connections) {
    _notifier.value = data.copyWith(
      connections: List<EdgeConnectionsModel>.from(connections),
    );
  }

  void addNodes(List<NodeModel<T>> newNodes) {
    _notifier.value = data.copyWith(nodes: [...data.nodes, ...newNodes]);
  }

  void addConnection(EdgeConnectionsModel connection) {
    _notifier.value = data.copyWith(
      connections: [...data.connections, connection],
    );
  }

  void removeConnectionWhere(bool Function(EdgeConnectionsModel) test) {
    _notifier.value = data.copyWith(
      connections: data.connections.where((e) => !test(e)).toList(),
    );
  }
}
