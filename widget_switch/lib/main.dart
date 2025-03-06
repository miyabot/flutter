import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      home:const SwitchButton()
    );
  }
}

class SwitchButton extends StatefulWidget {
  const SwitchButton({super.key});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {

  //スイッチの状態を管理する変数
  bool _switchValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //関数版
            showImage(_switchValue),
            //三項演算子版
            //(_switchValue)?const Text('🔊',style: TextStyle(fontSize: 160)):const Text('🔇',style: TextStyle(fontSize: 160)),
            //テキストも入れる場合はこっち
            SwitchListTile(
              title: const Text('サウンド'),
              //value:現在のスイッチの状態
              value: _switchValue, 
              //スイッチの状態が変更された時に呼ばれる関数
              onChanged: (bool value)=>setState((){
                //スイッチの状態を切り替える
                _switchValue = value;
              }),
              secondary:const Icon(Icons.volume_up),
            ),
          ],
        ),
      ),
    );
  }
}
Widget showImage(bool value)
{
  if(value)
  {
    //顔文字はwin+.
    return const Text('🔊',style: TextStyle(fontSize: 160));
    // return Column(
    //   children: [
    //     Image.network('https://www.kobedenshi.ac.jp/assets/img/info/campus/img_campus01.jpg'),
    //     Image.network('https://www.kobedenshi.ac.jp/assets/img/info/campus/img_campus01.jpg'),
    //   ],
    // ) ;
  }
  else
  {
    //return Image.network('https://www.kobedenshi.ac.jp/assets/img/info/img_3dvr.jpg');
    return const Text('🔇',style: TextStyle(fontSize: 160));
  }
  }