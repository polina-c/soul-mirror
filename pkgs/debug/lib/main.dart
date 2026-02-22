import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ImageGenPage());
  }
}

class ImageGenPage extends StatefulWidget {
  const ImageGenPage({super.key});

  @override
  State<ImageGenPage> createState() => _ImageGenPageState();
}

class _ImageGenPageState extends State<ImageGenPage> {
  final _controller = TextEditingController();
  String? _prompt;

  void _generate() {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) return;
    setState(() => _prompt = prompt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
            ElevatedButton(
              onPressed: _generate,
              child: const Text('Generate'),
            ),
            const SizedBox(height: 20),
            if (_prompt != null)
              Expanded(child: GenImageView(prompt: _prompt!)),
          ],
        ),
      ),
    );
  }
}
