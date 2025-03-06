import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripod_study/s1.dart';

class MyWidget1 extends ConsumerWidget {
  const MyWidget1({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    //buildの中で指定したプロバイダーをwatch(見続ける)
    //別の人が値を変更しても同期が出来る
    final s1 = ref.watch(s1NotifierProvider);

    //listen(耳をすまし続ける)
    //状態が変わった時に命令を出すことができる(ダイアログの表示、スナックバーの表示などなど)
    ref.listen(
      s1NotifierProvider, 
      (oldState,newState){
        //スナックバーを表示する
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$oldStateから$newStateに変化しました')
          ),
        );
      }
    );

    //Notifier(編集者)


    final button = ElevatedButton(
      onPressed:(){
        //画面を触ったらNotifierをread(読み取る)
        //読み取り続けるわけではないため、別の人が変更しても気付けない
        final notifier = ref.read(s1NotifierProvider.notifier);

        //状態を変更
        notifier.updateState();
      }, 
      child: const Text('ボタン'),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$s1'),
        button,
      ],
    );
  }
}