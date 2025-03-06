import 'package:flutter/material.dart';

void main() => runApp(const Home());

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DialogSample());
  }
}

class DialogSample extends StatefulWidget {
  const DialogSample({super.key});

  @override
  State<DialogSample> createState() => _DialogSampleState();
}

class _DialogSampleState extends State<DialogSample> {
  @override
  Widget build(BuildContext context) {
    //１
    // return Scaffold(
    //   body:Center(
    //     child: ElevatedButton(
    //       onPressed: (){
    //         //shoeDialog:ダイアログの表示
    //         showDialog(
    //           context: context,
    //           //ダイアログの中身を作成
    //           //Dialog.fullscreen:全画面
    //           //_だけの場合、引数を使わないことを明示的に示すために使われる
    //           builder:(_)=> const Dialog(
    //             //Padding:内側の余白
    //             child: Padding(
    //               padding: EdgeInsets.all(32.0),
    //               child: Text('ダイアログだよ'),
    //             ),

    //           )
    //         );
    //       },
    //       child: const Text('PUSH')),
    //   )
    // );

    //２
      return Scaffold(
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                //shoeDialog:ダイアログの表示
                showDialog(
                  context: context, // 現在のビルドコンテキスト
                  builder: (_) {
                    // ダイアログの内容を構築する関数
                    return AlertDialog(
                      title: const Text('データを消してしまってもいいですか？'), // ダイアログのタイトル
                      content: const Text('こうかいしませんね？'), // ダイアログの本文
                      actions: <Widget>[
                        TextField(),
                        // ダイアログに表示するアクションボタンのリスト
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // ダイアログを閉じる（「いいえ」を選択）
                          },
                          child: const Text('いいえ'), // ボタンのテキスト
                        ),
                        TextButton(
                          onPressed: () {
                            // ここに「はい」を選択したときの処理を追加
                            Navigator.pop(context);
                          },
                          child: const Text('はい'), // ボタンのテキスト
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('データ削除ボタン')),
        ),
      );

    //３
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('アラートダイアログ例'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // 最初のダイアログを表示
//             _showConfirmationDialog(context);
//           },
//           child: const Text('アラートを表示'),
//         ),
//       ),
//     );
//   }

//   // 確認ダイアログの関数
//   void _showConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           title: const Text('データを消してしまってもいいですか？'),
//           content: const Text('こうかいしませんね？'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // 現在のダイアログを閉じる（「いいえ」を選択）
//               },
//               child: const Text('いいえ'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // 現在のダイアログを閉じる
//                 // 次のダイアログを表示
//                 _showFinalAlertDialog(context);
//               },
//               child: const Text('はい'),
//             ),
//           ],
//         );
//       },
//     );
//   }

// // 最終確認ダイアログの関数
//   void _showFinalAlertDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           title: const Text('本当に削除しました！'),
//           content: const Text('データが消去されました。'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // 新しいダイアログを閉じる
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
  }
}
