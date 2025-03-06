import 'package:flutter/material.dart';
import 'package:flutter_application_1/banana_counter.dart';// bananaだけ入力しても出てくる


void main()
{

  const bnn = BananaCounter(
    number: 888,
  );
  
  //printは本来コンソール画面に出力するための構文
  //int a = 10;
  //print(a);

  //Column(縦)
  // const col = Column(
  //   mainAxisAlignment: MainAxisAlignment.center,
  //   crossAxisAlignment: CrossAxisAlignment.center,
  //   children:[ //子供たち
  //   Text('レモン'),
  //   Text('りんご'),
  //   Text('ぶどう'),
  // ]);

  final img = Image.asset('assets/images/dog_akitainu.png');

  //Row(横)
  final row = Row(
    mainAxisAlignment: MainAxisAlignment.center,  //真ん中に寄せる(縦の位置)
    crossAxisAlignment: CrossAxisAlignment.center,  //真ん中に寄せる(横の位置)
    children: [
      img,img,img //３枚分格納
    ],);


  final con = Container(
    color:Colors.deepOrange,
    width: 240,
    height: 120,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.all(20),
    child: img, //childは最後じゃないと怒られる
  );

  //Widget(FlutterのUIを構築しているパーツのこと)
  //フォルダ内の画像表示(Image.asset('パス'))
  const a =  MaterialApp(home:Scaffold(body:Center(child:bnn)));

  //ネットワーク内の画像表示(Image.network('URL'))
  //final a = MaterialApp(home:Scaffold(body:Center(child: Image.network('https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg'))));
  runApp(a);

}