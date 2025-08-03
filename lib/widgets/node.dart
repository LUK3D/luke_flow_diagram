import 'package:flutter/material.dart';
import 'package:luke_flow_diagram/models/node_model.dart';
import 'package:luke_flow_diagram/utils/math.dart';
import 'package:luke_flow_diagram/widgets/flow_controller.dart';

class NodeWidget<T, E> extends StatefulWidget {
  final NodeModel<T, E> node;
  final Widget Function(NodeModel<T, E> node) nodeBuilder;
  final Widget Function(NodeModel<T, E> node, NodeSocketModel<E> socket)?
  socketBuilder;
  final double socketWidth;
  final double socketHeight;
  final double socketRadius;
  final Function(NodeModel<T, E> node) onUpdate;
  final Function(NodeModel<T, E> node) onPanEnd;
  final Function(
    NodeSocketModel<E> socket,
    Offset details,
    NodeModel<T, E> node,
  )
  onSocketPanUpdate;
  final Function(
    NodeSocketModel<E> socket,
    Offset details,
    NodeModel<T, E> node,
  )
  onSocketPanEnd;
  final Function(
    NodeSocketModel<E> socket,
    Offset details,
    NodeModel<T, E> node,
  )
  onSocketPanStart;
  final Function(
    NodeSocketModel<E> socket,
    Offset details,
    NodeModel<T, E> node,
  )
  onSocketMouseEnter;
  final Function(
    NodeSocketModel<E> socket,
    Offset details,
    NodeModel<T, E> node,
  )
  onSocketMouseLeave;
  final LukeFlowCanvasController controller;

  const NodeWidget({
    super.key,
    required this.node,
    required this.nodeBuilder,
    this.socketBuilder,
    required this.socketWidth,
    required this.socketHeight,
    required this.socketRadius,
    required this.onUpdate,
    required this.onSocketPanUpdate,
    required this.onSocketMouseEnter,
    required this.onSocketMouseLeave,
    required this.onSocketPanEnd,
    required this.onSocketPanStart,
    required this.onPanEnd,
    required this.controller,
  });

  @override
  State<NodeWidget<T, E>> createState() => _NodeWidgetState<T, E>();
}

class _NodeWidgetState<T, E> extends State<NodeWidget<T, E>> {
  late Vector2 position;

  Widget makeSockets(NodeSocketType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.node.inputSockets
          .followedBy(widget.node.outputSockets)
          .where((s) => s.type == type)
          .map((socket) {
            return GestureDetector(
              key: ValueKey("socket-gesture-detector-${socket.id}"),
              onPanStart: (details) {
                socket.position = Vector2(
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                );

                widget.onSocketPanStart(
                  socket,
                  details.globalPosition,
                  widget.node,
                );
              },
              onPanEnd: (details) {
                widget.onSocketPanEnd(
                  socket,
                  details.globalPosition,
                  widget.node,
                );
              },
              onPanUpdate: (details) {
                widget.onSocketPanUpdate(
                  socket,
                  details.globalPosition,
                  widget.node,
                );
              },
              child: SizedBox(
                width: widget.socketWidth,
                height: widget.socketHeight,
                child: MouseRegion(
                  key: UniqueKey(),
                  onEnter: (event) {
                    widget.onSocketMouseEnter(
                      socket,
                      Offset(socket.position.x, socket.position.y),
                      widget.node,
                    );
                  },
                  onExit: (event) {
                    widget.onSocketMouseLeave(
                      socket,
                      Offset(socket.position.x, socket.position.y),
                      widget.node,
                    );
                  },
                  child:
                      widget.socketBuilder?.call(widget.node, socket) ??
                      Container(
                        key: widget.controller.getOrCreateSocketKey(socket.id),
                        width: widget.socketWidth,
                        height: widget.socketHeight,
                        decoration: BoxDecoration(
                          color: socket.type == NodeSocketType.output
                              ? Colors.pink
                              : Colors.purple,
                          borderRadius: BorderRadius.circular(
                            widget.socketRadius,
                          ),
                        ),
                      ),
                ),
              ),
            );
          })
          .toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    position = widget.node.position;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.x,
      top: position.y,
      key: widget.node.key,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position = position.add(
              Vector2(details.delta.dx, details.delta.dy),
            );
          });
          widget.node.position = position;
          widget.onUpdate(widget.node);
        },
        onPanEnd: (details) {
          widget.onPanEnd(widget.node);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(widget.socketWidth / 2),
              child: widget.nodeBuilder(widget.node),
            ),
            Positioned(left: 0, child: makeSockets(NodeSocketType.input)),
            Positioned(right: 0, child: makeSockets(NodeSocketType.output)),
          ],
        ),
      ),
    );
  }
}
