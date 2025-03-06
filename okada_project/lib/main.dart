import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:okada_project/drawing.dart';
import 'package:okada_project/my_icons_icons.dart';
import 'package:okada_project/paint.dart';
import 'package:okada_project/write.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart'; //日本語
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() {
  //日本語の何か
  initializeDateFormatting().then((_) => runApp(const Home()));
  //runApp(const MyApp());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  //final String value;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  //CalendarFormat _calendarFormat = CalendarFormat.month;

  //今の日付
  DateTime _focusedDay = DateTime.now();

  //選んだ日付
  DateTime _selectedDay = DateTime.now();

  final Set<DateTime> _selectedDays = <DateTime>{}; //単一複数日付選択するための変数

  final DateTime _currentDay = DateTime.now();

  //期間
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime? _rangestart;
  DateTime? _rangeend;

  final Map _yotei = {}; //日記を保存する
  final Map _title = {};
  late String _str;

  final Map _emotion = {}; //感情
  late String _emo;
  late int _cho; //choicechipの番号

  late String _days; //日付

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double screenWidth = size.width; //スクリーンの幅
    final double screenHeight = size.height; //スクリーンの高さ
    return Scaffold(
      appBar: AppBar(
        title: const Text('日記アプリ'),
        backgroundColor: const Color.fromARGB(255, 241, 163, 189),
        leading: const Icon(Icons.calendar_month),
      ),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.5, //画面サイズの半分
            child: TableCalendar(
              locale: 'ja', //日本語
              startingDayOfWeek: StartingDayOfWeek.sunday, //日曜日始まり
              firstDay: DateTime.utc(2010, 1, 1), //最初の日
              lastDay: DateTime.utc(2030, 12, 31), //最後の日

              //今の日付
              focusedDay: _focusedDay,
              //選んだ日付マーク
              currentDay: _currentDay,
              //calendarFormat: _calendarFormat,
              

              headerStyle: const HeaderStyle(
                formatButtonVisible: false, //calendarformat無くす
                titleCentered: true, //表示を真ん中に出す
              ),

              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day); //一致しているかどうか
              },
              //isSameDayがTrueを返すとfocuseが更新される
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  debugPrint('$selectedDay');
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _rangestart = null;
                  _rangeend = null;
                });
              },

              //期間設定
              rangeSelectionMode: _rangeSelectionMode,
              rangeStartDay: _rangestart,
              rangeEndDay: _rangeend,
              onRangeSelected: (start, end, focusedDay) {
                setState(() {
                  _rangestart = start;
                  _rangeend = end;
                });
              },

              // onFormatChanged: (format) {
              //   setState(() {
              //     _calendarFormat = format;
              //   });
              // },
              onPageChanged: (focusedDay) {
                //月や週を切り替えたときに呼び出される
                _focusedDay = focusedDay;
              },
            ),
          ),
          TextButton(
              //今日に戻るボタン
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime.now();
                });
              },
              child: const Text('今日')),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.white,
                width: screenWidth * 0.4,
                margin:
                    const EdgeInsets.all(5), //margin:EdgeInsets.all 上下左右に余白を入れる
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  textAlign: TextAlign.center,
                  '日付: ${_selectedDay.year}/${_selectedDay.month}/${_selectedDay.day}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
  color: Colors.white,
  width: screenWidth * 0.4,
  margin: const EdgeInsets.all(5),
  padding: const EdgeInsets.all(16.0),
  child:Row(
    children: [
      const Text(
        '気分:',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      // 修正: map の型を明示
      if (_emotion[_selectedDay] != null)
        //_emotion[_selectedDay][0]!
        ..._emotion[_selectedDay]!
      else
        const Text('------------'),
    ],
  ),
)
            ],
          ),
          
          // 選択した日付の内容を表示
          Container(
            color: Colors.white,
            width: screenWidth*0.82,
            margin:
                const EdgeInsets.all(10), //margin:EdgeInsets.all 上下左右に余白を入れる
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'タイトル : ${_title[_selectedDay]?.join('\n') ?? '入力されていません'}',
                  //_yotei[_selectedDay]?.join('\n') ?? '入力されていません', // 内容を表示
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endDocked, //中央配置
      // floatingActionButton: FloatingActionButton(
      //   //日記画面遷移
      //   onPressed: () async {
      //     final _str = await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => ButtonPage(selectedDay: _selectedDay),
      //         //builder: (context) =>MyApp(),
      //       ),
      //     );
      //     if (_str != null && _str.isNotEmpty) {
      //       setState(() {
      //         if (_yotei[_selectedDay] == null) {
      //           _yotei[_selectedDay] = [];
      //         }
      //         _yotei[_selectedDay]!.add(_str); // 日記を保存
      //       });
      //     }
      //   },
      //   child: const Icon(Icons.create),
      // ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 22.0),
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.create),
              backgroundColor: Colors.blue,
              label: "日記を書く",
              onTap: () async {
                // final _str = await Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             ButtonPage(selectedDay: _selectedDay,)));
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ButtonPage(selectedDay: _selectedDay),
                    //builder: (context) => ButtonPage(),
                  ),
                );

                if (result != null && result is Map) {
                  final _str = result['str'];
                  final _emo = result['emo'];
                  debugPrint('$_emo');

                  if (_str != null && _str.isNotEmpty) {
                    setState(() {
                      if (_title[_selectedDay] == null) {
                        _title[_selectedDay] = [];
                      }
                      _title[_selectedDay]!.add(_str); // 日記タイトルを保存
                    });
                  }
                  if (_emo != null) {
                    setState(() {
                      if (_emotion[_selectedDay] == null) {
                        _emotion[_selectedDay] = [];
                      }
                      switch(_emo){
                        case 0:
                          //_emotion[_selectedDay]!.add(const Icon(Icons.sentiment_very_satisfied));
                          _emotion[_selectedDay].add(const Icon(MyIcons.veryHappy));
                          break;
                        case 1:
                          _emotion[_selectedDay]!.add(const Icon(Icons.sentiment_satisfied));
                          break;
                        case 2:
                          _emotion[_selectedDay]!.add(const Icon(Icons.sentiment_very_dissatisfied));
                          break;
                        case 3:
                          _emotion[_selectedDay]!.add(const Icon(Icons.sentiment_very_dissatisfied_outlined));
                          break;
                        // default:
                        //   _emotion[_selectedDay]!.add(const Text('ーーーーーーーー'));
                      }
                      //_emotion[_selectedDay]!.add(_emo);
                    });
                  }

                }
                // if (_str != null && _str.isNotEmpty) {
                //   setState(() {
                //     if (_title[_selectedDay] == null) {
                //       _title[_selectedDay] = [];
                //     }
                //     _title[_selectedDay]!.add(_str); // 日記を保存
                //     // if (_yotei[_selectedDay] == null) {
                //     //   _yotei[_selectedDay] = [];
                //     // }
                //     // _yotei[_selectedDay]!.add(_str); // 日記を保存
                //   });
                // }
                // if(_emo != null && _emo.isNotEmpty){
                //   setState(() {
                //     if(_emotion[_selectedDay]==null){
                //       _emotion[_selectedDay]=[];
                //     }
                //     _emotion[_selectedDay]!.add(_emo);
                //   });
                // }
              },
              labelStyle: const TextStyle(fontWeight: FontWeight.w500) //太字
              ),
          SpeedDialChild(
              child: const Icon(Icons.edit),
              backgroundColor: Colors.green,
              label: "絵日記を描く",
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ));
              },
              labelStyle: const TextStyle(fontWeight: FontWeight.w500)),
          SpeedDialChild(
              child: const Icon(Icons.edit),
              backgroundColor: Colors.green,
              label: "絵日記を描く2",
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaintPage(),
                    ));
              },
              labelStyle: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // void addEmotion(String emotion) {
  //   setState(() {
  //     if (_emotion[_selectedDay] == null) {
  //       _emotion[_selectedDay] = [];
  //     }
  //     _emotion[_selectedDay]!.add(emotion); // 感情を保存
  //   });
  // }
}
