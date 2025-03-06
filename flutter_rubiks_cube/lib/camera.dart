import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Camera extends StatelessWidget {
  const Camera({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera; //選択したカメラ受け取り

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      home: Screen(camera: camera),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  CameraPreviewScreenState createState() => CameraPreviewScreenState();
}

class CameraPreviewScreenState extends State<Screen> {
  late CameraController _controller;  //カメラコントローラ
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera, //カメラ指定
      ResolutionPreset.medium,  //解像度
    );

    _initializeControllerFuture = _controller.initialize(); //カメラ初期化
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _captureImageAndSave() async {
    try {
      await _initializeControllerFuture; //カメラの初期化完了を待つ

      // 画像をキャプチャ
      final image = await _controller.takePicture();
       print('画像がキャプチャされました: ${image.path}');

      // 保存ディレクトリを取得
      final directory = await getExternalStorageDirectory(); //外部ストレージに保存
      //final directory = await getApplicationDocumentsDirectory();

      print('保存ディレクトリ: ${directory?.path}');

      //ファイルに使用できない文字を置換
      String timestamp= DateTime.now().toIso8601String();
      //コロンをハイフンに置換
      timestamp = timestamp.replaceAll(';', '-');
      //他にも使えない文字があるか確認
      timestamp = timestamp.replaceAll(RegExp(r'[\\/:*?"<>|]'),'-');

      final String imagePath =
          '${directory!.path}/$timestamp.png';
      final File imageFile = File(imagePath);

      // 画像を保存
      await imageFile.writeAsBytes(await image.readAsBytes());
      print('画像が保存されました: $imagePath');
    } catch (e) {
      print('エラー: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カメラプレビュー'),
      ),
      body: Center(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // カメラが初期化された後にカメラプレビューを表示
              return LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;

                  // 白枠のサイズをカメラプレビューに対して調整
                  final borderSize = width * 0.3;

                  //final size = MediaQuery.of(context).size; //画面のサイズ取得

                

                  return Stack(
                    children: [
                      // カメラプレビュー
                      Center(
                             child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio, //カメラ比率
                            child: CameraPreview(_controller),
                          ),
                          ),
                      //白枠を中央に配置
                      Center(
                        child: Container(
                          width: borderSize,
                          height: borderSize,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2, //白枠の太さ
                            ),
                          ),
                        ),
                      ),
                      // キャプチャボタンを配置
                      Positioned(
                        bottom: 30,
                        left: 30,
                        child: ElevatedButton(
                          onPressed: _captureImageAndSave,
                          child: const Text('キャプチャ'),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              // 初期化中はローディングインジケーターを表示
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
