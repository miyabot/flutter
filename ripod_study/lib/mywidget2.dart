import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripod_study/s2.dart';

class MyWidget2 extends ConsumerWidget {
  const MyWidget2({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final s2 = ref.watch(s2NotifierProvider);

    final button = FloatingActionButton(
      onPressed:(){

        final notifier = ref.read(s2NotifierProvider.notifier);
        notifier.updateState();

      },
      child:const Icon(Icons.add),
    );

    //リストビュー
    final listview = ListView.builder(
      itemCount: s2.length,
      itemBuilder: (_,index){
        //index番目の文字
        final text = Text(s2[index]);
        return Card(child:text);
      }
    );

    return Scaffold(
      body: listview,
      floatingActionButton: button,
    );
  }
}