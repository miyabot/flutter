import 'package:flutter/material.dart';
import 'package:flutter_todo/add_page.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ToDoPage());
  }
}

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  List<String> _list = ['あ', 'い', 'う', 'え', 'お'];
  TextEditingController _controller = TextEditingController();
  bool conCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ToDoアプリ'),
          backgroundColor: Colors.cyan,
        ),
        //ColumnとExpandedはなくてもいいが、他のウィジェットも並べる場合は必要
        body: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  if (value.isNotEmpty) {
                    conCheck = true;
                  } else {
                    conCheck = false;
                  }
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  //テキストフィールドが空ではない、検索した文字列が含まれている場合
                  if (_list[index].contains(_controller.text) && conCheck) {
                    // 検索条件に一致する場合
                    return ListTile(
                      title: Text(_list[index]),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            _list.removeAt(index);
                            debugPrint(_list.toString());
                          });
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    );
                    // テキストフィールドが空の場合
                  } else if (!conCheck) {
                    return ListTile(
                      title: Text(_list[index]),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            _list.removeAt(index);
                            debugPrint(_list.toString());
                          });
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  }

                  // どの条件に合わない場合は空のウィジェットを返す
                  return const SizedBox.shrink();
                },
              ),
            ),

            // ElevatedButton(
            //     onPressed: () async{
            //       final result = await Navigator.push(context,
            //           MaterialPageRoute(builder: (context) => const AddPage()));
            //       // 戻り値がnullでない場合、リストに追加
            //       if (result != null && result is String) {
            //         setState(() {
            //           _list.add(result); // リストに追加
            //         });
            //       }
            //     },
            //     child: const Text('追加'))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddPage()));
              // 戻り値がnullでない場合、リストに追加
              if (result != null && result is String) {
                setState(() {
                  _list.add(result);
                });
              }
            },
            child: const Icon(Icons.add)));
  }
}
