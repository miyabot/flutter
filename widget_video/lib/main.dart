import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

//コマンドプロンプトでstart ms-settings:developersから
//開発者モードを有効にする必要がある
void main() {
  //バインディングを確実に初期化する
  //おまじない
  WidgetsFlutterBinding.ensureInitialized(); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AudioPlayerPage(),
    );
  }
}

class AudioPlayerPage extends StatefulWidget {
  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  late AudioPlayer _player;

  @override
  //初期化の際に一度だけ呼ばれる
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  //ウィジェットが破棄されるときに呼ばれる
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    try {
      // 非同期で再生処理を実行し、結果を確認
      //AssetSourceはpubspec.yamlに書いたassetsの中からファイルを探す
      await _player.play(AssetSource('Morning.mp3'));
    } catch (e) {
      // エラーが発生した場合、メッセージを表示
      print('音声再生エラー: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _playSound, // 非同期処理で再生を実行
          child: const Text('Play'),
        ),
      ),
    );
  }
}
