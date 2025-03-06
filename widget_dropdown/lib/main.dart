import 'package:flutter/material.dart';

void main()=>runApp(MyWidget());

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:DropdownButtonMenu()
    );
    
  }
}

class DropdownButtonMenu extends StatefulWidget {
  const DropdownButtonMenu({Key? key}) : super(key: key);

  @override
  State<DropdownButtonMenu> createState() => _DropdownButtonMenuState();
}

class _DropdownButtonMenuState extends State<DropdownButtonMenu> {

  // ドロップダウンメニューで選択された値を保持する変数
  // 初期値は 'あ' に設定されている
  String isSelectedValue = 'あ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 画面の基本レイアウトを提供するウィジェット
      body: Center(
        // 中央に配置するためのウィジェット
        child: DropdownButton(
          // ドロップダウンメニューの項目リスト
          items: const [
            DropdownMenuItem(
              value: 'あ',  // この項目の値
              child: Text('あ'),  // 表示されるテキスト
            ),
            DropdownMenuItem(
              value: 'い',  // この項目の値
              child: Text('い'),  // 表示されるテキスト
            ),
            DropdownMenuItem(
              value: 'う',  // この項目の値
              child: Text('う'),  // 表示されるテキスト
            ),
            DropdownMenuItem(
              value: 'え',  // この項目の値
              child: Text('え'),  // 表示されるテキスト
            ),
            DropdownMenuItem(
              value: 'お',  // この項目の値
              child: Text('お'),  // 表示されるテキスト
            ),
          ],
          // 現在選択されている値。これがドロップダウンボタンに表示される
          value: isSelectedValue,
          
          // ドロップダウン項目が選ばれたときに呼ばれる処理
          onChanged: (String? value) {
            setState(() {
              // 選択された値を isSelectedValue に格納し、UIを更新する
              isSelectedValue = value!;
            });
          },
        ),
      ),
    );
  }
}
