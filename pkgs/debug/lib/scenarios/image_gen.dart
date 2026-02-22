import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class ImageGenScenario extends StatefulWidget {
  const ImageGenScenario({super.key});

  @override
  State<ImageGenScenario> createState() => _ImageGenScenarioState();
}

class _ImageGenScenarioState extends State<ImageGenScenario> {
  final _controller = TextEditingController();
  String? _prompt;
  bool _injectError = false;

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
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) return;
    setState(() => _prompt = prompt);
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
                onPressed: _controller.text.trim().isEmpty ? null : _generate,
                child: const Text('Generate'),
              ),
              const SizedBox(width: 16),
              Checkbox(
                value: _injectError,
                onChanged: (v) => setState(() => _injectError = v!),
              ),
              const Text('Inject error'),
            ],
          ),
          const SizedBox(height: 20),
          if (_prompt != null)
            Expanded(
              child: GenImageView(
                prompt: _prompt!,
                injectedError: _injectError ? 'Injected error' : null,
              ),
            ),
        ],
      ),
    );
  }
}
