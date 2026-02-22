import 'package:flutter/material.dart';
import 'scenarios/generate_image.dart';

class Scenarios extends StatefulWidget {
  const Scenarios({super.key});

  @override
  State<Scenarios> createState() => _ScenariosState();
}

class _ScenariosState extends State<Scenarios> {
  static const _scenarios = [
    (label: 'Generate image', widget: ImageGenScenario()),
  ];

  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: ListView.builder(
              itemCount: _scenarios.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(_scenarios[i].label),
                selected: i == _selected,
                onTap: () => setState(() => _selected = i),
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: _scenarios[_selected].widget),
        ],
      ),
    );
  }
}
