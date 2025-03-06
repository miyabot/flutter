import 'package:flutter/material.dart';

void main() {
  runApp(const Base());
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:HomePage()
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ModalPage(id: 1,name:'モーダル'),
                          fullscreenDialog: true));
                },
                child: const Text('モーダル遷移')),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PushPage(id: 2,name:'プッシュ'),
                      ));
                },
                child: const Text('プッシュ遷移'))
          ],
        ),
      ),
    );
  }
}

class ModalPage extends StatelessWidget {
  const ModalPage({super.key,required this.id,required this.name});
  final int id;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('id = $id  name = $name'),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('前の画面へ'))
          ],
        ),
      ),
    );
  }
}

class PushPage extends StatelessWidget {
  const PushPage({super.key,required this.id,required this.name});
  final int id;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('id = $id  name = $name'),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('前の画面へ'))
          ],
        ),
      ),
    );
  }
}
