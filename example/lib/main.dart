import 'package:example/data.dart';
import 'package:flutter/material.dart';
import 'package:luke_flow_diagram/luke_flow_diagram.dart';
import 'utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 46, 46, 53),
        body: const LukeFlowDiagram(),
      ),
    );
  }
}

class LukeFlowDiagram extends StatefulWidget {
  final double? width;
  final double? height;
  const LukeFlowDiagram({super.key, this.width, this.height});

  @override
  State<LukeFlowDiagram> createState() => _LukeFlowDiagramState();
}

class _LukeFlowDiagramState extends State<LukeFlowDiagram> {
  List<EdgeConnectionsModel> connections = [];
  List<NodeModel<DataModelExample, ConnectionModelExample>> nodes =
      List.generate(1, (index) => index).map((i) {
        final nodeId = DateTime.now()
            .add(Duration(seconds: i))
            .microsecondsSinceEpoch
            .toString();

        return NodeModel<DataModelExample, ConnectionModelExample>(
          id: nodeId,
          inputSockets: [
            NodeSocketModel(
              connectionLimit: 1,
              nodeId: nodeId,
              id: UniqueKey().toString(),
              type: NodeSocketType.input,
              position: Vector2.zero,
            ),
          ],
          outputSockets: [
            NodeSocketModel<ConnectionModelExample>(
              connectionLimit: 2,
              nodeId: nodeId,
              id: UniqueKey().toString(),
              type: NodeSocketType.output,
              position: Vector2.zero,
            ),
          ],
          data: DataModelExample(
            id: '$i',
            name: 'Node $i',
            description: 'This is the first node',
          ),
          position: getRandomPositionNearCenter(spread: 1000),
        );
      }).toList();

  final controller =
      LukeFlowCanvasController<DataModelExample, ConnectionModelExample>();
  List<String> selectedNodes = [];

  @override
  void initState() {
    super.initState();
    controller.addNodes(nodes);
  }

  animate() {
    if (selectedNodes.isEmpty) {
      return;
    }
    final connection = controller.connections
        .where((c) => c.source.nodeId == selectedNodes.first)
        .firstOrNull;
    if (connection == null) return;

    controller.updateConnection(
      connection.copyWith(isAnimated: true, animationSpeed: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 44, 42, 48),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    controller.viewController.center();
                  },
                  child: Text("Center Nodes"),
                ),
                TextButton(
                  onPressed: () {
                    final nodeId = UniqueKey().toString();
                    controller.addNodes(
                      List<
                        NodeModel<DataModelExample, ConnectionModelExample>
                      >.from([
                        NodeModel(
                          position: getRandomPositionNearCenter(spread: 1000),
                          inputSockets: [
                            NodeSocketModel(
                              connectionLimit: 1,
                              nodeId: nodeId,
                              id: UniqueKey().toString(),
                              type: NodeSocketType.input,
                              position: Vector2.zero,
                              data: {},
                            ),
                          ],
                          outputSockets: [
                            NodeSocketModel(
                              connectionLimit: 2,
                              nodeId: nodeId,
                              id: UniqueKey().toString(),
                              type: NodeSocketType.output,
                              position: Vector2.zero,
                              data: {},
                            ),
                          ],
                          data: DataModelExample(
                            id: '${nodes.length}',
                            name: 'Node ${nodes.length}',
                            description: 'This is the first node',
                          ),
                        ),
                      ]),
                    );
                  },
                  child: Text("Add node"),
                ),
                TextButton(
                  onPressed: () {
                    debugPrint(controller.toJsonString());
                  },
                  child: Text("Export"),
                ),
                TextButton(
                  onPressed: () {
                    controller.loadFromJson(diagramJson);
                  },
                  child: Text("Import"),
                ),
                TextButton(
                  onPressed: () {
                    controller.clear();
                  },
                  child: Text("Clear"),
                ),
                TextButton(
                  onPressed: () {
                    controller.viewController.animateZoomTo(2.0);
                    controller.viewController.animateZoomAndPanTo(
                      targetOffset: Offset(300, 200),
                      targetZoom: 1.5,
                      duration: Duration(seconds: 2),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Text("Animate to (100, 100)"),
                ),
                TextButton(
                  onPressed: () {
                    controller.frame();
                  },
                  child: Text("Frame"),
                ),
                TextButton(
                  onPressed: () {
                    animate();
                  },
                  child: Text("Animate"),
                ),
              ],
            ),
          ),
          Expanded(
            child: LukeFlowCanvas<DataModelExample, ConnectionModelExample>(
              controller: controller,
              onEdgeDrop: (source, dropPosition) {
                /// You can create a new node when you drop the connection edge on the canvas by using the onEdgeDrop .
              },
              onBeforeConnectionCreate: (connection, fromSocket, toSocket) {
                final c = connection.copyWith(
                  data: ConnectionModelExample(
                    type: fromSocket.type == NodeSocketType.input ? 0 : 1,
                  ),
                );
                debugPrint("CONNECTION TYPE: ${c.data?.type}");
                return c;
              },
              onConnectionError: (connection) {
                /// This function can be used to handle connection limit error
                debugPrint(
                  "ERROR CONNECTING ${connection.source.id} to ${connection.target.id}",
                );
              },
              onNodesDeleted: (deletedNode) {
                debugPrint(
                  "Deleted Node: ${(deletedNode.first.data as DataModelExample).name}",
                );
              },
              onDoubleTap: (mousePosition) {
                debugPrint(nodes.length.toString());

                /// You can create a new node when you drop the connection edge on the canvas by using the onEdgeDrop .
                final nodeId = UniqueKey().toString();

                /// Create new sockets for the new node
                final inputSocket = NodeSocketModel<ConnectionModelExample>(
                  nodeId: nodeId,
                  position: Vector2.zero,
                  type: NodeSocketType.input,
                );
                final outputSocket = NodeSocketModel<ConnectionModelExample>(
                  nodeId: nodeId,
                  position: Vector2.zero,
                  type: NodeSocketType.output,
                );

                controller.addNodes([
                  NodeModel(
                    id: nodeId,
                    position: mousePosition,
                    inputSockets: [inputSocket],
                    outputSockets: [outputSocket],
                    data: DataModelExample(
                      id: '${nodes.length}',
                      name: 'Node ${nodes.length}',
                      description: 'This is the first node',
                    ),
                  ),
                ]);
                // controller.updateNodesPosition(nodes);
              },
              nodeBuilder: (node) {
                return Material(
                  color: selectedNodes.contains(node.id)
                      ? Colors.amber
                      : (node.data?.color ?? Colors.white),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      debugPrint("SelectedNode: ${node.id}");
                      setState(() {
                        selectedNodes.clear();
                        selectedNodes.add(node.id);
                      });
                    },
                    onSecondaryTap: () {
                      // controller.removeNodeById(selectedNodes.first);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),

                      child: Center(
                        child: Text(
                          node.data?.name ?? 'Node',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                );
              },
              onUpdate: (n, c) {
                setState(() {
                  connections = c;
                  nodes = n;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
