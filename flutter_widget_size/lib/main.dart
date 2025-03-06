import 'package:flutter/material.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:SizeTest()
    );
  }
}

class SizeTest extends StatelessWidget {

  const SizeTest({super.key});

  @override
  Widget build(BuildContext context) {

    // MediaQueryを使って画面サイズを取得
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      body: Center(
        child: Container(
          //height: screenHeight * 0.8,
          //width: screenWidth * 0.8,

          //固定のサイズを使うのは怖い！
          height: 500,
          width: 500,
          color: Colors.red,
        ),
      )
    );
  }
}