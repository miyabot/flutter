import 'package:flutter/material.dart';
import 'package:ripod_study/mywidget.dart';
import 'package:ripod_study/mywidget1.dart';
import 'package:ripod_study/mywidget2.dart';
import 'package:ripod_study/mywidget3.dart';
import 'package:ripod_study/mywidget4.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  const app = MyApp();
  const scope = ProviderScope(child: app);
  runApp(scope);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          //child: MyWidget(),
          //child: MyWidget1(),
          //child: MyWidget2(),
          //child: MyWidget3(),
          child: MyWidget4(),
        ),
      ),
    );
  }
}