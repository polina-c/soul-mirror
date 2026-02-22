import 'dart:typed_data';

import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import 'error.dart';

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

class GenImageView extends StatefulWidget {
  const GenImageView({super.key, required this.prompt});

  final String prompt;

  @override
  State<GenImageView> createState() => _GenImageViewState();
}

class _GenImageViewState extends State<GenImageView> {
  late Future<Uint8List> _future;

  @override
  void initState() {
    super.initState();
    _future = generateImage(widget.prompt);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return ErrorReport(
            'Image generation failed',
            details: snapshot.error.toString(),
          );
        }
        return Image.memory(snapshot.requireData);
      },
    );
  }
}
