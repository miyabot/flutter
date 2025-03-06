import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget{
  final List<String>entries = <String>['A','B','C','Yes'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('リスト'),
        backgroundColor: Colors.blue,
      ),

      //リスト(コンテナと違ってスクロール処理にも対応)
      body: ListView.builder(
        itemCount:entries.length ,//リストの情報を何個表示するか
        itemBuilder: (BuildContext context,int index) //itemCountに書いた数だけループする
        {
            return Center(child: Text('Entry ${entries[index]}'));//index(番号)
            
        
        },
      )
    );
  }
}