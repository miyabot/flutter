// import 'package:flutter/material.dart';

// void main() {
//   fetchData();
//   print('データを待たずに処理を進めています');
// }

// String fetchData() {
//   // 非同期処理をシミュレート
//   Future.delayed(Duration(seconds: 3), () {
//     print('データが読み込まれました');
//     return 'データ';
//   });

//   return 'データ読み込み中';
// }

import 'package:flutter/material.dart';

void main() async {
  String data = await fetchData();
  print('データが取得できました: $data');
}

Future<String> fetchData() async {
  // 非同期処理をシミュレート
  await Future.delayed(Duration(seconds: 3), () {
    print('データが読み込まれました');
  });
  return 'データ';
}
