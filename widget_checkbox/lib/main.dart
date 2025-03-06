import 'package:flutter/material.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CheckBox(),
    );
  }
}

class CheckBox extends StatefulWidget {
  const CheckBox({super.key});

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  // チェックボックスの状態を管理するリスト
  //参照している中身は変更可能
  final List<bool> _checks = [false, false, false];

  @override
  Widget build(BuildContext context) {
    
    //１
    //   return Scaffold(
    //     body: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,

    //         //List.generate:指定された分アイテムを返す
    //         children: List.generate(_checks.length, (index) {
    //           return CheckboxListTile(
    //             title: Text('チェックボックス${index + 1}'),
    //             value: _checks[index],
    //             onChanged: (val) {
    //               setState(() {
    //                 _checks[index] = val!;
    //               });
    //             },
    //           );
    //         }),
    //       ),
    //     ),
    //   );

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 左に揃える
        //mainAxisAlignment: MainAxisAlignment.start,   // 上に揃える
        children: [
          const SizedBox(height: 80),
          Container(
            width: 400,
            height: 200,
            margin: const EdgeInsets.only(left: 20), // 左に余白を追加
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('どれが好き？', style: TextStyle(fontSize: 16)),
                  ),
                ),
                Column(
                  children: List.generate(_checks.length, (index) {
                    return CheckboxListTile(
                      title: Text('チェックボックス${index + 1}'),
                      value: _checks[index],
                      onChanged: (val) {
                        setState(() {
                          _checks[index] = val!;
                        });
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0), // 左に余白を追加
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(208, 110, 38, 205),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  // ボタン押下時の処理
                },
                child: const Text(
                  '送信',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
