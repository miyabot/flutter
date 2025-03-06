import 'package:flutter/material.dart';
//ウィジェットとはFlutterのUIを構築しているパーツのこと
void main() {

  //１，runApp();
  //ランアップは実行するアプリを指定する(今回は何も書いていないのでエラーが起きる)

  //２,runApp(MaterialApp());
  //マテリアルアップではアプリの基盤を作っている(細かい機能を追加していないので画面は真っ暗)

  //３,runApp(MaterialApp(home:Scaffold()));
  //homeは最初に呼びたいページを指定する
  //スキャフォールドでは主にアプリの画面の骨組みを作成する役割

  // ４，runApp(const MaterialApp(
  //   　　home: Scaffold(body: Text('HelloWorld')),
  // 　　));
  //bodyは画面の中身を作る、Textは画面に文字表示

  //小ネタ:debugprint

  //５
  //finalとconstについて(どちらも途中からの値変更は不可能)
  //一度だけ代入可能: finalで宣言した変数には一度だけ値を代入でき、値は実行時に決まる(現在時刻の取得などに使用)
  //コンパイル時に決定する定数: (定数などはこっち)
  // runApp(MaterialApp(
  //   home: Scaffold(
  //     appBar: AppBar(
  //       title:const Text(
  //         '授業用プロジェクト',
  //         style: TextStyle(
  //           fontSize: 16,
  //           color: Colors.white
  //         )
  //       ),
  //       backgroundColor: Colors.blue,
  //     ),
  //     body: const Center(
  //       child:Text('HelloWorld'),
  //     )
  //   ),
  // ));
  //Centerは真ん中に寄せる
  //childを中心に配置されるので記入必須

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text(
          'アップバーですよ',
          style: TextStyle(
            color: Colors.red,
            fontSize: 32,
          ),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            const Text('一富士'),
            const SizedBox(height: 500),
            const Text('二鷹'),
            const SizedBox(height: 500),
            const Text('三茄子'),
          ],
        ),
      ),
    )
  ));
  //Colume(縦)、Row(横)
  //childは一つの要素内で一回しか使えない、
  //複数回使用する場合はchildrenを使用する


// final con = Container(
//   color: Colors.blue,
//   width: 30,
//   height: 15,
// );
//   runApp(MaterialApp(
//     home:Scaffold(
//       appBar: AppBar(
//         title:const Text(
//           'ここはAppBer',
//           style: TextStyle(
//             color: Colors.pink,
//             fontSize: 32,
//           ),
//         ),
//         backgroundColor: Colors.orange,
//         centerTitle: true,//タイトルを真ん中に寄せる
//       ),
//       body: Column(
//         children: [
//           Container(
//             color: Colors.red,
//             width: 100,
//             height: 100,
//             margin: const EdgeInsets.only(top: 50, left: 50), // 左と上に50の余白を追加
//             child:Center(
//               child: Column(
//                 //mainAxisSize: MainAxisSize.max, //ウィジェットが親の高さいっぱいに広がる
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,//均等に並べる
//                 children: [
//                   con,
//                   con,
//                   con,
//                 ],
//               ),

//             ),
//           ),
//           Container(
//             color: Colors.orange,
//             width: 100,
//             height: 100,
//             //margin: const EdgeInsets.only(top: 50, left: 50), // 左と上に50の余白を追加
//             padding: const EdgeInsets.all(20),//Containerの内側の余白
//             margin: const EdgeInsets.all(20), //Containerの外側の余白
//             child: const Text('WOW!!!'),
//           ),
//           Container(
//             color: Colors.pink,
//             width: 100,
//             height: 100,
//             margin: const EdgeInsets.only(top: 50, left: 50), // 左と上に50の余白を追加
//           ),
//         ],
//       )
//     )
//   ));
}
