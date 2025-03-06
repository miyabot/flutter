import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('追加ページ'),
        backgroundColor: Colors.blue,
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _controller,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _controller2,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                //debugPrint(_controller.text);
                Navigator.pop(context,
                {
                  'title': _controller.text,
                  'description': _controller2.text,
                }); 
              }, 
              child:const Text('追加')
            )
          ],
        ),
      )
    );
  }
}