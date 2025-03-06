import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const Base());
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:const SharedSample()
    );
  }
}

class SharedSample extends StatefulWidget {
  const SharedSample({super.key});

  @override
  State<SharedSample> createState() => _SharedSampleState();
}

class _SharedSampleState extends State<SharedSample> {

  //インスタンスの生成
  //final prefs = SharedPreferences.getInstance();
  final _controller = TextEditingController();
  String value = '';

  @override
  void initState(){
    super.initState();
    init();
  }

  //画面起動時に読み込むメソッド
  void init()async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //データの読み込み
      value = prefs.getString('text')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SharedPreferenceSample'),
      ),
      body:Padding(
        padding: const EdgeInsets.all(30.0),
        child:Column(
          children: <Widget>[
            //保存されたデータが表示される
            Text(value,style:const TextStyle(fontSize: 40.0)),
            TextField(
              controller: _controller,
            ),
            const SizedBox(height: 30.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: ()async{
                    final prefs =await SharedPreferences.getInstance();
                    //データの保存
                    prefs.setString('text', _controller.text);
                  }, 
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: ()async{
                    final prefs =await SharedPreferences.getInstance();
                    //データの読み込み
                    setState(() {
                      value = prefs.getString('text')!;  
                    });
                    
                  }, 
                  child: const Text('Load'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      value = '';
                      _controller.text = '';
                      // データの削除
                      prefs.remove('text');
                    });
                  },
                  child: const Text('Clear'),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}