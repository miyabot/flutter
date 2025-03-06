import 'package:flutter/material.dart';
//import 'package:flutter_drawing_board/flutter_drawing_board.dart';

class PaintPage extends StatefulWidget {
  @override
  _PaintPageState createState() => _PaintPageState();
}

class _PaintPageState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('絵日記'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                // 保存機能かく
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  color: Colors.lightGreen,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  color: Colors.lightBlue,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  color: Colors.pink,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ));
  }
}
