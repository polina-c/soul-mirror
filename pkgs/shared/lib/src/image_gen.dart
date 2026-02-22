import 'dart:typed_data';

import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:flutter/material.dart';
import '../shared.dart';

Future<Uint8List> generateImage(String prompt, {String? injectedError}) async {
  if (injectedError != null) throw Exception(injectedError);
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

class GenImageView extends StatelessWidget {
  const GenImageView({super.key, required this.future});

  final Future<Uint8List> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: future,
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
