//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const Base());
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:DrawingSample()
    );
  }
}

class DrawingSample extends StatefulWidget {
  const DrawingSample({super.key});

  @override
  State<DrawingSample> createState() => _DrawingSampleState();
}

class _DrawingSampleState extends State<DrawingSample> {
  final DrawingController _drawingController = DrawingController();

  // スクリーンショットコントローラーの追加
  final ScreenshotController _screenshotController = ScreenshotController();

  bool _showTools = true; // ツールバーの表示状態を管理するフラグ

  // 保存のカメラロールに写真を保存し、保存先を出力する
  Future storeImage() async {
    // ツールバーを非表示にする
    setState(() {
      _showTools = false;
    });

    // ストレージのパーミッションリクエスト
    var status = await Permission.storage.request();

    // ストレージのパーミッションが恒久的に拒否されていない場合
    if (!status.isPermanentlyDenied) {
      // スクリーンショットをキャプチャ
      final capturedImage = await _screenshotController.capture();

      // キャプチャした内容が空でなければ
      if (capturedImage != null) {
        // 画像をデバイスのギャラリーに保存
        final result = await ImageGallerySaverPlus.saveImage(
          capturedImage,
          name: "drawing_screenshot", // 保存する画像の名前
          quality: 100, // 画像の品質
          isReturnImagePathOfIOS: true, // iOSで画像パスを返すかどうか
        );
        print("保存先のパス: ${result['filePath']}");

        // 保存先パスを確認してエラーチェック
        if (result['filePath'] != null) {
          final savedFilePath = result['filePath'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("保存先: $savedFilePath")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("保存に失敗しました")),
          );
        }
      }
    }

    // ツールバーを再表示する
    setState(() {
      _showTools = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // MediaQueryを使って画面サイズを取得
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Screenshot(
              controller: _screenshotController,
              child: SizedBox(
              width: screenWidth * 0.8,  // 幅の設定
              height: screenHeight * 0.7, // 高さの設定  
              child: DrawingBoard(
                controller: _drawingController,
                background: Container(
                  width: screenWidth * 0.8, height: 
                  screenHeight * 0.5, color: 
                  Colors.white),
                showDefaultActions: _showTools, /// Enable default action options
                showDefaultTools: _showTools,   /// Enable default toolbar
              ),), 
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: storeImage,
        child: const Icon(Icons.add),
      ),
    );
  }

  ////描画ボ​​ードデータを取得
  // Future<void> _getImageData() async {
  //   print((await _drawingController.getImageData())?.buffer.asInt8List());
  // }

  // //JSONデータを取得
  // Future<void> _getJsonList() async {
  //   print(const JsonEncoder.withIndent('  ').convert(_drawingController.getJsonList()));
  // }
}