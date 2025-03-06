import 'package:flutter/material.dart';
import 'package:flutter_drawer/tile1.dart';
import 'package:flutter_drawer/tile2.dart';
import 'package:flutter_drawer/tile3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SideMenu());
  }
}



class SideMenu extends StatelessWidget {
  const SideMenu({super.key});


  @override
  Widget build(BuildContext context) {

    //１
    // return Scaffold(

    //   //Drawerを使うときはAppBarが必要
    //   appBar: AppBar(
    //     title: const Text('Drawerの基礎'),
    //   ),

    //    //Drawer:ハンバーガーメニュー(サイドメニュー)の作成
    //   drawer: const Drawer(
    //     child: Column(
    //       children: [

    //         //ヘッダーの作成
    //         DrawerHeader(
    //           child: Text('ドロワーヘッダー')
    //         ),

    //         //リストタイルの作成
    //         ListTile(
    //           title: Text('リストタイル１'),
    //         ),
    //         ListTile(
    //           title: Text('リストタイル２'),
    //         ),
    //         ListTile(
    //           title: Text('リストタイル３'),
    //         )
    //       ],
    //     ),
    //   ),
    // );

    //２
    //サイドメニューの三本線をハンバーガーメニューと呼ぶ(メニューアイコンの見た目が似ているから)
    return Scaffold(
      //Drawerを使うときはAppBarが必要
      appBar: AppBar(
        title:const Text('ドロワーの基礎'),
      ),

      //Drawer:ハンバーガーメニュー(サイドメニュー)の作成
      drawer:Drawer(
        child:ListView(
          children: [
            //ヘッダー部分
            const DrawerHeader(
              //ヘッダーの背景画像を設定
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/idol.png'), // 用意した画像
                  fit: BoxFit.cover,
                ),
              ),
              child: Text('ドロワーヘッダー') 
            ),

            //選択項目
            ListTile(
              title: const Text('リストタイル１'),
              leading: const Icon(Icons.settings),  //メニューのアイコン
              //押した時の処理
              onTap: (){
                debugPrint('タイル１が押された');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context){
                    return const FirstTile();
                  })
                );
              },
            ),
            ListTile(
              title: const Text('リストタイル２'),
              leading: const Icon(Icons.directions_boat_filled_sharp),
              onTap: (){
                debugPrint('タイル２が押された');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context){
                    return const SecondTile();
                  })
                );
              },
            ),
            ListTile(
              title:const Text('リストタイル３'),
              leading: const Icon(Icons.accessibility_new_rounded),
              onTap: (){
                debugPrint('タイル３が押された');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context){
                    return const ThirdTile();
                  })
                );
              },
            ),
          ],
        )
      )
    );
  }
}