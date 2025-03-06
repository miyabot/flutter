import 'package:flutter/material.dart';
import 'package:flutter_todo_nav/company.dart';
import 'package:flutter_todo_nav/school.dart';


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
  List<String> _list = ['会社', '学校'];
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
                      onTap: (){
                        if(_list[index] == '会社'){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const Company()));
                          }
                          else if(_list[index] == '学校'){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const School()));
                          }
                      },
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
        ));
  }
}
