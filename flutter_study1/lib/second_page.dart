import 'package:flutter/material.dart';

class secondPage extends StatelessWidget {
  secondPage(this.name);//引数てきな
  final String name;

  @override
  Widget build(BuildContext context) {
    //スキャフォールド(画面を作る大元) 
    return Scaffold(
      //アップバー(上部分)
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('セカンド'),
      ),
      //ボディ(中身)
      body:Center(
        //テキスト(囲まれていない)、エレベイテッド(囲まれている)、アウトライン(枠だけ)
        child: Column(
          //メイン軸の中央に子ウィジェットを配置
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //フォルダ内の画像表示
            Image.asset('images/dog_akitainu.png'),
            Text('ようこそ $name さん！',
            style:const TextStyle(
              fontSize: 50,
            )),
            ElevatedButton( 
              onPressed:()
              {
                //ボタンを押した時に呼ばれる部分
                Navigator.pop(context); //現在の画面を閉じて前の画面に戻る
              } ,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan[200], //背景色
                foregroundColor: Colors.black,  //テキストの色
              ),
              child:const Text('前の画面へ'), //静的なものにはconstをつける
            ),
          ],
        )
      )
    );
  }
}