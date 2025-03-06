import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FlutterPage extends StatefulWidget {
  const FlutterPage({super.key});

  @override
  State<FlutterPage> createState() => _FlutterPageState();
}

class _FlutterPageState extends State<FlutterPage> {

  late final WebViewController _controller;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (_) => setState(() => isLoading = true),
        onPageFinished: (_) => setState(() => isLoading = false),
      ),
    )
    ..loadRequest(Uri.parse('https://flutter.dev/'));
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (isLoading) 
          Center(child: CircularProgressIndicator()), // ローディング中のインジケータ
      ],
    ),
    );
  }
}