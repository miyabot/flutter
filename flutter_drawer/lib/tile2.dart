import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home:SecondTile(),
  ));
}

class SecondTile extends StatelessWidget {
  const SecondTile({super.key});

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