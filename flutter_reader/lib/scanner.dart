//コードスキャナーページ
import 'package:flutter/material.dart';
import 'package:flutter_reader/scandata.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class ScannerWidget extends StatefulWidget {
  const ScannerWidget({super.key});

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget>
    with SingleTickerProviderStateMixin {
  // スキャナーの作用を制御するコントローラーのオブジェクト
  MobileScannerController controller = MobileScannerController();
  bool isStarted = true; // カメラがオンしているかどうか
  bool isTorchOn = false; // トーチの状態を管理する変数
  bool isFrontCamera = false; // 前面/背面カメラの状態を管理する変数
  double zoomFactor = 0.0; // ズームの程度。0から1まで。多いほど近い

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF66FF99), // 上の部分の背景色
        title: const Text('スキャンしよう'),
      ),
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // カメラの画面の部分
              SizedBox(
                height: MediaQuery.of(context).size.width * 4 / 3,
                child: MobileScanner(
                  controller: controller,
                  fit: BoxFit.contain,
                  // QRコードかバーコードが見つかった後すぐ実行する関数
                  onDetect: (scandata) {
                    setState(() {
                      controller.stop(); // まずはカメラを止める
                      // 結果を表す画面に切り替える
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) {
                            // scandataはスキャンの結果を収める関数であり、これをデータ表示ページに渡す
                            return ScanDataWidget(scandata: scandata);
                          },
                        ),
                      );
                    });
                  },
                ),
              ),
              // ズームを調整するスライダー
              Slider(
                value: zoomFactor,
                // スライダーの値が変えられた時に実行する関数
                onChanged: (sliderValue) {
                  // sliderValueは変化した後の数字
                  setState(() {
                    zoomFactor = sliderValue;
                    controller.setZoomScale(sliderValue); // 新しい値をカメラに設定する
                  });
                },
              ),
              // 下の方にある3つのボタン
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // フラッシュのオン／オフを操るボタン
                  // トーチのオン／オフを制御するボタン
                  IconButton(
                    icon: Icon(
                      isTorchOn ? Icons.flash_on : Icons.flash_off,
                      color: isTorchOn ? const Color(0xFFFFDDBB) : Colors.grey,
                    ),
                    iconSize: 50,
                    onPressed: () {
                      setState(() {
                        isTorchOn = !isTorchOn;
                      });
                      controller.toggleTorch();
                    },
                  ),
                  // カメラのオン／オフのボタン
                  IconButton(
                    color: const Color(0xFFBBDDFF),
                    // オン／オフの状態によって表示するアイコンが変わる
                    icon: isStarted
                        ? const Icon(Icons.stop) // ストップのアイコン
                        : const Icon(Icons.play_arrow), // プレイのアイコン
                    iconSize: 50,
                    // ボタンが押されたらオン／オフを実行する
                    onPressed: () => setState(() {
                      isStarted ? controller.stop() : controller.start();
                      isStarted = !isStarted;
                    }),
                  ),
                  // アイコン前のカメラと裏のカメラを切り替えるボタン
                  IconButton(
                    color: const Color(0xFFBBDDFF),
                    icon: Icon(
                      isFrontCamera ? Icons.camera_front : Icons.camera_rear,
                    ),
                    iconSize: 50,
                    onPressed: () {
                      if (isStarted) {
                        controller.switchCamera();
                        setState(() {
                          isFrontCamera = !isFrontCamera;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

