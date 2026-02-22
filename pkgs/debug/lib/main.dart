import 'dart:typed_data';

import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

Future<Uint8List> generateImage(String prompt) async {
  final agent = Agent.forProvider(
    GoogleProvider(apiKey: getApiKey()),
    mediaModelName: 'gemini-3-pro-image-preview',
  );

  try {
    final result = await agent.generateMedia(prompt, mimeTypes: ['image/png']);
    final asset = result.assets.firstOrNull;
    if (asset is DataPart) return asset.bytes;
    throw Exception('Gemini returned no image for prompt: "$prompt"');
  } catch (e) {
    if (e is Exception) rethrow;
    throw Exception('Gemini image generation failed: $e');
  }
}

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
  Uint8List? _imageBytes;
  bool _loading = false;
  String? _error;

  Future<void> _generate() async {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _loading = true;
      _imageBytes = null;
      _error = null;
    });

    try {
      final bytes = await generateImage(prompt);
      setState(() => _imageBytes = bytes);
    } on Exception catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
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
              onPressed: _loading ? null : _generate,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Generate'),
            ),
            const SizedBox(height: 20),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_imageBytes != null)
              Expanded(child: Image.memory(_imageBytes!)),
          ],
        ),
      ),
    );
  }
}
