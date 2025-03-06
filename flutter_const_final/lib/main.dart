import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("final と const の違い")),
        body: const FinalAndConstExample(),
      ),
    );
  }
}

class FinalAndConstExample extends StatelessWidget {
  const FinalAndConstExample({super.key});

  @override
  Widget build(BuildContext context) {
    // final の例
    final DateTime now = DateTime.now(); // 実行時に現在の日時を代入
    // const DateTime constNow = DateTime.now(); // エラー: const はコンパイル時に値が決まる必要がある
    final List list = [1,2,3];
    list.add(4);

    // const の例
    const String appName = "Final vs Const"; // コンパイル時に値が確定

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // final の結果
          Text(
            "現在の日時 (final):\n$now",
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // const の結果
          const Text(
            "アプリ名 (const):\nFinal vs Const",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
