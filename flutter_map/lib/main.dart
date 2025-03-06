// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Flutter Google Maps Demo',
//       home: MapSample(),
//     );
//   }
// }

// class MapSample extends StatefulWidget {
//   const MapSample({super.key});
//   @override
//   State<MapSample> createState() => MapSampleState();
// }

// class MapSampleState extends State<MapSample> {
//   final Completer<GoogleMapController> _controller = Completer();

//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(34.69910347670642, 135.19290003672785),
//     zoom: 14.4746,
//   );

//   static const CameraPosition _kLake = CameraPosition(
//       bearing: 0,
//       target: LatLng(34.69910347670642, 135.19290003672785),
//       tilt: 0,
//       zoom: 40);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.hybrid,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label:const Text('神戸電子へ！'),
//         icon: const Icon(Icons.school),
//       ),
//     );
//   }

//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapView(),
    );
  }
}

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  // マップビューの初期位置
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));

  // マップの表示制御用
  late GoogleMapController mapController;

  // 現在位置の記憶用
  late Position _currentPosition; // 追加

  // 現在位置の取得方法
  _getCurrentLocation() async {
    // ignore: deprecated_member_use
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        // 位置を変数に格納する
        _currentPosition = position;

        print('CURRENT POS: $_currentPosition');

        // カメラを現在位置に移動させる場合
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      // await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    // 画面の幅と高さを決定する
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            // ここに地図を追加
            GoogleMap(
              initialCameraPosition: _initialLocation, //地図が最初に表示される位置(0,0)
              myLocationEnabled: true, //ユーザーの現在位置をアイコンで表示するかどうか
              myLocationButtonEnabled: true, //現在地に移動するかどうかのボタン
              mapType: MapType.normal, //地図の種類
              zoomGesturesEnabled: true, //地図の拡大が出来るかどうか
              zoomControlsEnabled: false, //ズームコントロールの表示切替
              //マップを動かしたり、ズーム出来たり動きをつけれる
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            // ここからボタンを表示するためのコードを追加
            // ズームイン・ズームアウトのボタンを配置

            //safeArea:上下のやつらをいい感じに調整してくれる(レイアウト調整)
            SafeArea(
              //右下にウィジェットを配置
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 100.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      // ズームインボタン
                      ClipOval( //ボタンの形を円形にする
                        child: Material(  //ボタンの背景色設定
                          color: Colors.blue.shade100, // ボタンを押す前のカラー
                          child: InkWell( //タッチ効果
                            splashColor: Colors.blue, // ボタンを押した後のカラー
                            child:const SizedBox( //ボタンサイズの設定
                              width: 50,
                              height: 50,
                              child: Icon(Icons.add),
                            ),
                            onTap: () {
                              //ズームイン
                              mapController.animateCamera(
                                CameraUpdate.zoomIn(),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      //　ズームアウトボタン
                      ClipOval(
                        child: Material(
                          color: Colors.blue.shade100, // ボタンを押す前のカラー
                          child: InkWell(
                            splashColor: Colors.blue, // ボタンを押した後のカラー
                            child: const SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(Icons.remove),
                            ),
                            onTap: () {
                              mapController.animateCamera(
                                CameraUpdate.zoomOut(),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  // 現在地表示ボタン
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange.shade100, // ボタンを押す前のカラー
                      child: InkWell(
                        splashColor: Colors.blue, // ボタンを押した後のカラー
                        child: const SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.my_location),
                        ),
                        onTap: () {
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                    _currentPosition.latitude, //緯度
                                    _currentPosition.longitude, //経度
                                ),
                                zoom: 18.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
