final diagramJson = {
  "nodes": [
    {
      "position": {"x": 4706.272610741973, "y": 4968.495186584696},
      "id": "[#d12c7]",
      "input_sockets": 1,
      "output_sockets": 1,
      "sockets": [
        {
          "id": "[#9833f]",
          "node_id": "[#d12c7]",
          "type": "input",
          "position": {"x": 4706.909649127607, "y": 5004.495186584696},
        },
        {
          "id": "[#c5492]",
          "node_id": "[#d12c7]",
          "type": "output",
          "position": {"x": 4786.032696002607, "y": 5004.495186584696},
        },
      ],
    },
    {
      "position": {"x": 4938.72100118675, "y": 4967.149934724616},
      "id": "[#7dddc]",
      "input_sockets": 1,
      "output_sockets": 1,
      "sockets": [
        {
          "id": "[#8a81e]",
          "node_id": "[#7dddc]",
          "type": "input",
          "position": {"x": 4938.721001186751, "y": 5002.310159909303},
        },
        {
          "id": "[#b0785]",
          "node_id": "[#7dddc]",
          "type": "output",
          "position": {"x": 5017.844048061751, "y": 5002.310159909303},
        },
      ],
    },
    {
      "position": {"x": 4528.954793224455, "y": 4895.727135906213},
      "id": "[#8baca]",
      "input_sockets": 1,
      "output_sockets": 1,
      "sockets": [
        {
          "id": "[#fb00f]",
          "node_id": "[#8baca]",
          "type": "input",
          "position": {"x": 0.0, "y": 0.0},
        },
        {
          "id": "[#8281d]",
          "node_id": "[#8baca]",
          "type": "output",
          "position": {"x": 4608.077840099455, "y": 4931.0900975205805},
        },
      ],
    },
    {
      "position": {"x": 5110.132797082738, "y": 4900.273303196787},
      "id": "[#281da]",
      "input_sockets": 1,
      "output_sockets": 1,
      "sockets": [
        {
          "id": "[#4f93c]",
          "node_id": "[#281da]",
          "type": "input",
          "position": {"x": 5110.132797082737, "y": 4936.273303196786},
        },
        {
          "id": "[#5f1ce]",
          "node_id": "[#281da]",
          "type": "output",
          "position": {"x": 5189.255843957737, "y": 4936.273303196786},
        },
      ],
    },
    {
      "position": {"x": 4730.222139179741, "y": 4798.340767226385},
      "id": "[#0fb3d]",
      "input_sockets": 1,
      "output_sockets": 1,
      "sockets": [
        {
          "id": "[#9f5d7]",
          "node_id": "[#0fb3d]",
          "type": "input",
          "position": {"x": 4730.222139179741, "y": 4834.340767226385},
        },
        {
          "id": "[#92284]",
          "node_id": "[#0fb3d]",
          "type": "output",
          "position": {"x": 4809.345186054741, "y": 4834.340767226385},
        },
      ],
    },
    {
      "position": {"x": 4975.845496996266, "y": 4803.5133823647775},
      "id": "[#b4f50]",
      "input_sockets": 1,
      "output_sockets": 1,
      "sockets": [
        {
          "id": "[#a9e82]",
          "node_id": "[#b4f50]",
          "type": "input",
          "position": {"x": 4975.845496996266, "y": 4839.5133823647775},
        },
        {
          "id": "[#9fa93]",
          "node_id": "[#b4f50]",
          "type": "output",
          "position": {"x": 5043.086707933766, "y": 4839.5133823647775},
        },
      ],
    },
    {
      "position": {"x": 5285.030330132584, "y": 4903.8831598771985},
      "id": "[#dc4cc]",
      "input_sockets": 1,
      "output_sockets": 1,
      "sockets": [
        {
          "id": "[#e4d85]",
          "node_id": "[#dc4cc]",
          "type": "input",
          "position": {"x": 5283.341243021922, "y": 4938.194072766537},
        },
        {
          "id": "[#7558b]",
          "node_id": "[#dc4cc]",
          "type": "output",
          "position": {"x": 0.0, "y": 0.0},
        },
      ],
    },
  ],
  "connections": [
    {
      "id": "[#8281d]-[#9f5d7]",
      "source": {
        "id": "[#8281d]",
        "node_id": "[#8baca]",
        "type": "output",
        "position": {"x": 4608.077840099455, "y": 4931.0900975205805},
      },
      "target": {
        "id": "[#9f5d7]",
        "node_id": "[#0fb3d]",
        "type": "input",
        "position": {"x": 4730.222139179741, "y": 4834.340767226385},
      },
    },
    {
      "id": "[#8281d]-[#9833f]",
      "source": {
        "id": "[#8281d]",
        "node_id": "[#8baca]",
        "type": "output",
        "position": {"x": 4608.077840099455, "y": 4931.0900975205805},
      },
      "target": {
        "id": "[#9833f]",
        "node_id": "[#d12c7]",
        "type": "input",
        "position": {"x": 4706.909649127607, "y": 5004.495186584696},
      },
    },
    {
      "id": "[#8281d]-[#4f93c]",
      "source": {
        "id": "[#8281d]",
        "node_id": "[#8baca]",
        "type": "output",
        "position": {"x": 4608.077840099455, "y": 4931.0900975205805},
      },
      "target": {
        "id": "[#4f93c]",
        "node_id": "[#281da]",
        "type": "input",
        "position": {"x": 5110.132797082737, "y": 4936.273303196786},
      },
    },
    {
      "id": "[#92284]-[#4f93c]",
      "source": {
        "id": "[#92284]",
        "node_id": "[#0fb3d]",
        "type": "output",
        "position": {"x": 4809.345186054741, "y": 4834.340767226385},
      },
      "target": {
        "id": "[#4f93c]",
        "node_id": "[#281da]",
        "type": "input",
        "position": {"x": 5110.132797082737, "y": 4936.273303196786},
      },
    },
    {
      "id": "[#c5492]-[#8a81e]",
      "source": {
        "id": "[#c5492]",
        "node_id": "[#d12c7]",
        "type": "output",
        "position": {"x": 4786.032696002607, "y": 5004.495186584696},
      },
      "target": {
        "id": "[#8a81e]",
        "node_id": "[#7dddc]",
        "type": "input",
        "position": {"x": 4938.721001186751, "y": 5002.310159909303},
      },
    },
    {
      "id": "[#b0785]-[#4f93c]",
      "source": {
        "id": "[#b0785]",
        "node_id": "[#7dddc]",
        "type": "output",
        "position": {"x": 5017.844048061751, "y": 5002.310159909303},
      },
      "target": {
        "id": "[#4f93c]",
        "node_id": "[#281da]",
        "type": "input",
        "position": {"x": 5110.132797082737, "y": 4936.273303196786},
      },
    },
    {
      "id": "[#92284]-[#a9e82]",
      "source": {
        "id": "[#92284]",
        "node_id": "[#0fb3d]",
        "type": "output",
        "position": {"x": 4809.345186054741, "y": 4834.340767226385},
      },
      "target": {
        "id": "[#a9e82]",
        "node_id": "[#b4f50]",
        "type": "input",
        "position": {"x": 4975.845496996266, "y": 4839.5133823647775},
      },
    },
    {
      "id": "[#9fa93]-[#4f93c]",
      "source": {
        "id": "[#9fa93]",
        "node_id": "[#b4f50]",
        "type": "output",
        "position": {"x": 5043.086707933766, "y": 4839.5133823647775},
      },
      "target": {
        "id": "[#4f93c]",
        "node_id": "[#281da]",
        "type": "input",
        "position": {"x": 5110.132797082737, "y": 4936.273303196786},
      },
    },
    {
      "id": "[#5f1ce]-[#e4d85]",
      "source": {
        "id": "[#5f1ce]",
        "node_id": "[#281da]",
        "type": "output",
        "position": {"x": 5189.255843957737, "y": 4936.273303196786},
      },
      "target": {
        "id": "[#e4d85]",
        "node_id": "[#dc4cc]",
        "type": "input",
        "position": {"x": 5283.341243021922, "y": 4938.194072766537},
      },
    },
  ],
};
