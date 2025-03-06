import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('追加ページ'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () {
                      if (_controller.text != "") {
                        Navigator.pop(context, _controller.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(300, 30),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      '追加する',
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(height: 8),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(fixedSize: const Size(300, 30)),
                    child: const Text('キャンセルする')
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
