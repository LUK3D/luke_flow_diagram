import 'package:luke_flow_diagram/models/node_model.dart';
import 'package:luke_flow_diagram/utils/math.dart';

class EdgeConnectionsModel {
  late String id;
  final NodeSocketModel source;
  final NodeSocketModel target;
  final dynamic data;

  EdgeConnectionsModel({
    required this.source,
    required this.target,
    this.data,
  }) {
    id = "${source.id}-${target.id}";
  }

  updateSource(Vector2 value) {
    source.position = value;
  }

  updateTarget(Vector2 value) {
    target.position = value;
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "source": source.toJson(), "target": target.toJson()};
  }

  static fromJson(Map<String, dynamic> json) {
    return EdgeConnectionsModel(
      source: NodeSocketModel.fromJson(json["source"]),
      target: NodeSocketModel.fromJson(json["target"]),
    );
  }
}
