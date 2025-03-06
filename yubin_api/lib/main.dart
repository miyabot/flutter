import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const Base());
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '郵便番号APIの学習',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();
  List<String> items = [];
  String errorMessage = '';

  Future<void> loadZipCode(String zipCode) async {
    setState(() {
      errorMessage = 'APIレスポンス待ち';
    });

    final response = await http.get(
        Uri.parse('https://zipcloud.ibsnet.co.jp/api/search?zipcode=$zipCode'));

    //失敗
    if (response.statusCode != 200) {
      return;
    }

    //jsonの中身を確認
    //debugPrint('responseの中身:${response.body}');

    //成功
    //jsonデータをDartオブジェクトに変換(Map<String,dynamic>)
    final Map<String, dynamic> body = json.decode(response.body);
    final List<dynamic> result = (body['results'] ?? []);

    //変換後の中身を確認
    //debugPrint('bodyの中身:$body');
    //debugPrint('resultの中身:$result');

    if (result.isEmpty) {
      setState(() {
        errorMessage = 'そのような郵便番号の住所はありません';
      });
    } else {
      setState(() {
        errorMessage = '';
        items = result
          .map(
            (res) =>
                "${res['address1']}${res['address2']}${res['address3']}",
          )
          .toList(growable: false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          onChanged: (value){
            if(value.isNotEmpty){
              loadZipCode(value);
            }
          },
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context,index){
          if(errorMessage.isNotEmpty){
            return ListTile(title: Text(errorMessage));
          }
          else{
            return ListTile(title: Text(items[index]));
          }
        },
        itemCount: items.length,
      ),
    );
  }
}
