import 'package:flutter/material.dart';

//１
//画像フォルダは何もない余白部分をクリックしてimagesフォルダーを作成
// runApp(MaterialApp(
//   home:Scaffold(
//     //この一文だけでは動かない
//     //pubspec.yamlのassets部分を書き換える必要がある
//     //body:Image.asset('Images/idol.png'),
//     //ネットワークから画像を拾ってくる(画像のアドレスをコピーで取得できる)
//     body:Image.network('https://blog.kobedenshi.ac.jp/wp-content/uploads/2016/06/Hayabara-150x150.jpg'),
//   ),
// ));

//２
// runApp(MaterialApp(
//   home:Scaffold(
//     body:Column(
//       children: [
//         Image.asset('Images/idol.png'),
//         Image.asset('Images/dog_akitainu.png'),
//         Image.asset('Images/hone.png'),
//       ],
//     ),
//   ),
// ));

//３
// runApp(MaterialApp(
//   home:Scaffold(
//     body:ListView(
//       children: [
//         Image.asset('Images/idol.png'),
//         Image.asset('Images/dog_akitainu.png'),
//         Image.asset('Images/hone.png'),
//       ],
//     )
//   ),
// ));



//４
// final List<String> imageUrls = [
//     'https://www.kobedenshi.ac.jp/assets/img/info/campus/img_campus01.jpg',
//     'https://www.kobedenshi.ac.jp/assets/img/info/campus/img_campus02.jpg',
//     'https://www.kobedenshi.ac.jp/assets/img/info/campus/img_campus03.jpg',
//     // 必要に応じて画像URLを追加
//   ];

//   runApp(MaterialApp(
//     home:Scaffold(
//       body:ListView.builder(
//         itemCount: imageUrls.length, //リストの要素数
//         itemBuilder:(context,index){ //リストの各アイテムがどのように表示されるか
//           return Padding( //先にImage.networkから始めるVerを見せる
//           padding: const EdgeInsets.all(8.0),//余白は８の倍数がおすすめ(解像度の決め方も同じ)
//           child:Image.network(
//             imageUrls[index], // URLリストから画像URLを取得
//             //width: 100, // 幅
//             //height: 100, // 高さ
//             fit: BoxFit.cover, // 画像の表示方法
//             ),
//           );
//         }
//       )
//     ),
//   ));



//特別編(networkとassetsの両方を表示する方法)
// final List<String> imageUrls = [
//     'https://www.kobedenshi.ac.jp/assets/img/info/campus/img_campus01.jpg',
//     'https://www.kobedenshi.ac.jp/assets/img/info/campus/img_campus02.jpg',
//     'https://www.kobedenshi.ac.jp/assets/img/info/campus/img_campus03.jpg',
//   ];

//   final List<String> assetImagePaths = [
//     'assets/images/img_campus01.jpg',
//     'assets/images/img_campus02.jpg',
//     'assets/images/img_campus03.jpg',
//   ];

//   runApp(MaterialApp(
//     home: Scaffold(
//       body: ListView.builder(
//         itemCount: imageUrls.length + assetImagePaths.length, // 合計数
//         itemBuilder: (context, index) {
//           // インターネットの画像リストの範囲内ならImage.networkを使う
//           if (index < imageUrls.length) {
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Image.network(
//                 imageUrls[index],
//                 fit: BoxFit.cover,
//               ),
//             );
//           } else {
//             // インデックスが範囲を超えたらアセット画像を表示
//             int assetIndex = index - imageUrls.length;
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Image.asset(
//                 assetImagePaths[assetIndex],
//                 fit: BoxFit.cover,
//               ),
//             );
//           }
//         },
//       ),
//     ),
//   ));
//}