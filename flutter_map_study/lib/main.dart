import 'package:flutter/material.dart';

void main() {
  runApp(const Base());
}
class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapStudy(),
    );
  }
}

class MapStudy extends StatefulWidget {
  const MapStudy({super.key});

  @override
  State<MapStudy> createState() => _MapStudyState();
}

class _MapStudyState extends State<MapStudy> {

   //Map型の宣言
    Map<String,dynamic> map = {
      'nowStock': 5,
      'idealStock':7,
      'ave':6.3,
      'tag':'machine',
    };

    late int result;

    @override
    void initState(){
      super.initState();
      result =  map['nowStock'] - map['idealStock'];
    }
    

    

    // //Mapの要素追加
    // map.addEntries([
    //   const MapEntry('ghi', 3),
    //   const MapEntry('jkl', 4)
    // ]);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map型の勉強'),
        backgroundColor: Colors.blue,
      ),
      //body: Text('${map['abc']}'), //map内の'abc'に対応した値が取れる
      //body: MapChange(map,'def',200)
      body:Text('$result')
    );
  }
}

//マップの情報を渡して情報を書き換える関数
Widget MapChange(Map m,String s,int val){
  m[s] = val;
  debugPrint('$m');
  return Text(m[s].toString());
}