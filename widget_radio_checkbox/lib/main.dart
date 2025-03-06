import 'package:flutter/material.dart';

void main() => runApp(const Home());

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  //int?にすれば解決(null許容型)
  int _value = 0; // int型の変数.
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body:Center(
    //     child: Column(
    //       children: [
    //         RadioListTile(
    //           title: const Text('ラジオボタン１'),
    //           value: 1,
    //           groupValue: _value,
    //           onChanged: (int? val){
    //             setState(() {
    //               _value = val!;
    //             });
    //           }
    //         ),
    //         RadioListTile(
    //           title: const Text('ラジオボタン２'),
    //           value: 2,
    //           groupValue: _value,
    //           onChanged: (int? val){
    //             setState(() {
    //               _value = val!;
    //             });
    //           }
    //         ),
    //         RadioListTile(
    //           title: const Text('ラジオボタン３'),
    //           value: 3,
    //           groupValue: _value,
    //           onChanged: (int? val){
    //             setState(() {
    //               _value = val!;
    //             });
    //           }
    //         ),
    //       ],
    //     ),
    //   )
    // );

    //２
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Column内で左寄せを指定
          children: [
            const SizedBox(height: 80),
            Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                // Paddingで左右に余白を追加
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start, // 内部要素を左寄せ
                  children: [
                    const Text(
                      'どれが好き？',
                      style: TextStyle(fontSize: 16),
                    ),
                    RadioListTile(
                      title: const Text('リンゴ'),
                      value: 1,
                      groupValue: _value,
                      onChanged: (val) {
                        setState(() {
                          _value = val!;
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('ぶどう'),
                      value: 2,
                      groupValue: _value,
                      onChanged: (val) {
                        setState(() {
                          _value = val!;
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('レモン'),
                      value: 3,
                      groupValue: _value,
                      onChanged: (val) {
                        setState(() {
                          _value = val!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20), // コンテナと同じ余白を持たせる
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(208, 110, 38, 205),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  '送信',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
