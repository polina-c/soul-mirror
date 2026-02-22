import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../shared.dart';
import 'download/download.dart';

Future<Uint8List> generateImage(
  String prompt, {
  String? injectedError,
  String? injectedAsset,
}) async {
  if (injectedError != null) throw Exception(injectedError);
  if (injectedAsset != null) {
    final bytes = await rootBundle.load(injectedAsset);
    return bytes.buffer.asUint8List();
  }
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
        return IntrinsicWidth(
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Image.memory(snapshot.requireData, fit: BoxFit.cover),
              Align(
                alignment: Alignment.topRight,
                child: _Icons(image: snapshot.requireData),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Icons extends StatelessWidget {
  const _Icons({required this.image});

  final Uint8List image;

  Future<void> _shareImage() => Share.shareXFiles([
    XFile.fromData(image, mimeType: 'image/png', name: 'image.png'),
  ]);

  Future<void> _downloadImage() => download(image);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          _Icon(Icons.share, _shareImage),
          _Icon(Icons.download, () async {
            await _downloadImage();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved to Downloads')),
              );
            } else {
              print('cannot show snackbar, context not mounted');
            }
          }),
        ],
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon(this.icon, this.onPressed);

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final btnStyle = IconButton.styleFrom(
      backgroundColor: Theme.of(
        context,
      ).colorScheme.surfaceContainer.withValues(alpha: 0.8),
    );
    return IconButton(
      icon: Icon(icon, size: 18),
      onPressed: onPressed,
      style: btnStyle,
    );
  }
}
