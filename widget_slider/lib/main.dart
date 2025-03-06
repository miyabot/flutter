import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SliderWidget(),
    );
  }
}

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {

  //変数名や関数名の頭にアンダーバーを付ける→プライベート変数化
  //プライベート変数化：同一ファイル内でしか使えなくなる
  double _value = 0.0;
  double _startValue = 0.0;
  double _endValue = 0.0;

  void _changeSlider(double e) => setState(() { _value = e; });
  void _startSlider(double e) => setState(() { _startValue = e; });
  void _endSlider(double e) => setState(() { _endValue = e; });

  @override
  Widget build(BuildContext context) {

    //１
    // return Scaffold(
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         //スライダー
    //         Slider(
    //           value: _value, //スライダーの位置
    //           onChanged:(double val)=>setState(() {
    //             //_value:現在のスライダーの位置
    //             //val:新しいスライダーの位置
    //             _value = val;
    //             debugPrint('$_value');//0~1
    //           }),
    //         )
    //       ],
    //     ),
    //   ),
    // );

    //２
    // return Scaffold(
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         //桁数指定
    //         Text(_value.toStringAsFixed(2),
    //           style: const TextStyle(
    //             fontSize: 64
    //           ),
    //         ),
    //         Slider(
    //           min:0, //最小値
    //           max:100, //最大値
    //           value: _value, //スライダーの位置
    //           onChanged:(double val)=>setState(() {
    //             _value = val;
    //           }),
    //         )
    //       ],
    //     ),
    //   ),
    // );

  //３
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          'スライダーの基本',
          style: TextStyle(
            color:Colors.white,
            fontSize: 32
          ),
        ),
        backgroundColor: Colors.cyan,
      ),
      body:Center(
        child: Padding(
          padding: const EdgeInsets.all(64.0),
          child: Column(
            children: [
              Text('現在の値:$_value'),
              Text('開始時の値:$_startValue'),
              Text('終了時の値:$_endValue'),
              Slider(
                label: '$_value', //スライダーを動かしている時に表示されるラベル
                min: 0,   //最小値
                max: 360,  //最大値
                value: _value,  //スライダーの値(double)
                activeColor: Colors.orange, //スライダーの選択範囲の線の色
                inactiveColor: Colors.blueAccent, //スライダーの未選択範囲の線の色
                //divisions: 10,  //メモリの数値を決めるための値で、(max - min) / divisionsの計算で値が決定する
                onChanged: _changeSlider, //値を変更した時に動作する
                onChangeStart: _startSlider,  //値を変更開始した時に動作する
                onChangeEnd: _endSlider,  //値を変更終了した時に動作する
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Transform.rotate(
                  angle: _value * (3.141592 / 180),
                  //angle:_value,
                  child:Image.network(
                    //'https://blog.kobedenshi.ac.jp/wp-content/uploads/2016/06/Hayabara-150x150.jpg',
                    'https://icon-pit.com/wp-content/uploads/2024/06/19181.png'
                    //width: 15 * _value,
                    //height: 15 * _value,
                  )
                ),
              )
              
            ],
          ),
        ),
      )
    );
  }
}