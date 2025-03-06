import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:inaoka_project/weight.dart';
import 'package:inaoka_project/sleep.dart';

class Home extends StatefulWidget {

  double weight;
  double sleep;
  
  Home({super.key,required this.weight,required this.sleep});

  

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //クラスのインスタンス化（実体化）
  Weight weight = Weight(
  onWeightUpdated: (double newWeight) {
    // ここで新しい体重データを受け取って処理
    debugPrint('更新された体重: $newWeight');
  },
);
  Sleep sleep = Sleep();

  @override
  Widget build(BuildContext context) {

  //スクリーンサイズ
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            //空白
            SizedBox(
              width: screenWidth * 0.85,
              height: screenHeight * 0.05,
            ),
            //現在の体重の表示
            Container(
              width: screenWidth * 0.85,
              height: screenHeight * 0.25,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.amber[200],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '現在の体重\n    ${widget.weight}kg',
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //空白
            SizedBox(
              width: screenWidth * 0.85,
              height: screenHeight * 0.05,
            ),
            //平均睡眠時間の表示
            Container(
              width: screenWidth * 0.85,
              height: screenHeight * 0.25,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.orange[200],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '平均睡眠時間\n      ${widget.sleep}時間',
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}