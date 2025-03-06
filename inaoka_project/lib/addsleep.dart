import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Addsleep extends StatefulWidget {
  const Addsleep({super.key});

  @override
  State<Addsleep> createState() => _AddsleepState();
}

class _AddsleepState extends State<Addsleep> {

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('睡眠時間追加ページ'),
        backgroundColor: Colors.green[300],
      ),
      body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,

                    child: TextFormField(
                      //数値のキーボードが表示される
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      //コピペなどで数値以外の入力を防ぐ
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d*)?')),
                      ],

                      controller: _controller,

                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '睡眠時間を入力',
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: (){
                      if(_controller.text != '')
                      {
                        Navigator.pop(context,_controller.text);
                      }
                    },
                    child: const Text('入力確定'),
                  )
                ],
              ),
            ),
    );
  }
}