import 'package:flutter/material.dart';
import 'package:luke_flow_diagram/models/node_model.dart';
import 'package:luke_flow_diagram/utils/math.dart';

class NodeWidget<T> extends StatefulWidget {
  final NodeModel<T> node;
  final Widget Function(NodeModel<T> node) nodeBuilder;
  final Widget Function(NodeModel<T> node, NodeSocketModel socket)?
  socketBuilder;
  final double socketWidth;
  final double socketHeight;
  final double socketRadius;
  final Function(NodeModel<T> node) onUpdate;
  final Function(NodeSocketModel socket, Offset details, NodeModel<T> node)
  onSocketPanUpdate;
  final Function(NodeSocketModel socket, Offset details, NodeModel<T> node)
  onSocketPanEnd;
  final Function(NodeSocketModel socket, Offset details, NodeModel<T> node)
  onSocketPanStart;
  final Function(NodeSocketModel socket, Offset details, NodeModel<T> node)
  onSocketMouseEnter;
  final Function(NodeSocketModel socket, Offset details, NodeModel<T> node)
  onSocketMouseLeave;

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
  });

  @override
  State<NodeWidget<T>> createState() => _NodeWidgetState<T>();
}

class _NodeWidgetState<T> extends State<NodeWidget<T>> {
  late Vector2 position = widget.node.position;

  Widget makeSockets(NodeSocketType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.node.inputSockets
          .followedBy(widget.node.outputSockets)
          .where((s) => s.type == type)
          .map((socket) {
            return GestureDetector(
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
              child: MouseRegion(
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
                      key: socket.key,
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
            );
          })
          .toList(),
    );
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
