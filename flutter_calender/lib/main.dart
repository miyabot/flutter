import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calendar',
      //ダークモードの設定
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   brightness: Brightness.dark
      // ),
      home: const CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  //カレンダーの表示形式を管理(month:１か月分、twoweek:２週間分)
  CalendarFormat _calendarFormat = CalendarFormat.month; 
  DateTime _selectedDay = DateTime.now();//選択中の日付
  DateTime _focusedDay = DateTime.now();//フォーカスがあてられるページを管理

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー'),
      ),
      body: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        calendarFormat: _calendarFormat,
        calendarBuilders: CalendarBuilders(
          // 今日の日付のデザインを指定
          todayBuilder: (context, todayDay, focusDay) =>
          Center(child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfk3l4CBMcHpQXUHWtYZ3KOOBgyh8IeW5NHA&s'))),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          //_focusedDayの更新が無いと上手くいかない理由
          //初期値に８月が入っていた場合、どのページに切り替えても８月がずっと参照される
          _focusedDay = focusedDay;
        },
      ),
    );
  }
}
