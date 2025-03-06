import 'package:flutter/material.dart';

void main() {
  runApp(const Base());
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DentakuSample());
  }
}

class DentakuSample extends StatefulWidget {
  const DentakuSample({super.key});

  @override
  State<DentakuSample> createState() => _DentakuSampleState();
}

class _DentakuSampleState extends State<DentakuSample> {
  List<String> numberList = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 400,
              color: Colors.white,
              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            Expanded(
                child: GridView.builder(
                    gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, //縦の数
                        mainAxisSpacing: 10.0, // 主要軸(縦)の間隔
                        crossAxisSpacing: 10.0, // 横軸の間隔
                        childAspectRatio: 16/9, // アスペクト比
                    ),
                    itemCount: numberList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.pink,
                        child: Center(child: Text(numberList[index])),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
