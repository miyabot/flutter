import 'package:flutter/material.dart';

void main() {
  runApp(const MyWidget());
}

//１
// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home:Scaffold(
//         body:Text('www'),
//       ),
//     );
//   }
// }

//２
//全体のテーマを決めるクラス(MaterialApp)
// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: MyApp(),
//     );
//   }
// }

// //その中身を決めていくクラス(Scaffold~)
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body:Text('www'),
//     );
//   }
// }

//３
//全体のテーマを決めるクラス(MaterialApp)
// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home:MyApp(),
//     );
//   }
// }

// //その中身を決めていくクラス(Scaffold~)
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int count = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Text('$count'),
//           ElevatedButton(
//             onPressed:(){
//               count++;
//               debugPrint('$count');
//             },
//             child:const Text('+1'),
//           ),
//         ],
//       ),
//     );
//   }
// }

//４
//StatelessWidgetは状態が変化しない際に使用される
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TestApp(),
    );
  }
}

//StatefulWidgetは状態が変化する際に使用される
//こっちは状態が変化するよと伝えるだけ。実際の処理などはStateの方で行う
class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
}

//こっちのほうで処理を書いていく
class _TestAppState extends State<TestApp> {
  int count = 0;

  void _countUp(){
      //setState・・・画面(ウィジット)の更新を行う際に使用する
      //setStateがない場合、変数の中身は＋１されるが、画面の変化は起きない
      setState(() {
      count++; // カウントを1増やす
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('count:$count'),//文字列として変数を表示させる場合は$を頭に付ける
            ElevatedButton(
              onPressed:_countUp, //ボタンが押された時に関数を呼び出したい時は()を省略する
              child: const Text('+1')),
          ],
        ),
      )
    );
  }
}