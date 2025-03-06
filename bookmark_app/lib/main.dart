import 'package:bookmark_app/flutter_page.dart';
import 'package:bookmark_app/google_page.dart';
import 'package:bookmark_app/youtube_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Base());
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BookMarkApp(),
    );
  }
}

class BookMarkApp extends StatefulWidget {
  const BookMarkApp({super.key});

  @override
  State<BookMarkApp> createState() => _BookMarkAppState();
}

class _BookMarkAppState extends State<BookMarkApp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('ブックマーク')),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Flutter'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const FlutterPage()));
            },
          ),
          ListTile(
            title: const Text('Google'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const GooglePage()));
            },
          ),
          ListTile(
            title: const Text('Youtube'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const YoutubePage()));
            },
          ),
        ],
      ),
    );
  }
}