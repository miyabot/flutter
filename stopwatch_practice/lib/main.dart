import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:StopWatchSample()
    );
  }
}
class StopWatchSample extends StatefulWidget {
  const StopWatchSample({super.key});

  @override
  State<StopWatchSample> createState() => _StopWatchSampleState();
}

class _StopWatchSampleState extends State<StopWatchSample> {
  late Timer _timer; //late:遅延初期化(あとで初期化したい場合に使用する)
  late Stopwatch _stopwatch;

  @override
  void initState(){
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {}); // 30msごとに画面を更新（時間表示をリアルタイムに更新するため）
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${_stopwatch.elapsed.inHours.toString().padLeft(2,'0')}:${_stopwatch.elapsed.inMinutes.toString().padLeft(2,'0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2,'0')}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    _stopwatch.start(); 
                    debugPrint('時:${_stopwatch.elapsed.inHours}\n分:${_stopwatch.elapsed.inMinutes}\n秒${_stopwatch.elapsed.inSeconds}');
                  }, 
                  child:const Text('スタート')
                ),
                ElevatedButton(
                  onPressed: (){
                    _stopwatch.stop(); 
                    debugPrint('時:${_stopwatch.elapsed.inHours}\n分:${_stopwatch.elapsed.inMinutes}\n秒${_stopwatch.elapsed.inSeconds}');
                  }, 
                  child:const Text('ストップ')
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

