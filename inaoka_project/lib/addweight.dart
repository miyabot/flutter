import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:web_apllication/weight.dart';

class Addweight extends StatefulWidget {
  const Addweight({super.key});

  @override
  State<Addweight> createState() => _AddweightState();
}

class _AddweightState extends State<Addweight> {

  // final Double data;

  // _AddweightState({required this.data});

  //体重
  final TextEditingController _controllerW = TextEditingController();

  //身長
  final TextEditingController _controllerH = TextEditingController();

  @override
  Widget build(BuildContext context) {

    //スクリーンサイズ
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('体重追加ページ'),
        backgroundColor: Colors.green[300],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //身長入力
            SizedBox(
            width: 300,

            child: TextFormField(
            //数値のキーボードが表示される
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            //コピペなどで数値以外の入力を防ぐ
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d*)?')),
            ],

            controller: _controllerH,

            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '身長を入力（cm）',
            ),
            ),
            ),

            //空白
            SizedBox(
              width: screenWidth * 0.95,
              height: screenHeight * 0.03,
            ),

            //体重入力
            SizedBox(
              width: 300,

              child: TextFormField(
                //数値のキーボードが表示される
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                //コピペなどで数値以外の入力を防ぐ
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d*)?')),
                ],

                controller: _controllerW,

                decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '体重を入力',
                ),
              ),
            ),

            ElevatedButton(
              onPressed: (){
                if(_controllerW.text != '')
                {
                  Map<String, dynamic> values = {
                    'wkey':_controllerW.text,
                    'hkey':_controllerH.text,
                  };
                  Navigator.pop(context,values);
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