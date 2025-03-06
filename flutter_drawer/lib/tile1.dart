import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home:FirstTile(),
  ));
}

class FirstTile extends StatelessWidget {
  const FirstTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ElevatedButton(
        onPressed: (){
          Navigator.pop(context);
        },
        child:const Text('戻る')
      ),
    );
  }
}