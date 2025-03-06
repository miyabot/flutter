import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripod_study/s3.dart';

class MyWidget3 extends ConsumerWidget {
  const MyWidget3({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final s3 = ref.watch(s3NotifierProvider);

    //when(～な時)
    final widget = s3.when(
      //準備OK
      data: (d) =>Text('$d'), 

      //エラー(e：どんなエラー、s：どこでエラー)
      error: (e,s) =>Text('エラー$e'),

      //準備中 
      loading: () =>const Text('準備中..'),
    );

    final button = ElevatedButton(
      onPressed: (){
        final notifier = ref.read(s3NotifierProvider.notifier);
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