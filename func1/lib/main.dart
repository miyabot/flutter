import 'package:flutter/material.dart';
void main()
{
  xxxx()
  {
    debugPrint('これから通信を開始します');
    debugPrint('通信中です');
    debugPrint('通信が終わりました');
  }

  //onPressed:null→押せないボタンが出来る
  //ボタン処理(ElevatedButton(onPressed:押した時の処理,child:ボタン内に表示される文字))                                      ボタンの背景色(なくても問題なし)   
  final button = ElevatedButton(onPressed: xxxx,child: const Text('押してみて'),style: ElevatedButton.styleFrom(backgroundColor: Colors.green));

   // アプリ
  final a = MaterialApp(
    home: Scaffold(
      body: Center(
        child: button,
      ),
    ),
  );

  runApp(a);
}