import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'todo_page.dart';

void main() {
  runApp(const Base());
}

class Event {
  final String title;
  final String? description;

  Event({required this.title, this.description});
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectDay = DateTime.now();
  DateTime _focusDay = DateTime.now();

  // 日付ごとの予定を管理するマップ
  final Map<DateTime, List<Event>> _events = {};

  @override
  Widget build(BuildContext context) {
    // 選択された日付の予定を取得
    final selectedEvents = _events[_selectDay] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            selectedDayPredicate: (day) {
              return isSameDay(_selectDay, day);
            },
            onDaySelected: (selectDay, focusDay) {
              setState(() {
                _selectDay = selectDay;
                _focusDay = focusDay;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedEvents.length,
              itemBuilder: (context, index) {
                final event = selectedEvents[index];
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text(event.description ?? 'No description'),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        // 指定の予定を削除
                        selectedEvents.removeAt(index);
                        if (selectedEvents.isEmpty) {
                          _events.remove(_selectDay);
                        }
                      });
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // TodoPage から予定を取得
          final result = await Navigator.push<Map<String, String>>(
            context,
            MaterialPageRoute(builder: (context) => const TodoPage()),
          );

          if (result != null) {
            setState(() {
              // 新しいイベントを作成
              final newEvent = Event(
                title: result['title']!,
                description: result['description'],
              );

              // 選択された日付の予定リストに追加
              if (_events[_selectDay] != null) {
                _events[_selectDay]!.add(newEvent);
              } else {
                _events[_selectDay] = [newEvent];
              }
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
