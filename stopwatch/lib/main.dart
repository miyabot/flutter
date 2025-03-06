 import 'dart:async'; // Timerクラスを使用するためのdartパッケージ
 import 'package:flutter/material.dart'; // FlutterのUIライブラリ

void main() {
  runApp(const Home()); // アプリケーションのエントリーポイント
}

// アプリ全体を包むStatelessWidget
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: StopWatchPage()); // メイン画面にStopWatchPageを指定
  }
}

// // ストップウォッチ機能を提供するStatefulWidget
// class StopWatchPage extends StatefulWidget {
//   const StopWatchPage({super.key});

//   @override
//   State<StopWatchPage> createState() => _StopWatchPageState(); // Stateを生成
// }

// class _StopWatchPageState extends State<StopWatchPage> {
  
//   //late:遅延初期化(あとで初期化したい場合に使用する)
//   late Stopwatch _stopwatch; // 時間経過を管理するためのstopwatch
//   late Timer _timer; // 定期的にUIを更新するためのTimer

//   // 表示用の時間（分:秒.ミリ秒）をフォーマット
//   String _formattedTime() {
//     final elapsed = _stopwatch.elapsed; //elapsed:経過時間の取得
//     //inMinutes:分数が入っている % 60で0~59に収まるようにしている(100分→40分の表記になる)
//     String minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0'); // 分を2桁で表示
//     String seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0'); // 秒を2桁で表示

//     //ミリ秒(1000ミリ秒=1秒):1523の場合→1秒523ミリ秒になるため、% 1000で0~999に収まるようにしている。
//     //そこから2桁にするために~/10(整数除算)で調整している。
//     String milliseconds = (elapsed.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0'); // ミリ秒を2桁で表示
//     return '$minutes:$seconds.$milliseconds';
//   }

//   @override
//   //initState:StatefulWidgetで一度だけ呼ばれる初期化メソッド
//   void initState() {
//     super.initState();  //親クラスの初期化も行う
//     _stopwatch = Stopwatch(); // Stopwatchのインスタンスを初期化(変数宣言だけだと中身は空っぽ)

//     //Timer.periodic は指定した間隔ごとに繰り返し実行される関数
//     _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
//       setState(() {}); // 30msごとに画面を更新（時間表示をリアルタイムに更新するため）
//     });
//   }

//   @override
//   //dispose:リソースの解放
//   void dispose() {
//     _timer.cancel(); // 画面が破棄されたときにTimerを停止
//     super.dispose(); //親クラスもついでに解放
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Stopwatch'), // アプリバーのタイトルを設定
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center, // コンテンツを中央に配置
//           children: [
//             Text(
//               _formattedTime(), // 時間を表示
//               style: const TextStyle(
//                 fontSize: 48, // 文字の大きさを設定
//                 fontWeight: FontWeight.bold, // 文字を太字にする
//               ),
//             ),
//             const SizedBox(height: 40), // 縦のスペースを追加
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center, // ボタンを横に並べて中央に配置
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _stopwatch.start(); // ストップウォッチを開始
//                     });
//                   },
//                   child: const Text('Start'), // ボタンのラベル
//                 ),
//                 const SizedBox(width: 20), // ボタン間のスペース
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _stopwatch.stop(); // ストップウォッチを停止
//                     });
//                   },
//                   child: const Text('Stop'), // ボタンのラベル
//                 ),
//                 const SizedBox(width: 20), // ボタン間のスペース
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _stopwatch.reset(); // ストップウォッチをリセット
//                     });
//                   },
//                   child: const Text('Reset'), // ボタンのラベル
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class StopWatchPage extends StatefulWidget {
  const StopWatchPage({super.key});

  @override
  State<StopWatchPage> createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  Timer? _timer;
  int _hour = 23;
  int _minute = 59;
  int _seconds = 59;
  int _totalSeconds = 0;

  bool flg = false;
  bool isSet = false; // スライダー表示のフラグ

  void _startTimer() {
    _totalSeconds = _hour * 3600 + _minute * 60 + _seconds;

    if (_timer != null) {
      _timer?.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        flg = true;
        isSet = false;
        if (_totalSeconds > 0) {
          _totalSeconds--;
          _hour = _totalSeconds ~/ 3600;
          _minute = (_totalSeconds % 3600) ~/ 60;
          _seconds = _totalSeconds % 60;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void _stopTimer() {
    setState(() {
      flg = false;
    });

    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _timer?.cancel();
      _hour = 0;
      _minute = 0;
      _seconds = 0;
    });
  }

  void _setTime() {
    setState(() {
      isSet = !isSet; // セットボタンを押した後にスライダーを表示
    });
  }

  @override
  Widget build(BuildContext context) {
    // 2桁表示のために各値をStringに変換し、padLeftで桁揃え
    String formattedHour = _hour.toString().padLeft(2, '0');
    String formattedMinute = _minute.toString().padLeft(2, '0');
    String formattedSeconds = _seconds.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('タイマーアプリ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$formattedHour : $formattedMinute : $formattedSeconds', // 残りの時間を表示
              style: const TextStyle(fontSize: 104, color: Colors.lightBlue),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (!flg) ? _startTimer : _stopTimer,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 100), // ボタンのサイズを調整
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // 四角い形状
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 中央に配置
                    children: [
                      (!flg)
                          ? const Icon(Icons.access_time,
                              size: 40) // スタート用の大きなアイコン
                          : const Icon(Icons.access_time, size: 40), // ストップ用の大きなアイコン
                      const SizedBox(height: 10), // アイコンとテキストの間にスペース
                      (!flg)
                          ? const Text('スタート', style: TextStyle(fontSize: 20))
                          : const Text('ストップ', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: (!flg) ? _resetTimer : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 100),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // 四角い形状
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 中央に配置
                    children: const [
                      Icon(Icons.refresh, size: 40), // クリア用の大きなアイコン
                      SizedBox(height: 10),
                      Text('クリア', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: (!flg) ? _setTime : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 100),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // 四角い形状
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 中央に配置
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 40), // セット用の大きなアイコン
                      SizedBox(height: 10),
                      Text('セット', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (isSet) ...[
              // SizedBox(
              //     width: 650,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text('時: $_hour'),
              //         Expanded(child: 
              //         Slider(
              //           min: 0,
              //           max: 23,
              //           value: _hour.toDouble(),
              //           divisions: 23,
              //           onChanged: (double h) {
              //             setState(() {
              //               _hour = h.toInt();
              //             });
              //           },
              //         ),
              //         )
              //       ],
                  
              //     )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('時: $_hour'),
                  Slider(
                    min: 0,
                    max: 23,
                    value: _hour.toDouble(),
                    divisions: 23,
                    onChanged: (double h) {
                      setState(() {
                        _hour = h.toInt();
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('分: $_minute'),
                  Slider(
                    min: 0,
                    max: 59,
                    value: _minute.toDouble(),
                    divisions: 59,
                    onChanged: (double m) {
                      setState(() {
                        _minute = m.toInt();
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('秒: $_seconds'),
                  Slider(
                    min: 0,
                    max: 59,
                    value: _seconds.toDouble(),
                    divisions: 59,
                    onChanged: (double s) {
                      setState(() {
                        _seconds = s.toInt();
                      });
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // タイマーを破棄
    super.dispose();
  }
}
