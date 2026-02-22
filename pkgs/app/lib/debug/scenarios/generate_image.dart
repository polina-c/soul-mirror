import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../shared/primitives/image_gen.dart';

class ImageGenScenario extends StatefulWidget {
  const ImageGenScenario({super.key});

  @override
  State<ImageGenScenario> createState() => _ImageGenScenarioState();
}

class _ImageGenScenarioState extends State<ImageGenScenario> {
  final _controller = TextEditingController();
  Future<Uint8List>? _future;
  bool _injectError = false;
  bool _useAsset = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generate() {
    if (_controller.text.trim().isEmpty) {
      _controller.text = 'A walking cat on the fence';
    }
    final prompt = _controller.text.trim();
    assert(prompt.isNotEmpty);
    setState(() {
      _future = generateImage(
        prompt,
        injectedError: _injectError ? 'Injected error' : null,
        injectedAsset: _useAsset ? 'assets/images/dash.jpg' : null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Describe an image...',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _generate(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: _generate,
                child: const Text('Generate'),
              ),
              const SizedBox(width: 16),
              Checkbox(
                value: _injectError,
                onChanged: (v) => setState(() => _injectError = v!),
              ),
              const Text('Inject error'),
              Checkbox(
                value: _useAsset,
                onChanged: (v) => setState(() => _useAsset = v!),
              ),
              const Text('Use asset'),
            ],
          ),
          const SizedBox(height: 20),
          if (_future != null) Expanded(child: GenImageView(future: _future!)),
        ],
      ),
    );
  }
}
