import 'package:flutter/material.dart';

void main() {
  int count = 0;
    // runApp(MaterialApp(
    //   home:Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: Colors.cyan,
    //       title: const Text(
    //         'ボタンの練習',
    //         style: TextStyle(
    //           fontSize: 32,
    //           color: Colors.white,
    //         ),
    //       ),
    //     ),
    //     body:Center( //ボタンを中央に揃える
    //       TextButton:テキストのみ
    //       OutlinedButton:外枠あり
    //       child: ElevatedButton( //外枠＋背景あり
    //         onPressed: (){},
    //         style:ElevatedButton.styleFrom(
    //           backgroundColor: Colors.cyan,
    //           foregroundColor: Colors.black,
    //         ),
    //         child: const Text('Button'),
    //       ),
    //     ) ,
    //   )
    // ));

  runApp(MaterialApp(
    home:Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text(
          'ボタンの練習',
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
          ),
        ),
      ),
      body:Center(
        child: Column( //ボタンを中央に揃える
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            Text('$count'),
            ElevatedButton(
              onPressed: (){
                count++;
                debugPrint('$count');
              },
              style:ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.black,
              ),
              child: const Text('Button'),
            ),
          ],
        ),
      ),
    )
  ));


  //２
//   runApp(MaterialApp(
//     home:Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.cyan,
//         title: const Text(
//           'ボタンの練習',
//           style: TextStyle(
//             fontSize: 32,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body:Center( //ボタンを中央に揃える
//         child:Column(
//           mainAxisAlignment:MainAxisAlignment.center,
//           children:[
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 onPressed:(){} ,//押した時の処理 (何もしない場合は空の関数を渡す)
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   foregroundColor: Colors.black,
//                 ),
//                 child:const Text('Button1'),
//               ),
//             ),
//             ElevatedButton(
//               onPressed:(){} ,//押した時の処理 (何もしない場合は空の関数を渡す)
//               style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               foregroundColor: Colors.black,
//               ),
//             child:const Text('Button2'),
//             )
//           ],
//         )
//       )
//     )
//   ));
}
