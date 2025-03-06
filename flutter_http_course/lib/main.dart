import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const Base());
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeSample()
    );
  }
}

class HomeSample extends StatefulWidget {
  const HomeSample({super.key});

  @override
  State<HomeSample> createState() => _HomeSampleState();
}

class _HomeSampleState extends State<HomeSample> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
    //javaScriptを有効化: 動的コンテンツや機能を正常に動作させるため。
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //Uri.parse:インターネット上のリソースを識別する仕組みで、コードで扱いやすくする
    ..loadRequest(Uri.parse('https://www.youtube.com/watch?v=RA-vLF_vnng'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //SafeArea:上下のUI(Wifiや充電)に重ならないようにする
      body:SafeArea(
        child: WebViewWidget(controller: controller)
      )
    );
  }
}

