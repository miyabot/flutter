import 'package:flutter/material.dart';

//1
// void main() {
//   runApp(const MyApp());
// }
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home:MyWidget()
//     );
//   }
// }

// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   //contextとはFlutterアプリの中で「今どこにいるか」を教えてくれる地図みたいなもの
//   //現在地の看板
//   //thisとの違い
//   //this は、「自分自身（このクラスのインスタンス）」を指す
//   //context は、「今どこにいるか（現在のウィジェットの位置と情報）」を指す

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:Center(
//         child: ElevatedButton(
//           onPressed: (){
//             //画面遷移
//             Navigator.push(//スタック構造をイメージ
//               //MaterialPageRouteはどのページに移るか
//               context, MaterialPageRoute(builder: (context)=>const NextPage())//現在のページからNextPageへ
//             );
//           },
//           child: const Text('次のページ'),
//         ),
//       ),
//     );
//   }
// }

// class NextPage extends StatelessWidget {
//   const NextPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:Center(
//         child: ElevatedButton(
//           onPressed:(){
//             Navigator.pop(context);
//           },
//           child:const Text('戻る'),
//         ),
//       ));
//   }
// }

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Sample',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const FirstPage(),
//     );
//   }
// }

// class FirstPage extends StatefulWidget {
//   const FirstPage({super.key});

//   @override
//   State<FirstPage> createState() => _FirstPage();
// }

// class _FirstPage extends State<FirstPage>{
//   String inputText = '';//渡す変数の定義

//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: AppBar(title: const Text('First Page')),
//       body: Center(
//         child: Column(
//           children: [
//             SizedBox(
//               width: double.infinity,
//               child: TextFormField(
//                 onChanged: (value) {
//                   inputText = value;
//                 },
//               ),
//             ),
//             ElevatedButton(
//               onPressed: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context){
//                   return CheckPage(inputText);//引数として入力値を渡す
//                 }),
//                 );
//               },
//               child: const Text('Check'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CheckPage extends StatelessWidget{
//   final String value;//受け取る変数の定義
//   CheckPage(this.value);//コンストラクタの定義

//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: AppBar(title: const Text('Check Page')),
//       body: Center(
//         child: Column(
//           children:[
//             SizedBox(
//               width: double.infinity,
//               child: Text(value),
//             ),
//             ElevatedButton(
//               onPressed:(){
//                 Navigator.pop(context);
//               },
//               child: const Text('back'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//ここから
void main() => runApp(const Home());

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TextFieldPage());
  }
}

class TextFieldPage extends StatefulWidget {
  const TextFieldPage({super.key});

  @override
  State<TextFieldPage> createState() => _TextFieldPageState();
}

//TextField: シンプルなテキスト入力ウィジェット。
//TextFormField: フォームで使うためのテキスト入力ウィジェットで、バリデーション機能を持つ。
class _TextFieldPageState extends State<TextFieldPage> {
  // 入力文字を管理するためのコントローラを作成
  final TextEditingController _controller = TextEditingController();

  //パスワード
  String mypass = 'miyakan814';

  //表示、非表示切り替え用
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //TextFormに幅指定がないため。sizeboxで指定する
          SizedBox(
            width: 300,
            child: TextFormField(
              controller: _controller, // TextEditingControllerを設定
              // デコレーション
              decoration: InputDecoration(
                //enabled: false, //入力ができるかどうか
                border: const OutlineInputBorder(),
                labelText: "パスワードを入力",
                //hintText: "カタカナで入力してください",
                errorText: null, // エラーメッセージは今回使わない。ここに書いたり消したりできる。
                suffixIcon: IconButton(
                  icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState((){
                      _showPassword = !_showPassword;
                    });
                  },
                )
              ),
              obscureText: _showPassword,//黒丸で隠すかどうか
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(onPressed: () {
            // 入力された文字列を取得して、次の画面に渡す
            String inputText = _controller.text;
            (inputText==mypass)?
            Navigator.push(context, 
              MaterialPageRoute(builder: (context)=>NextPage(it:inputText))
            ):
            debugPrint('パスワードが違います');
          },
          child: const Text('送信'))
        ],
      )),
    );
  }
}

// class NextPage extends StatelessWidget {
//   // コンストラクタで文字列を受け取る
//   final String inputText;
//   const NextPage(this.inputText, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('結果')),
//       body: Center(
//         // 受け取った文字列を表示
//         child: Text('入力された名前は: $inputText', style: const TextStyle(fontSize: 24)),
//       ),
//     );
//   }
// }

class NextPage extends StatefulWidget {
  // コンストラクタで文字列を受け取る
  final String it;
  
  //super.key:親クラスにkeyを渡し、ウィジェットツリーで正しく管理されるようにする(おまじない)
  //required:呼ばれるときにinputTextという引数が必須であることを示す
  const NextPage({super.key, required this.it});

  @override
  //_がついていると同一クラス内でしか使えないのに他クラスで使っているため怒られる
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  late String _displayedText;
  @override
  void initState() {
    super.initState();
    // 初期化時にwidget.inputTextを_stateに格納
    _displayedText = widget.it;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('結果')),
      body: Center(
        // 受け取った文字列を表示
        child: Text(
          '入力された名前は: $_displayedText',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
