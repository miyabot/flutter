import 'package:flutter/material.dart';

void main() => runApp(const Base());

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DoubleTextFieldExample(),
    );
  }
}

class DoubleTextFieldExample extends StatefulWidget {
  const DoubleTextFieldExample({Key? key}) : super(key: key);

  @override
  State<DoubleTextFieldExample> createState() => _DoubleTextFieldExampleState();
}

class _DoubleTextFieldExampleState extends State<DoubleTextFieldExample> {
  final TextEditingController _con1 = TextEditingController();
  final TextEditingController _con2 = TextEditingController();

  @override
  void initState() {
    super.initState();

    // _con1の変更を監視
    _con1.addListener(() {
      final input = _con1.text;

      // 入力値が数値なら計算して反映
      if (double.tryParse(input) != null) {
        final doubledValue = double.parse(input) * 2;
        _con2.text = doubledValue.toString();
      } else {
        // 入力が無効な場合は空にする
        _con2.text = '';
      }
    });
  }

  @override
  void dispose() {
    // コントローラーを解放
    _con1.dispose();
    _con2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TextField Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _con1,
              decoration: const InputDecoration(
                labelText: "Input Number",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _con2,
              decoration: const InputDecoration(
                labelText: "Doubled Value",
                border: OutlineInputBorder(),
              ),
              readOnly: true, // 入力不可にする
            ),
          ],
        ),
      ),
    );
  }
}
