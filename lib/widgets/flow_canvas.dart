import 'package:flutter/material.dart';
import 'package:luke_flow_diagram/models/edge_connections_model.dart';
import 'package:luke_flow_diagram/models/grid_background_settings.dart';
import 'package:luke_flow_diagram/models/node_model.dart';
import 'package:luke_flow_diagram/utils/math.dart';
import 'package:luke_flow_diagram/widgets/edge.dart';
import 'custom_interactive_viewer.dart';
import 'grid_painter.dart';
import 'node.dart';

/// A customizable flow canvas widget for creating node-based diagrams.
///
/// [LukeFlowCanvas] supports draggable nodes, connectable sockets,
/// and visualizes connections between nodes using Bezier curves.
class LukeFlowCanvas<T> extends StatefulWidget {
  /// The controller to interact with the canvas programmatically.
  final LukeFlowCanvasController<T>? controller;

  /// The list of initial nodes to be rendered on the canvas.
  final List<NodeModel<T>> nodes;

  /// The list of initial edge connections between nodes.
  final List<EdgeConnectionsModel> initialConnections;

  /// Builds a custom widget for each node.
  final Widget Function(NodeModel<T> node) nodeBuilder;

  /// Optionally builds a custom widget for each socket of a node.
  final Widget Function(NodeModel<T> node, NodeSocketModel socket)?
  socketBuilder;

  final Function(Vector2 position)? onMouseMove;

  /// Width of the canvas.
  final double width;

  /// Height of the canvas.
  final double height;

  /// Callback triggered whenever nodes or connections are updated.
  final Function(
    List<NodeModel<T>> nodes,
    List<EdgeConnectionsModel> connections,
  )?
  onUpdate;

  /// The width of each socket widget.
  final double socketWidth;

  /// The height of each socket widget.
  final double socketHeight;

  /// The radius of each socket (used for detecting interactions).
  final double socketRadius;

  /// Settings for the backgrouind grid
  final BackgroundGridSettings? bacgrkoundGridSettings;

  /// Handles connection error
  final Function(EdgeConnectionsModel connection)? onConnectionError;

  /// Occurs when an edge is droped on the canvas without a target
  final Function(NodeSocketModel source, Vector2 dropPosition)? onEdgeDrop;

  const LukeFlowCanvas({
    super.key,
    required this.nodes,
    required this.nodeBuilder,
    this.controller,
    this.socketBuilder,
    this.socketWidth = 20,
    this.socketHeight = 20,
    this.socketRadius = 100,
    this.initialConnections = const [],
    this.onUpdate,
    this.width = 2024 * 5,
    this.height = 2024 * 5,
    this.onMouseMove,
    this.bacgrkoundGridSettings,
    this.onConnectionError,
    this.onEdgeDrop,
  });

  @override
  State<LukeFlowCanvas<T>> createState() => _LukeFlowCanvasState<T>();
}

/// The internal state for [LukeFlowCanvas].
///
/// Handles canvas rendering, user interactions,
/// edge drawing, and node/socket updates.
class _LukeFlowCanvasState<T> extends State<LukeFlowCanvas<T>> {
  late List<EdgeConnectionsModel> connections = widget.initialConnections;
  NodeSocketModel? initialSlot;
  NodeSocketModel? hoveringSlot;
  NodeSocketModel? ghostSlot;
  GlobalKey canvasKey = GlobalKey();
  RenderBox? canvasBox;
  late final TransformationController _transformationController;
  late List<NodeModel<T>> nodes = widget.nodes;

  final viewerController = CustomInteractiveViewerController();
  Vector2 mousePositionRelativeToCanvas = Vector2.zero;

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
    setState(() {
      updateNodesPosition(nodes);
    });

    _transformationController = TransformationController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This runs after the first frame is rendered
      centerCanvas();
    });
  }

  @override
  void dispose() {
    widget.controller?._detach();
    super.dispose();
  }

  centerCanvas() {
    canvasBox = canvasKey.currentContext?.findRenderObject() as RenderBox?;
    final size = context.size;
    if (size != null) {
      final canvasSize = Size(widget.width, widget.height);
      final dx = (size.width - canvasSize.width) / 2;
      final dy = (size.height - canvasSize.height) / 2;

      _transformationController.value = Matrix4.identity()..translate(dx, dy);
    }
  }

  createConnection(NodeSocketModel socket, NodeModel<T> node) {
    final previousConnectionsInput = connections
        .where(
          (c) =>
              (c.source.id == socket.id || c.target.id == socket.id) &&
              c.data != "luke-ghost-socket",
        )
        .toList();
    final previousConnectionsOutput = connections
        .where(
          (c) =>
              (c.source.id == initialSlot!.id ||
                  c.target.id == initialSlot!.id) &&
              c.data != "luke-ghost-socket",
        )
        .toList();

    final connection = EdgeConnectionsModel(
      source: initialSlot!,
      target: socket,
    );

    if ((previousConnectionsInput.length) >= socket.connectionLimit) {
      widget.onConnectionError?.call(connection);
      return;
    }

    /// Remove 1 because when dragi
    if ((previousConnectionsOutput.length - 1) >=
        initialSlot!.connectionLimit) {
      widget.onConnectionError?.call(connection);
      return;
    }

    setState(() {
      connections.add(connection);
    });
    updateNodesPosition([node]);
  }

  setCustomState(Function actin) {
    setState(() {
      actin();
    });
  }

  Vector2? getWidgetPosition(GlobalKey key) {
    final context = key.currentContext;
    final box = context?.findRenderObject() as RenderBox?;

    if (box != null && canvasBox != null) {
      final global = box.localToGlobal(Offset.zero);
      final local = canvasBox!.globalToLocal(global); // relative to canvas
      return Vector2(local.dx, local.dy + widget.socketHeight / 2);
    }

    return null;
  }

  updateNodesPosition(List<NodeModel<T>> nodes) {
    for (var node in nodes) {
      if (connections.isEmpty) {
        return;
      }
      setState(() {
        connections = connections.map((c) {
          for (var s in node.inputSockets.followedBy(node.outputSockets)) {
            final value = getWidgetPosition(s.key);
            if ((c.source.id.contains(s.id) && value != null)) {
              c.source.position = value;
            }
            if ((c.target.id.contains(s.id) && value != null)) {
              c.target.position = value;
            }
          }
          return c;
        }).toList();
      });
    }

    widget.onUpdate?.call(nodes, connections);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        if (canvasBox != null) {
          final localPosition = canvasBox!.globalToLocal(event.position);
          mousePositionRelativeToCanvas = Vector2(
            localPosition.dx,
            localPosition.dy,
          );
          widget.onMouseMove?.call(mousePositionRelativeToCanvas);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.center,
          children: [
            BackgroundGrid(
              settings:
                  widget.bacgrkoundGridSettings ??
                  BackgroundGridSettings(
                    xDensity: 15.0,
                    yDensity: 15.0,
                    showLines: false,
                    showDots: true,
                    dotColor: Colors.grey.withAlpha(50),
                  ),
            ),
            CustomInteractiveViewer(
              constrained: false,
              controller: viewerController,
              minScale: 0.2,
              maxScale: 4,
              initialScale: 1.0,
              boundaryMargin: const EdgeInsets.all(double.infinity),
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                    width: 4,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
                child: Stack(
                  key: canvasKey,
                  alignment: Alignment.center,
                  fit: StackFit.passthrough,
                  children: [
                    ...connections.map((c) {
                      return BezierEdge(
                        source: Offset(
                          c.source.position.x,
                          c.source.position.y,
                        ),
                        target: Offset(
                          c.target.position.x,
                          c.target.position.y,
                        ),
                        isDashed: true,
                        color: Colors.blue,
                      );
                    }),
                    ...nodes.map((node) {
                      return NodeWidget(
                        node: node,
                        nodeBuilder: widget.nodeBuilder,
                        socketWidth: widget.socketWidth,
                        socketHeight: widget.socketHeight,
                        socketRadius: widget.socketRadius,
                        socketBuilder: widget.socketBuilder,
                        onUpdate: (node) {
                          updateNodesPosition([node]);
                        },
                        onSocketPanUpdate: (socket, details, node) {
                          if (ghostSlot != null) {
                            setState(() {
                              if (canvasBox != null) {
                                final local = canvasBox!.globalToLocal(
                                  details,
                                ); // relative to canvas

                                ghostSlot!.position = Vector2(
                                  local.dx,
                                  local.dy,
                                );
                              }
                            });
                          }
                        },
                        onSocketPanEnd: (socket, details, node) {
                          if (hoveringSlot != null &&
                              initialSlot != null &&
                              hoveringSlot?.id != initialSlot?.id) {
                            final pos = getWidgetPosition(hoveringSlot!.key);
                            if (pos != null) {
                              hoveringSlot!.position = pos;
                            }
                            createConnection(hoveringSlot!, node);
                          }

                          if (hoveringSlot == null &&
                              initialSlot != null &&
                              ghostSlot != null) {
                            final position = ghostSlot!.position;
                            Future.delayed(Duration(milliseconds: 100), () {
                              widget.onEdgeDrop?.call(initialSlot!, position);
                              initialSlot = null;
                            });
                          } else {
                            initialSlot = null;
                          }

                          //Remove ghost slot
                          setState(() {
                            connections.removeWhere((e) {
                              return e.target.id == ghostSlot?.id;
                            });
                          });
                          ghostSlot = null;
                        },
                        onSocketPanStart: (socket, details, node) {
                          initialSlot = socket;

                          ghostSlot = NodeSocketModel(
                            nodeId: node.id,
                            type: NodeSocketType.inputOutput,
                            position: Vector2(details.dx, details.dy),
                            data: "luke-ghost-socket",
                          );

                          if (canvasBox != null) {
                            final local = canvasBox!.globalToLocal(
                              details,
                            ); // relative to canvas

                            initialSlot!.position = Vector2(
                              local.dx,
                              local.dy + widget.socketHeight / 2,
                            );
                            ghostSlot!.position = initialSlot!.position;
                          }
                          createConnection(ghostSlot!, node);
                        },
                        onSocketMouseEnter: (socket, details, node) {
                          hoveringSlot = socket;
                        },
                        onSocketMouseLeave: (socket, details, node) {
                          hoveringSlot = null;
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Controller class for interacting with [LukeFlowCanvas] programmatically.
///
/// Allows external actions such as centering, adding/removing nodes or edges,
/// and exporting/importing canvas state.
class LukeFlowCanvasController<T> {
  _LukeFlowCanvasState<T>? _state;

  void _attach(_LukeFlowCanvasState<T> state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  void centerCanvas() {
    _state?.viewerController.center();
  }

  void updateNodesPosition(List<NodeModel<T>> nodes) {
    _state?.updateNodesPosition(nodes);
  }

  void addConnection(EdgeConnectionsModel connection) {
    _state?.setCustomState(() {
      _state?.connections.add(connection);
    });
  }

  void addConnections(List<EdgeConnectionsModel> connections) {
    _state?.setCustomState(() {
      _state?.connections.addAll(connections);
    });
  }

  void addNode(NodeModel<T> node) {
    _state?.setCustomState(() {
      _state?.nodes.add(node);
    });
  }

  void addNodes(List<NodeModel<T>> nodes) {
    _state?.setCustomState(() {
      _state?.nodes.addAll(nodes);
    });
  }

  void removeConnection(String sourceId, String targetId) {
    _state?.setCustomState(() {
      _state?.connections.removeWhere(
        (c) => c.source.id == sourceId && c.target.id == targetId,
      );
    });
  }

  void removeConnectionById(String id) {
    _state?.setCustomState(() {
      _state?.connections.removeWhere((c) => c.id == id);
    });
  }

  void removeNodeById(String nodeId) {
    _state?.setCustomState(() {
      _state!.nodes = _state!.nodes.where((n) => n.id != nodeId).toList();
      _state!.connections = _state!.connections.where((c) {
        return c.source.nodeId != nodeId || c.target.nodeId != nodeId;
      }).toList();
    });
  }

  void clear() {
    _state?.setCustomState(() {
      _state!.nodes = [];
      _state!.connections = [];
    });
  }

  Map<String, dynamic> toJson() {
    return {
      "nodes": this.nodes.map((e) => e.toJson()).toList(),
      "connections": this.connections.map((e) => e.toJson()).toList(),
    };
  }

  void fromJson(Map<String, dynamic> json) {
    clear();
    Future.delayed(Duration(milliseconds: 100), () {
      addNodes(
        List<NodeModel<T>>.from(
          (json["nodes"] as List<Map<String, dynamic>>).map(
            (n) => NodeModel<T>.fromJson(n),
          ),
        ).toList(),
      );
      addConnections(
        List<EdgeConnectionsModel>.from(
          (json["connections"] as List).map(
            (n) => EdgeConnectionsModel.fromJson(n),
          ),
        ).toList(),
      );
    });
  }

  List<EdgeConnectionsModel> get connections => _state?.connections ?? [];

  List<NodeModel<T>> get nodes => _state?.nodes ?? [];

  void setTransformation(Matrix4 matrix) {
    _state?._transformationController.value = matrix;
  }

  Matrix4? getTransformation() {
    return _state?._transformationController.value;
  }
}
