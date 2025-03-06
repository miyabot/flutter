import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // 日付フォーマット用の正しいインポート
import 'package:table_calendar/table_calendar.dart';


void main() {
  initializeDateFormatting('ja', null).then((_) => runApp(const Base()));
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TableCalendarSample(),
    );
  }
}

class TableCalendarSample extends StatefulWidget {
  const TableCalendarSample({super.key});

  @override
  State<TableCalendarSample> createState() => _TableCalendarSampleState();
}

class _TableCalendarSampleState extends State<TableCalendarSample> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー３ですわよ',style: TextStyle(),),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            locale: 'ja_JP',
            selectedDayPredicate: (day){
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay,focusedDay){
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged:(focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
          ),
          const SizedBox(height:8.0),
        ],
      ),
    );
  }
}
