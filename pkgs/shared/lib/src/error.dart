import 'package:flutter/material.dart';

class ErrorReport extends StatefulWidget {
  const ErrorReport(this.userMessage, {super.key, this.details});

  final String userMessage;
  final String? details;

  @override
  State<ErrorReport> createState() => _ErrorReportState();
}

class _ErrorReportState extends State<ErrorReport> {
  @override
  void initState() {
    super.initState();
    print('\n[ErrorReport] ${widget.userMessage}\n\n${widget.details}');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 12),
          Text(
            widget.userMessage,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          const Text(
            'Check the console for details',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
