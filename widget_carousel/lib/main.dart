import 'package:flutter/material.dart'; // Flutterのマテリアルデザインを使用するためのパッケージ
import 'package:carousel_slider/carousel_slider.dart'; // カルーセル（スライダー）機能を提供するパッケージ
import 'package:google_fonts/google_fonts.dart';

// アプリのエントリーポイント
void main() {
  runApp(MyApp()); // アプリ全体を起動する
}

// StatelessWidgetを継承したMyAppクラスを定義
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: CarouselDemo(), // アプリのメイン画面としてCarouselDemoウィジェットを表示
    );
  }
}

// カルーセルを表示するクラスCarouselDemo
class CarouselDemo extends StatelessWidget {
  // 画像のURLを格納するリストを定義
  final List<String> imgList = [
    'https://service-cdn.coconala.com/resize/1220/1240/service_images/original/2c017b67-4767567.jpeg',
    'https://cdn-ak.f.st-hatena.com/images/fotolife/y/yamacastle/20210427/20210427125951.jpg',
    'https://1stplace.co.jp/wp/wp-content/uploads/2023/05/%E3%83%9C%E3%83%83%E3%82%AB%E3%83%87%E3%83%A9%E3%83%99%E3%83%AA%E3%82%BF_%E3%82%B5%E3%83%A0%E3%83%8D_01.jpg',
    'https://embed.pixiv.net/artwork.php?illust_id=109389922&mdate=1687845978',
    'https://ogre.natalie.mu/media/news/music/2022/0724/Ado_kamippoina.jpg?imwidth=750&imdensity=1',
    'https://iloveutaite.com/wp-content/uploads/2022/07/maxresdefault-44.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Flutter Carousel Example')), // アプリバーを表示し、タイトルを設定
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'サムネイル一覧',
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2, // 文字間のスペースを調整
              ),
            ),
            const SizedBox(height: 8),
            CarouselSlider(
                items: imgList
                    .map((e) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PreviewPage(previewUrl: e)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(15.0), // ここで角を丸くする
                                child: SizedBox(
                                  width: 300, // 画像の幅を一定に設定
                                  height: 200, // 画像の高さを一定に設定
                                  child: Image.network(e,
                                      fit: BoxFit.cover), // 画像を枠内に収める
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                  initialPage: 0,
                  autoPlay: true,
                  //enlargeCenterPage: true
                )),
          ],
        ),
      ),
    );
  }
}

class PreviewPage extends StatelessWidget {
  final String previewUrl;
  const PreviewPage({super.key, required this.previewUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft, // 左寄せに設定

              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.keyboard_backspace_rounded),
                iconSize: 64,
                color: Colors.white,
              ),
            ),
            Image.network(previewUrl),
          ],
        ),
      ),
    );
  }
}
