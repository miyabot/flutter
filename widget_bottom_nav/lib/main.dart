import 'package:flutter/material.dart';
import 'package:widget_bottom_nav/account_page.dart';
import 'package:widget_bottom_nav/calender_page.dart';
import 'package:widget_bottom_nav/home_page.dart';
import 'package:widget_bottom_nav/setting_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white
        )
      ),
      home: BottomNav(),
    );
  }
}

//下の強調表示が押すたびに変化するのでfulの方を使う
class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}


//最初は表示だけ試す。その後ontapなど
class _BottomNavState extends State<BottomNav> {

  //選択中のアイテム管理変数
  int _currentIndex = 0;

  //表示するページ管理変数
  //リストはファイナルで宣言
  final List _page = [
    const HomePage(),
    const CalenderPage(),
    const SettingPage(),
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: const Color.fromARGB(255, 197, 197, 197), width: 2), // 下枠線の色と幅
            ),
          ),
          child: AppBar(
            title: const Text('タイトル'),
            centerTitle: true,
            elevation: 0, // 影をなくす
            backgroundColor: Colors.transparent, // 背景色を透明に
          ),
        ),
      ),
      //現在選択されているインデックスを要素番号として指定
      body:_page[_currentIndex],
      //画面下部に表示されるバー
      bottomNavigationBar: BottomNavigationBar(
        //４つ以上並べる場合(デフォルトのshiftingでは３つが限界)
        type: BottomNavigationBarType.fixed,
        //現在選択されているタブのインデックスを指定
        currentIndex: _currentIndex,
        //タブがタップされた時に呼ばれる
        //selectedIndex:タップされたアイコンの番号
        onTap: (int selectedIndex) => setState(() {
          //_currentは現在のインデックス
          //serectはタップされたインデックス
          _currentIndex = selectedIndex;
          
        }),
        //見た目の装飾
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label:'home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month),label:'calender'),
          BottomNavigationBarItem(icon: Icon(Icons.settings),label:'setting'),
          BottomNavigationBarItem(icon: Icon(Icons.person),label:'account'),
        ],
      ),
    );
  }
}