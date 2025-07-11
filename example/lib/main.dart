import 'dart:convert';
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
      home: Scaffold(body: const LukeFlowDiagram()),
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
  late final nodes = List.generate(1000, (index) => index)
      .map(
        (i) => NodeModel(
          data: DataModelExample(
            id: '$i',
            name: 'Node $i',
            description: 'This is the first node',
          ),
          position: getRandomPositionNearCenter(spread: 1000),
        ),
      )
      .toList();

  final controller = LukeFlowCanvasController<DataModelExample>();

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
                    controller.centerCanvas();
                  },
                  child: Text("Center Nodes"),
                ),
                TextButton(
                  onPressed: () {
                    controller.addNode(
                      NodeModel(
                        position: getRandomPositionNearCenter(spread: 1000),
                      ),
                    );
                  },
                  child: Text("Add node"),
                ),
                TextButton(
                  onPressed: () {
                    final result = controller.toJson();
                    debugPrint(jsonEncode(result));
                  },
                  child: Text("Export"),
                ),
                TextButton(
                  onPressed: () {
                    controller.fromJson(diagramJson);
                  },
                  child: Text("Inport"),
                ),
              ],
            ),
          ),
          Expanded(
            child: LukeFlowCanvas<DataModelExample>(
              controller: controller,
              nodes: nodes,
              initialConnections: connections,
              nodeBuilder: (node) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: node.data?.color ?? Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      node.data?.name ?? 'Node',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
              onUpdate: (n, c) {
                connections = c;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DataModelExample {
  final String id;
  final String name;
  final String description;
  final Color? color;

  DataModelExample({
    this.color,
    required this.id,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }

  DataModelExample.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      description = json['description'],
      color = json['color'] != null ? Color(json['color']) : null;
}
