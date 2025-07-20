import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:luke_flow_diagram/luke_flow_diagram.dart';
import 'package:luke_flow_diagram/models/flow_canvas_model.dart';

/// A controller for managing the state and interactions of a LukeFlow canvas.
class LukeFlowCanvasController<T> {
  late ValueNotifier<FlowCanvasModel<T>> _notifier;

  /// # LukeFlowCanvasController
  /// Creates a new [LukeFlowCanvasController] instance.
  LukeFlowCanvasController() {
    _notifier = ValueNotifier(FlowCanvasModel(nodes: [], connections: []));
    debugPrint("[LukeFlow] Controller initialized");
  }

  /// # data
  /// The current canvas data (nodes and connections).
  FlowCanvasModel<T> get data => _notifier.value;

  /// # listenable
  /// A listenable that notifies changes to the canvas data.
  ValueListenable<FlowCanvasModel<T>> get listenable => _notifier;

  final _viewerController = CustomInteractiveViewerController();

  /// # viewController
  /// Controller for interacting with the canvas view (pan/zoom).
  CustomInteractiveViewerController get viewController => _viewerController;

  /// # nodes
  /// The list of current nodes in the canvas.
  List<NodeModel<T>> get nodes => data.nodes;

  /// # connections
  /// The list of current connections in the canvas.
  List<EdgeConnectionsModel> get connections => data.connections;

  final Map<String, GlobalKey> _socketKeys = {};

  final GlobalKey _canvasKey = GlobalKey();

  /// # canvasKey
  /// Returns the global key of the canvas widget.
  GlobalKey get canvasKey => _canvasKey;

  /// # getOrCreateSocketKey
  /// Returns an existing or newly created [GlobalKey] for a given socket ID.
  GlobalKey getOrCreateSocketKey(String socketId) {
    return _socketKeys.putIfAbsent(
      socketId,
      () => GlobalKey(debugLabel: socketId),
    );
  }

  /// # dispose
  /// Disposes internal resources used by the controller.
  void dispose() {
    _notifier.dispose();
  }

  /// # update
  /// Forces a state update using the current canvas data.
  void update() {
    _notifier.value = _notifier.value.copy();
  }

  /// # setNodes
  /// Replaces the current nodes with a new list.
  void setNodes(List<NodeModel<T>> nodes) {
    _notifier.value = data.copyWith(nodes: List<NodeModel<T>>.from(nodes));
  }

  /// # setConnections
  /// Replaces the current connections with a new list.
  void setConnections(List<EdgeConnectionsModel> connections) {
    _notifier.value = data.copyWith(
      connections: List<EdgeConnectionsModel>.from(connections),
    );
  }

  /// # addNodes
  /// Adds a list of nodes to the current canvas.
  void addNodes(List<NodeModel<T>> newNodes) {
    _notifier.value = data.copyWith(nodes: [...data.nodes, ...newNodes]);
  }

  /// # addConnection
  /// Adds a single connection to the canvas.
  void addConnection(EdgeConnectionsModel connection) {
    _notifier.value = data.copyWith(
      connections: [...data.connections, connection],
    );
  }

  /// # removeConnectionWhere
  /// Removes all connections that satisfy the given condition.
  void removeConnectionWhere(bool Function(EdgeConnectionsModel) test) {
    _notifier.value = data.copyWith(
      connections: data.connections.where((e) => !test(e)).toList(),
    );
  }

  /// # removeNodeWhere
  /// Removes all nodes that satisfy the given condition.
  void removeNodeWhere(bool Function(NodeModel) test) {
    _notifier.value = data.copyWith(
      nodes: data.nodes.where((e) => !test(e)).toList(),
    );
  }

  /// # clear
  /// Clears all nodes and connections from the canvas.
  void clear() {
    _notifier.value = data.copyWith(nodes: [], connections: []);
  }

  /// # loadFromJson
  /// Loads canvas data from a decoded JSON map.
  void loadFromJson(Map<String, dynamic> data) {
    _notifier.value = FlowCanvasModel<T>.fromMap(data);
    frame();
  }

  /// # loadFromJsonString
  /// Loads canvas data from a JSON string.
  void loadFromJsonString(String data) {
    _notifier.value = FlowCanvasModel<T>.fromJsonString(data);
    frame();
  }

  /// # toJson
  /// Exports the current canvas data as a JSON map.
  Map<String, dynamic> toJson() {
    return _notifier.value.toMap();
  }

  /// # toJsonString
  /// Exports the current canvas data as a JSON string.
  String toJsonString() {
    return _notifier.value.toJsonString();
  }

  /// # frame
  /// Animates the viewport to fit all nodes within view, including zooming out if necessary.
  void frame({
    double padding = 200.0,
    Duration? animationDuration,
    Curve curve = Curves.easeInOut,
  }) {
    if (nodes.isEmpty || viewController.viewportSize == null) return;

    final viewportSize = viewController.viewportSize!;

    // Compute the bounding box of all nodes
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (var node in nodes) {
      final pos = node.position.toOffset();
      if (pos.dx < minX) minX = pos.dx;
      if (pos.dy < minY) minY = pos.dy;
      if (pos.dx > maxX) maxX = pos.dx;
      if (pos.dy > maxY) maxY = pos.dy;
    }

    final contentWidth = maxX - minX;
    final contentHeight = maxY - minY;

    // Compute scale to fit the bounding box into the viewport
    final scaleX = (viewportSize.width - padding * 2) / contentWidth;
    final scaleY = (viewportSize.height - padding * 2) / contentHeight;
    final targetScale = scaleX < scaleY ? scaleX : scaleY;

    // Clamp to min/max zoom
    final clampedScale = targetScale.clamp(
      viewController.mimZoomLevel,
      viewController.maxZoomLevel,
    );

    // Compute center of the bounding box
    final center = Offset(minX + contentWidth / 2, minY + contentHeight / 2);

    // Compute the offset to center the bounding box
    final newOffset =
        -center * clampedScale +
        Offset(viewportSize.width / 2, viewportSize.height / 2);

    viewController.animateZoomAndPanTo(
      targetOffset: newOffset,
      targetZoom: clampedScale,
      duration: animationDuration ?? const Duration(milliseconds: 400),
      curve: curve,
    );
  }

  /// # updateConnection
  updateConnection(EdgeConnectionsModel edgeConnection) {
    _notifier.value = data.copyWith(
      connections: List<EdgeConnectionsModel>.from(
        data.connections
            .map((c) => c.id == edgeConnection.id ? edgeConnection : c)
            .toList(),
      ),
    );
    update();
  }

  /// # updateNode
  updateNode(NodeModel node) {
    _notifier.value = data.copyWith(
      nodes: List<NodeModel<T>>.from(
        data.nodes.map((n) => n.id == node.id ? node : n).toList(),
      ),
    );
  }
}
