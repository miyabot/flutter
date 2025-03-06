import 'package:flutter/material.dart';
import 'package:inaoka_project/alarm.dart';
import 'package:inaoka_project/home.dart';
import 'package:inaoka_project/sleep.dart';
import 'package:inaoka_project/weight.dart';

void main() {
  runApp(const Base());
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Main());
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;

  // 状態管理するデータ
  double _currentWeight = 0.0;

  // 体重データを更新するコールバック
  void _updateWeight(double newWeight) {
    setState(() {
      _currentWeight = newWeight;
    });
  }


  // 画面を動的に生成する getter
  List<Widget> get _pages => [
        Home(weight: _currentWeight,sleep: 0,),
        Weight(onWeightUpdated: _updateWeight),
        const Sleep(),
        const Alarm(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タイトルテキスト'),
        backgroundColor: Colors.green[300],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,  // 最新データを反映
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int selectIndex) => setState(() {
          _currentIndex = selectIndex;
        }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.accessibility), label: '体重'),
          BottomNavigationBarItem(icon: Icon(Icons.bed), label: '睡眠'),
          BottomNavigationBarItem(icon: Icon(Icons.access_alarm), label: 'アラーム'),
        ],
      ),
    );
  }
}
