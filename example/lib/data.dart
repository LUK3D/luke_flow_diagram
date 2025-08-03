import 'dart:ui';

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

class ConnectionModelExample {
  final int type;

  ConnectionModelExample({required this.type});
}

final diagramJson = {
  "nodes": [
    {
      "position": {"x": 2512.523298779097, "y": 1833.6110183826847},
      "id": "[#a21bf]",
      "input_sockets": [
        {
          "id": "[#adfa2]",
          "node_id": "[#a21bf]",
          "type": "input",
          "position": {"x": 0.0, "y": 0.0},
          "max_connections": 500,
        },
      ],
      "output_sockets": [
        {
          "id": "[#6bfb5]",
          "node_id": "[#a21bf]",
          "type": "output",
          "position": {"x": 2563.804914074135, "y": 1849.0704675642291},
          "max_connections": 500,
        },
      ],
    },
    {
      "position": {"x": 2742.3590159328455, "y": 1747.2029417349056},
      "id": "[#7e0e7]",
      "input_sockets": [
        {
          "id": "[#28a66]",
          "node_id": "[#7e0e7]",
          "type": "input",
          "position": {"x": 2738.8477038513233, "y": 1835.7328439853534},
          "max_connections": 500,
        },
      ],
      "output_sockets": [
        {
          "id": "[#3254f]",
          "node_id": "[#7e0e7]",
          "type": "output",
          "position": {"x": 2824.2462925254126, "y": 1761.657958934605},
          "max_connections": 500,
        },
      ],
    },
    {
      "position": {"x": 2736.833783895783, "y": 1899.9613116294195},
      "id": "[#ea34d]",
      "input_sockets": [
        {
          "id": "[#1202b]",
          "node_id": "[#ea34d]",
          "type": "input",
          "position": {"x": 2753.8016792090766, "y": 1912.815247503087},
          "max_connections": 500,
        },
      ],
      "output_sockets": [
        {
          "id": "[#55a94]",
          "node_id": "[#ea34d]",
          "type": "output",
          "position": {"x": 2831.430882275793, "y": 1937.6804078189166},
          "max_connections": 500,
        },
      ],
    },
    {
      "position": {"x": 2930.8177071560517, "y": 1745.4926319962417},
      "id": "[#23915]",
      "input_sockets": [
        {
          "id": "[#278f4]",
          "node_id": "[#23915]",
          "type": "input",
          "position": {"x": 2922.639538343012, "y": 1860.726971812836},
          "max_connections": 500,
        },
      ],
      "output_sockets": [
        {
          "id": "[#db348]",
          "node_id": "[#23915]",
          "type": "output",
          "position": {"x": 3019.214291943873, "y": 1783.2629690067035},
          "max_connections": 500,
        },
      ],
    },
    {
      "position": {"x": 2963.1483610327605, "y": 1895.7703009416973},
      "id": "[#590da]",
      "input_sockets": [
        {
          "id": "[#1019d]",
          "node_id": "[#590da]",
          "type": "input",
          "position": {"x": 2967.543224282888, "y": 1956.521501817903},
          "max_connections": 500,
        },
      ],
      "output_sockets": [
        {
          "id": "[#9bca7]",
          "node_id": "[#590da]",
          "type": "output",
          "position": {"x": 3051.8640823269907, "y": 1928.1464138317888},
          "max_connections": 500,
        },
      ],
    },
    {
      "position": {"x": 3147.772841577399, "y": 1746.531954825694},
      "id": "[#08f46]",
      "input_sockets": [
        {
          "id": "[#85b98]",
          "node_id": "[#08f46]",
          "type": "input",
          "position": {"x": 3144.671311830037, "y": 1802.8974619161982},
          "max_connections": 500,
        },
      ],
      "output_sockets": [
        {
          "id": "[#29aff]",
          "node_id": "[#08f46]",
          "type": "output",
          "position": {"x": 0.0, "y": 0.0},
          "max_connections": 500,
        },
      ],
    },
  ],
  "connections": [
    {
      "id": "[#6bfb5]-[#28a66]",
      "source": {
        "id": "[#6bfb5]",
        "node_id": "[#a21bf]",
        "type": "output",
        "position": {"x": 2593.646345654097, "y": 1872.2097341952165},
        "max_connections": 500,
      },
      "target": {
        "id": "[#28a66]",
        "node_id": "[#7e0e7]",
        "type": "input",
        "position": {"x": 2744.9577317453777, "y": 1785.8016575474373},
        "max_connections": 500,
      },
    },
    {
      "id": "[#6bfb5]-[#1202b]",
      "source": {
        "id": "[#6bfb5]",
        "node_id": "[#a21bf]",
        "type": "output",
        "position": {"x": 2593.646345654097, "y": 1872.2097341952165},
        "max_connections": 500,
      },
      "target": {
        "id": "[#1202b]",
        "node_id": "[#ea34d]",
        "type": "input",
        "position": {"x": 2738.833783895783, "y": 1937.9613116294192},
        "max_connections": 500,
      },
    },
    {
      "id": "[#3254f]-[#278f4]",
      "source": {
        "id": "[#3254f]",
        "node_id": "[#7e0e7]",
        "type": "output",
        "position": {"x": 2824.0807786203777, "y": 1785.8016575474373},
        "max_connections": 500,
      },
      "target": {
        "id": "[#278f4]",
        "node_id": "[#23915]",
        "type": "input",
        "position": {"x": 2932.817707156052, "y": 1783.492631996242},
        "max_connections": 500,
      },
    },
    {
      "id": "[#55a94]-[#278f4]",
      "source": {
        "id": "[#55a94]",
        "node_id": "[#ea34d]",
        "type": "output",
        "position": {"x": 2817.956830770783, "y": 1937.9613116294192},
        "max_connections": 500,
      },
      "target": {
        "id": "[#278f4]",
        "node_id": "[#23915]",
        "type": "input",
        "position": {"x": 2932.817707156052, "y": 1783.492631996242},
        "max_connections": 500,
      },
    },
    {
      "id": "[#55a94]-[#1019d]",
      "source": {
        "id": "[#55a94]",
        "node_id": "[#ea34d]",
        "type": "output",
        "position": {"x": 2817.956830770783, "y": 1937.9613116294192},
        "max_connections": 500,
      },
      "target": {
        "id": "[#1019d]",
        "node_id": "[#590da]",
        "type": "input",
        "position": {"x": 2965.148361032761, "y": 1933.7703009416975},
        "max_connections": 500,
      },
    },
    {
      "id": "[#9bca7]-[#85b98]",
      "source": {
        "id": "[#9bca7]",
        "node_id": "[#590da]",
        "type": "output",
        "position": {"x": 3044.271407907761, "y": 1933.7703009416975},
        "max_connections": 500,
      },
      "target": {
        "id": "[#85b98]",
        "node_id": "[#08f46]",
        "type": "input",
        "position": {"x": 3149.7728415774, "y": 1785.5522607751664},
        "max_connections": 500,
      },
    },
    {
      "id": "[#db348]-[#85b98]",
      "source": {
        "id": "[#db348]",
        "node_id": "[#23915]",
        "type": "output",
        "position": {"x": 3011.940754031052, "y": 1783.492631996242},
        "max_connections": 500,
      },
      "target": {
        "id": "[#85b98]",
        "node_id": "[#08f46]",
        "type": "input",
        "position": {"x": 3149.7728415774, "y": 1785.5522607751664},
        "max_connections": 500,
      },
    },
  ],
};
