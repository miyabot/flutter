import 'package:flutter/material.dart';

void main() {
  runApp(const Base());
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PhoneDirUI(),
    );
  }
}

class PhoneDirUI extends StatefulWidget {
  const PhoneDirUI({super.key});

  @override
  State<PhoneDirUI> createState() => _PhoneDirUIState();
}

class _PhoneDirUIState extends State<PhoneDirUI> {

  List<Map<String,String>> contacts = [
    {'name':'山田 太郎','number':'070-1234-567','address':'東京都'},
    {'name':'鈴木 一郎','number':'080-1234-567','address':'神奈川県'},
    {'name':'佐藤 花子','number':'090-1234-567','address':'大阪府'},
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:const Center(child:Text('電話帳UI')),
        backgroundColor: Colors.purple[100],
      ),
      body:ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context,index){
          return ListTile(
            leading: const Icon(Icons.phone),
            title: Text(contacts[index]['name']!),
            subtitle: Text(contacts[index]['number']!),
            trailing:const Icon(Icons.chevron_right_sharp),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>SecondPage(
                  name: contacts[index]['name']!, number: contacts[index]['number']!, address: contacts[index]['address']!)
                )
              );
            },
          );
        }
      )
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key, required this.name, required this.number, required this.address});

  final String name;
  final String number;
  final String address;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Center(child:Text(name)),
      ) ,
      body:Center(
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading:const Icon(Icons.account_circle),
                  title: Text('名前：$name'),
                ),
                ListTile(
                  leading:const Icon(Icons.phone),
                  title: Text('電話：$number'),
                ),
                ListTile(
                  leading:const Icon(Icons.home),
                  title: Text('住所：$address'),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}