import 'package:flutter/material.dart';
import 'package:luke_flow_diagram/models/edge_connections_model.dart';
import 'package:luke_flow_diagram/models/grid_background_settings.dart';
import 'package:luke_flow_diagram/models/node_model.dart';
import 'package:luke_flow_diagram/utils/math.dart';
import 'package:luke_flow_diagram/widgets/edge.dart';
import 'package:luke_flow_diagram/widgets/edges/bezier.dart';
import 'package:luke_flow_diagram/widgets/edges/step.dart';
import 'custom_interactive_viewer.dart';
import 'flow_controller.dart';
import 'grid_painter.dart';
import 'node.dart';

/// A customizable flow canvas widget for creating node-based diagrams.
///
/// [LukeFlowCanvas] supports draggable nodes, connectable sockets,
/// and visualizes connections between nodes using Bezier curves.
class LukeFlowCanvas<T, E> extends StatefulWidget {
  /// The controller to interact with the canvas programmatically.
  final LukeFlowCanvasController<T, E> controller;

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

  /// Settings for the backgrouind grid
  final BackgroundGridSettings? secondaryBacgrkoundGridSettings;

  /// Handles connection error
  final Function(EdgeConnectionsModel connection)? onConnectionError;

  /// Occurs when an edge is droped on the canvas without a target
  final Function(NodeSocketModel source, Vector2 dropPosition)? onEdgeDrop;

  final Function(List<NodeModel<T>> deletedNode)? onNodesDeleted;

  /// Triggered when user double taps the canvas
  final Function(Vector2 mousePosition)? onDoubleTap;

  /// Callback triggered before a connection is created.
  /// It allows modifying the connection or returning null to cancel it.
  final EdgeConnectionsModel<E>? Function(
    EdgeConnectionsModel<E> connection,
    NodeSocketModel inputSocker,
    NodeSocketModel outputSocket,
  )?
  onBeforeConnectionCreate;

  final LukeEdgePainter Function(
    Offset source,
    Offset target,
    EdgeConnectionsModel edgeConnection,
  )?
  edgeBuilder;

  const LukeFlowCanvas({
    super.key,
    required this.controller,
    required this.nodeBuilder,
    this.socketBuilder,
    this.edgeBuilder,
    this.socketWidth = 20,
    this.socketHeight = 20,
    this.socketRadius = 100,
    this.onUpdate,
    this.width = 2024 * 8,
    this.height = 2024 * 8,
    this.onMouseMove,
    this.bacgrkoundGridSettings,
    this.secondaryBacgrkoundGridSettings,
    this.onConnectionError,
    this.onEdgeDrop,
    this.onNodesDeleted,
    this.onDoubleTap,
    this.onBeforeConnectionCreate,
  });

  @override
  State<LukeFlowCanvas<T, E>> createState() => _LukeFlowCanvasState<T, E>();
}

/// The internal state for [LukeFlowCanvas].
///
/// Handles canvas rendering, user interactions,
/// edge drawing, and node/socket updates.
class _LukeFlowCanvasState<T, E> extends State<LukeFlowCanvas<T, E>> {
  NodeSocketModel? initialSlot;
  NodeSocketModel? hoveringSlot;
  NodeSocketModel? ghostSlot;

  RenderBox? canvasBox;
  late final TransformationController _transformationController;
  EdgeConnectionsModel<E>? ghostConnection;
  late List<EdgeConnectionsModel<E>> _renderedConnections;

  Vector2 mousePositionRelativeToCanvas = Vector2.zero;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();

    _renderedConnections = widget.controller.connections;

    widget.controller.listenable.addListener(() {
      setState(() {
        _renderedConnections = widget.controller.connections;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        updateNodesPosition(widget.controller.nodes);
      });
      centerCanvas();
    });
  }

  centerCanvas() {
    canvasBox =
        widget.controller.canvasKey.currentContext?.findRenderObject()
            as RenderBox?;
    final size = context.size;
    if (size != null) {
      final canvasSize = Size(widget.width, widget.height);
      final dx = (size.width - canvasSize.width) / 2;
      final dy = (size.height - canvasSize.height) / 2;

      _transformationController.value = Matrix4.identity()..translate(dx, dy);
    }
  }

  createConnection(NodeSocketModel socket, NodeModel<T> node) {
    final controller = widget.controller;

    EdgeConnectionsModel<E> connection = EdgeConnectionsModel<E>(
      source: initialSlot!,
      target: socket,
    );

    final inputConnections = controller.connections.where(
      (c) =>
          (c.source.id == socket.id || c.target.id == socket.id) &&
          c.data != "luke-ghost-socket",
    );

    final outputConnections = controller.connections.where(
      (c) =>
          (c.source.id == initialSlot!.id || c.target.id == initialSlot!.id) &&
          c.data != "luke-ghost-socket",
    );

    if (inputConnections.length >= socket.connectionLimit ||
        outputConnections.length >= initialSlot!.connectionLimit - 1) {
      widget.onConnectionError?.call(connection);
      debugPrint("Connection Error!!");
      return;
    }

    if (widget.onBeforeConnectionCreate != null) {
      final result = widget.onBeforeConnectionCreate!(
        connection,
        initialSlot!,
        socket,
      );
      if (result == null) {
        return;
      }

      connection = result;
    }

    final updatedConnections = [...controller.connections, connection];

    controller.setConnections(updatedConnections);
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
      final local = canvasBox!.globalToLocal(global);
      return Vector2(local.dx, local.dy + widget.socketHeight / 2);
    }

    return null;
  }

  updateNodesPosition(List<NodeModel<T>> nodes) {
    if (_renderedConnections.isEmpty) return;

    final updated = _renderedConnections.map((c) {
      for (var node in nodes) {
        for (var s in node.inputSockets.followedBy(node.outputSockets)) {
          final value = getWidgetPosition(
            widget.controller.getOrCreateSocketKey(s.id),
          );
          if (c.source.id == s.id && value != null) {
            c.source.position = value;
          }
          if (c.target.id == s.id && value != null) {
            c.target.position = value;
          }
        }
      }
      return c;
    }).toList();

    setState(() {
      _renderedConnections = updated;
    });

    widget.onUpdate?.call(nodes, _renderedConnections);
  }

  bool clicking = false;
  checkDoubleClick() {
    if (clicking) {
      widget.onDoubleTap?.call(mousePositionRelativeToCanvas);
      clicking = false;
    }

    Future.delayed(Duration(milliseconds: 250), () {
      clicking = false;
    });
    clicking = true;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller.listenable,
      builder: (context, data, _) {
        return Scaffold(
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
              if (widget.secondaryBacgrkoundGridSettings != null)
                BackgroundGrid(
                  settings: widget.secondaryBacgrkoundGridSettings!,
                ),
              CustomInteractiveViewer(
                key: widget.controller.getOrCreateSocketKey(
                  "custom-interactive-view",
                ),
                constrained: false,
                controller: widget.controller.viewController,
                minScale: 0.2,
                maxScale: 4,
                initialScale: 1.0,
                behavior: HitTestBehavior.translucent,
                onPointerUp: (_) {
                  checkDoubleClick();
                },
                onPointerHover: (event) {
                  if (canvasBox != null) {
                    final localPosition = canvasBox!.globalToLocal(
                      event.position,
                    );
                    mousePositionRelativeToCanvas = Vector2(
                      localPosition.dx,
                      localPosition.dy,
                    );
                    widget.onMouseMove?.call(mousePositionRelativeToCanvas);
                  }
                },
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
                    key: widget.controller.canvasKey,
                    alignment: Alignment.center,
                    fit: StackFit.passthrough,
                    children: [
                      if (ghostConnection != null && ghostSlot != null)
                        BezierEdge(
                          source: ghostConnection!.source,
                          target: ghostConnection!.target,
                          painterBuilder: (source, target, _, _) {
                            return ghostConnection!.painter ??
                                LukeEdgePainter(
                                  source: source,
                                  target: target,
                                  isDashed: true,
                                  color: Colors.blue,
                                  strokeWidth: 4,
                                );
                          },
                        ),

                      ..._renderedConnections.map((c) {
                        return BezierEdge(
                          source: c.source,
                          target: c.target,
                          isAnimated: c.isAnimated,
                          dashAnimationSpeed: c.animationSpeed,
                          painterBuilder:
                              (source, target, isAnimated, dashOffset) {
                                return widget.edgeBuilder?.call(
                                      source,
                                      target,
                                      c,
                                    ) ??
                                    c.painter ??
                                    LukeStepEdgePainter(
                                      source: source,
                                      target: target,
                                      isDashed: true,
                                      color: Colors.pink,
                                      strokeWidth: 4,
                                      horizontalStepPercent: 0.7,
                                      cornerRadius: 30,
                                      isAnimated: c.isAnimated,
                                      dashAnimationSpeed: c.animationSpeed,
                                      dashOffset: dashOffset,
                                    );
                              },
                        );
                      }),

                      ...data.nodes.map((node) {
                        return NodeWidget(
                          controller: widget.controller,
                          key: ValueKey("node-${node.id}"),
                          node: node,
                          nodeBuilder: widget.nodeBuilder,
                          socketWidth: widget.socketWidth,
                          socketHeight: widget.socketHeight,
                          socketRadius: widget.socketRadius,
                          socketBuilder: widget.socketBuilder,
                          onUpdate: (node) {
                            updateNodesPosition([node]);
                          },
                          onPanEnd: (node) {
                            widget.controller.setConnections(
                              _renderedConnections,
                            );
                          },
                          onSocketPanUpdate: (socket, details, node) {
                            if (ghostSlot != null) {
                              setState(() {
                                if (canvasBox != null) {
                                  final local = canvasBox!.globalToLocal(
                                    details,
                                  );

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
                                hoveringSlot!.id != initialSlot!.id) {
                              final pos = getWidgetPosition(
                                widget.controller.getOrCreateSocketKey(
                                  hoveringSlot!.id,
                                ),
                              );
                              if (pos != null) {
                                hoveringSlot!.position = pos;
                              }

                              ghostSlot = null;
                              createConnection(hoveringSlot!, node);
                            } else if (hoveringSlot == null &&
                                initialSlot != null &&
                                ghostSlot != null) {
                              final position = ghostSlot!.position;

                              final tmpInicialSlot = initialSlot;

                              Future.delayed(Duration(milliseconds: 100), () {
                                widget.onEdgeDrop?.call(
                                  tmpInicialSlot!,
                                  position,
                                );
                                initialSlot = null;
                              });
                            }

                            // Cleanup
                            initialSlot = null;
                            ghostSlot = null;
                            setState(() {});
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
                              final local = canvasBox!.globalToLocal(details);

                              initialSlot!.position = Vector2(
                                local.dx,
                                local.dy,
                              );
                              ghostSlot!.position = initialSlot!.position;
                            }
                            setState(() {
                              ghostConnection = EdgeConnectionsModel(
                                source: ghostSlot!,
                                target: initialSlot!,
                              );
                            });
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
        );
      },
    );
  }
}
