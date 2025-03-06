import 'package:flutter/material.dart';
import 'package:okada_project/drawing.dart';

//タイトル、本文、気分　持って帰る

class ButtonPage extends StatefulWidget {
  final DateTime selectedDay; //選択した日もらう
  //final Datetime choiceDay;
  //const ButtonPage({super.key, required this.selectedDay,this.choiceDay});
  const ButtonPage({super.key, required this.selectedDay});
  @override
  State createState() => _ButtonPageState();
}

class _ButtonPageState extends State {
  final TextEditingController _controller = TextEditingController();
    final TextEditingController _title = TextEditingController();

  //final TextEditingController _emoji = TextEditingController();
  String? _emoji; //初期値 null


  void _selectemoji(int emoji){
    setState(() {
      _choice = emoji;
    });
  }

  // bool buttonPush1 = false;
  // bool buttonPush2 = false;
  // bool buttonPush3 = false;
  // bool buttonPush4 = false;

  int? _choice;  //ChoiceChip
  


  // void _selectemoji(String emoji){
  //   setState(() {
  //     _emoji = emoji;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('追加ページ'),
        backgroundColor: const Color.fromARGB(255, 241, 163, 189),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(11.0), //余白
              child: SizedBox(
                width: 300,
                height: 50,
                child: TextField(
                  controller: _title,
                  maxLines: 1, //50文字まで
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: "Title",
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: SizedBox(
                width: 300,
                height: 100,
                child: TextField(
                  controller: _controller,
                  maxLines: 50, //複数行
                  keyboardType: TextInputType.multiline,
                  decoration:const InputDecoration(
                        border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Wrap(
              spacing: 10,
              children: [
                ChoiceChip(
                  label: const Icon(Icons.sentiment_very_satisfied),
                  selected: _choice == 0,
                  backgroundColor: Colors.white,
                  selectedColor: Colors.red[300],
                  onSelected: (_) {
                    _choice =0;
                    setState(() {
                      _choice = 0;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Icon(Icons.sentiment_satisfied),
                  selected: _choice == 1,
                  backgroundColor: Colors.white,
                  selectedColor: Colors.orange[300],
                  onSelected: (_) {
                    setState(() {
                      _choice = 1;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Icon(Icons.sentiment_very_dissatisfied),
                  selected: _choice == 2,
                  backgroundColor: Colors.white,
                  selectedColor: Colors.blue[300],
                  onSelected: (_) {
                    setState(() {
                      _choice = 2;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Icon(Icons.sentiment_very_dissatisfied_outlined),
                  selected: _choice == 3,
                  backgroundColor: Colors.white,
                  selectedColor: Colors.deepPurple[300],
                  onSelected: (_) {
                    setState(() {
                      _choice = 3;
                    });
                  },
                ),
              ],
            ),
            // OverflowBar(
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           buttonPush1 = !buttonPush1;
            //         });
            //         _addEmotion('😊');
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor:buttonPush1? const Color.fromARGB(255, 241, 163, 189) : Colors.white,
            //       ),
            //       child: const Icon(Icons.sentiment_very_satisfied),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           buttonPush2 = !buttonPush2;
            //         });
            //         _addEmotion('😐');
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor:buttonPush2? Colors.orange : Colors.white,
            //       ),
            //       child: const Icon(Icons.sentiment_satisfied),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           buttonPush3 = !buttonPush3;
            //         });
            //         _addEmotion('😢');
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor:buttonPush3? const Color.fromARGB(255, 86, 165, 230) : Colors.white,
            //       ),
            //       child: const Icon(Icons.sentiment_very_dissatisfied),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           buttonPush4 = !buttonPush4;
            //         });
            //         _addEmotion('😠');
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor:buttonPush4?  const Color.fromARGB(255, 166, 126, 234) : Colors.white,
            //       ),
            //       child: const Icon(Icons.sentiment_very_dissatisfied_outlined),
            //     ),
            //   ],
            // ),
            ElevatedButton(  //本文も持って帰るように処理
              onPressed: () {
                //Navigator.of(context).pop(_title.text); //タイトルだけ表示
                //Navigator.pop(context, {'str': _title.text, 'emo' : _emoji}); //'emo': _choice
                Navigator.pop(context, {'str': _title.text, 'emo' : _choice}); //
              },
              child: const Text('追加'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              //手書きのほう
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  )
                );
              },
              child: const Icon(Icons.edit) //あとで変える
            ),
          ],
        ),
      ),
    );
  }
}
