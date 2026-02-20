import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

class Message {
  Message({this.text, this.surfaceId, this.isUser = false})
    : assert((surfaceId == null) != (text == null));

  String? text;
  final String? surfaceId;
  final bool isUser;
}

class MessageView extends StatelessWidget {
  const MessageView(this.message, this.host, {super.key});

  final Message message;
  final SurfaceHost host;

  @override
  Widget build(BuildContext context) {
    final surfaceId = message.surfaceId;

    if (surfaceId == null) return Text(message.text ?? '');

    return Surface(surfaceContext: host.contextFor(surfaceId));
  }
}
