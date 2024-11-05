import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewDetailpage extends StatefulWidget {
  final String link;
  const NewDetailpage({super.key, required this.link});

  @override
  State<NewDetailpage> createState() => _NewDetailPageState();
}

class _NewDetailPageState extends State<NewDetailpage> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(widget.link),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
