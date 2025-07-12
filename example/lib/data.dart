final diagramJson = {
  "nodes": [
    {
      "position": {"x": 4432.716960349934, "y": 5053.062209227447},
      "id": "[#3e0e9]",
      "input_sockets": [
        {
          "id": "[#570ea]",
          "node_id": "[#3e0e9]",
          "type": "input",
          "position": {"x": 0.0, "y": 0.0},
        },
      ],
      "output_sockets": [
        {
          "id": "[#0d10c]",
          "node_id": "[#3e0e9]",
          "type": "output",
          "position": {"x": 4511.840007224933, "y": 5089.062209227446},
        },
      ],
    },
    {
      "position": {"x": 4615.487532104788, "y": 5093.064617100649},
      "id": "[#cd88e]",
      "input_sockets": [
        {
          "id": "[#9c88e]",
          "node_id": "[#cd88e]",
          "type": "input",
          "position": {"x": 4615.487532104788, "y": 5129.064617100648},
        },
      ],
      "output_sockets": [
        {
          "id": "[#cba8d]",
          "node_id": "[#cd88e]",
          "type": "output",
          "position": {"x": 4694.610578979788, "y": 5129.064617100648},
        },
      ],
    },
    {
      "position": {"x": 5027.5095160033125, "y": 5092.700025661055},
      "id": "[#b67f9]",
      "input_sockets": [
        {
          "id": "[#022c9]",
          "node_id": "[#b67f9]",
          "type": "input",
          "position": {"x": 5027.509516003312, "y": 5128.7000256610545},
        },
      ],
      "output_sockets": [
        {
          "id": "[#ebbe2]",
          "node_id": "[#b67f9]",
          "type": "output",
          "position": {"x": 5106.632562878312, "y": 5128.7000256610545},
        },
      ],
    },
    {
      "position": {"x": 4810.864437664658, "y": 5092.812117181615},
      "id": "[#1bfbf]",
      "input_sockets": [
        {
          "id": "[#1ed55]",
          "node_id": "[#1bfbf]",
          "type": "input",
          "position": {"x": 4810.864437664658, "y": 5127.843261426862},
        },
      ],
      "output_sockets": [
        {
          "id": "[#20094]",
          "node_id": "[#1bfbf]",
          "type": "output",
          "position": {"x": 4889.987484539658, "y": 5127.843261426862},
        },
      ],
    },
    {
      "position": {"x": 5212.338216391881, "y": 5050.974147645688},
      "id": "[#e1422]",
      "input_sockets": [
        {
          "id": "[#a8b46]",
          "node_id": "[#e1422]",
          "type": "input",
          "position": {"x": 5212.338216391881, "y": 5086.9741476456875},
        },
      ],
      "output_sockets": [
        {
          "id": "[#058da]",
          "node_id": "[#e1422]",
          "type": "output",
          "position": {"x": 5631.529633184588, "y": 4913.548967545175},
        },
      ],
    },
    {
      "position": {"x": 4812.617881864494, "y": 4992.28597607317},
      "id": "[#8e061]",
      "input_sockets": [
        {
          "id": "[#6ed86]",
          "node_id": "[#8e061]",
          "type": "input",
          "position": {"x": 4812.617881864494, "y": 5029.905114637138},
        },
      ],
      "output_sockets": [
        {
          "id": "[#6f6ea]",
          "node_id": "[#8e061]",
          "type": "output",
          "position": {"x": 4879.859092801994, "y": 5029.905114637138},
        },
      ],
    },
    {
      "position": {"x": 4609.024217300159, "y": 4989.806941735066},
      "id": "[#52a6f]",
      "input_sockets": [
        {
          "id": "[#f8c7f]",
          "node_id": "[#52a6f]",
          "type": "input",
          "position": {"x": 4609.024217300158, "y": 5025.806941735065},
        },
      ],
      "output_sockets": [
        {
          "id": "[#e6711]",
          "node_id": "[#52a6f]",
          "type": "output",
          "position": {"x": 4674.265428237659, "y": 5027.806941735066},
        },
      ],
    },
    {
      "position": {"x": 5032.6089947775, "y": 4995.4258729882995},
      "id": "[#9b2ff]",
      "input_sockets": [
        {
          "id": "[#c59f4]",
          "node_id": "[#9b2ff]",
          "type": "input",
          "position": {"x": 5032.6089947775, "y": 5031.425872988299},
        },
      ],
      "output_sockets": [
        {
          "id": "[#d6c5b]",
          "node_id": "[#9b2ff]",
          "type": "output",
          "position": {"x": 5099.850205715, "y": 5031.425872988299},
        },
      ],
    },
  ],
  "connections": [
    {
      "id": "[#e6711]-[#6ed86]",
      "source": {
        "id": "[#e6711]",
        "node_id": "[#52a6f]",
        "type": "output",
        "position": {"x": 4674.265428237659, "y": 5027.806941735066},
      },
      "target": {
        "id": "[#6ed86]",
        "node_id": "[#8e061]",
        "type": "input",
        "position": {"x": 4812.617881864494, "y": 5029.905114637138},
      },
    },
    {
      "id": "[#6f6ea]-[#c59f4]",
      "source": {
        "id": "[#6f6ea]",
        "node_id": "[#8e061]",
        "type": "output",
        "position": {"x": 4879.859092801994, "y": 5029.905114637138},
      },
      "target": {
        "id": "[#c59f4]",
        "node_id": "[#9b2ff]",
        "type": "input",
        "position": {"x": 5032.6089947775, "y": 5031.425872988299},
      },
    },
    {
      "id": "[#0d10c]-[#f8c7f]",
      "source": {
        "id": "[#0d10c]",
        "node_id": "[#3e0e9]",
        "type": "output",
        "position": {"x": 4511.840007224933, "y": 5089.062209227446},
      },
      "target": {
        "id": "[#f8c7f]",
        "node_id": "[#52a6f]",
        "type": "input",
        "position": {"x": 4609.024217300158, "y": 5025.806941735065},
      },
    },
    {
      "id": "[#0d10c]-[#9c88e]",
      "source": {
        "id": "[#0d10c]",
        "node_id": "[#3e0e9]",
        "type": "output",
        "position": {"x": 4511.840007224933, "y": 5089.062209227446},
      },
      "target": {
        "id": "[#9c88e]",
        "node_id": "[#cd88e]",
        "type": "input",
        "position": {"x": 4615.487532104788, "y": 5129.064617100648},
      },
    },
    {
      "id": "[#cba8d]-[#1ed55]",
      "source": {
        "id": "[#cba8d]",
        "node_id": "[#cd88e]",
        "type": "output",
        "position": {"x": 4694.610578979788, "y": 5129.064617100648},
      },
      "target": {
        "id": "[#1ed55]",
        "node_id": "[#1bfbf]",
        "type": "input",
        "position": {"x": 4810.864437664658, "y": 5127.843261426862},
      },
    },
    {
      "id": "[#20094]-[#022c9]",
      "source": {
        "id": "[#20094]",
        "node_id": "[#1bfbf]",
        "type": "output",
        "position": {"x": 4889.987484539658, "y": 5127.843261426862},
      },
      "target": {
        "id": "[#022c9]",
        "node_id": "[#b67f9]",
        "type": "input",
        "position": {"x": 5027.509516003312, "y": 5128.7000256610545},
      },
    },
    {
      "id": "[#ebbe2]-[#a8b46]",
      "source": {
        "id": "[#ebbe2]",
        "node_id": "[#b67f9]",
        "type": "output",
        "position": {"x": 5106.632562878312, "y": 5128.7000256610545},
      },
      "target": {
        "id": "[#a8b46]",
        "node_id": "[#e1422]",
        "type": "input",
        "position": {"x": 5212.338216391881, "y": 5086.9741476456875},
      },
    },
    {
      "id": "[#d6c5b]-[#a8b46]",
      "source": {
        "id": "[#d6c5b]",
        "node_id": "[#9b2ff]",
        "type": "output",
        "position": {"x": 5099.850205715, "y": 5031.425872988299},
      },
      "target": {
        "id": "[#a8b46]",
        "node_id": "[#e1422]",
        "type": "input",
        "position": {"x": 5212.338216391881, "y": 5086.9741476456875},
      },
    },
  ],
};
