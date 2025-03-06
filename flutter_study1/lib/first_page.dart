import 'package:flutter/material.dart';
import 'package:flutter_study1/second_page.dart';

class firstPage extends StatelessWidget {
  String nameText = '';
  @override
  // Widget build(BuildContext context) {
  //   //スキャフォールド(画面を作る大元) 
  //   return Scaffold(
  //     //アップバー(上部分)
  //     appBar: AppBar(
  //       title: Text('miyaApp'),
  //     ),
  //     //ボディ(中身)
  //     body:Container(
  //       color: Colors.red,
  //       width:double.infinity,//横幅全体
  //       height:double.infinity,//縦幅全体
  //       child: const Row( //Column(縦に並べる)、Row(横に並べる)
  //         children: [ //チルドレン(複数要素の格納)
  //           Text('２４歳'),
  //           Text('神戸住み'),
  //           Text('男'),
  //           Text('趣味はゲーム！'),
  //           Text('あとはサウナ'),
  //         ],
  //       )
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    //スキャフォールド(画面を作る大元) 
    return Scaffold(
      //アップバー(上部分)
      appBar: AppBar(
        title: const Text('ファースト'),
      ),
      //ボディ(中身)
      body:Center(
        //テキスト(囲まれていない)、エレベイテッド(囲まれている)、アウトライン(枠だけ)
        child: Padding(
          padding: const EdgeInsets.all(16.0),//余白
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //ネットワークから画像を拾ってくる
              Image.network(
                'https://www.kobedenshi.ac.jp/assets/img/info/campus/img_campus01.jpg',
                width: 600, // 幅を600ピクセルに指定
                height: 400, // 高さを400
                //fit: BoxFit.cover, // 画像をウィジェット全体にフィットさせる
              ),
              //入力欄の作成
              TextField(
                onChanged: (text)
                {
                  nameText = text;
                },
                //obscureText: true,//入力した文字を隠す(パスワードなどでよく見る)
                //TextFieldの外観をカスタマイズ
                decoration: const InputDecoration(
                  border:OutlineInputBorder(),
                  //labelText:'Password',
                ),
              ),
              ElevatedButton( 
                onPressed:()
                {
                  //ボタンを押した時に呼ばれる部分
                  //画面遷移
                  Navigator.push
                  (
                      context,
                      MaterialPageRoute(
                        builder: (context)=>secondPage(nameText),
                        //fullscreenDialog: true, //下から画面が切り替わる
                      ),
                        
                  );
                } ,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[200], //背景色
                  foregroundColor: Colors.black,  //テキストの色
                ),
                child:const Text('次の画面へ'), //静的なものにはconstをつける
              ),
            ],
          ),
        )
      )
    );
  }
}