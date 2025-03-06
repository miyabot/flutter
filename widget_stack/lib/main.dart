import 'package:flutter/material.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StackSample(),
    );
  }  
}

class StackSample extends StatelessWidget {
  const StackSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        //Stack:上に重ねて表示
        child: Stack(
          //alignment: AlignmentDirectional.bottomEnd, // 子要素を下に配置する
          children: [
            Image.asset('images/dog_akitainu.png',),
            Positioned(bottom: 90,child: Image.asset('images/dog_akitainu.png',),),
            Positioned(bottom: 90,child: Image.asset('images/dog_akitainu.png',),),
            Positioned(bottom: 90,child: Image.asset('images/dog_akitainu.png',),),
            Positioned(bottom: 90,child: Image.asset('images/dog_akitainu.png',),),
            const Text('これは犬です',style: TextStyle(fontSize: 100),)
          ],
        ),
      )
    );
  }
}