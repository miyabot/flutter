import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripod_study/s4.dart';

class MyWidget4 extends ConsumerWidget {
  const MyWidget4({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final s4 = ref.watch(s4NotifierProvider);

    final widget = s4.when(
      data:(d)=>Text(d) , 
      error: (e,s)=>Text('$e'), 
      loading: ()=>const Text('準備中')
    );

    final button = ElevatedButton(
      onPressed: (){
        final notifier = ref.read(s4NotifierProvider.notifier);
        notifier.updateState();
      }, 
      child: const Text('ボタン')
    ); 
    return Column(
      children: [
        widget,
        button
      ],
    );
  }
}