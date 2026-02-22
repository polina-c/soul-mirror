import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'ai_client.dart';
import 'chat_session.dart';
import 'message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.aiClient});

  final AiClient? aiClient;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ChatSession _chatSession;

  @override
  void initState() {
    super.initState();
    _chatSession = ChatSession(
      aiClient: widget.aiClient ?? DartanticAiClient(),
    );
    // Add a listener to scroll to bottom when messages change.
    _chatSession.addListener(_scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _chatSession,
      builder: (context, _) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _chatSession.messages.length,
                itemBuilder: (context, index) {
                  final message = _chatSession.messages[index];
                  // Pass the controller as the host.
                  return ListTile(
                    title: MessageView(message, _chatSession.surfaceController),
                    tileColor: message.isUser
                        ? Colors.blue.withValues(alpha: 0.1)
                        : null,
                  );
                },
              ),
            ),

            if (_chatSession.isProcessing)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                      ),
                      enabled: !_chatSession.isProcessing,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _chatSession.isProcessing ? null : _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendMessage() async {
    final text = _textController.text;
    if (text.isEmpty) return;
    _textController.clear();
    await _chatSession.sendMessage(text);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _chatSession.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
