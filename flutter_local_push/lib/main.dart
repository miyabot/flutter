import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationDemo(),
    );
  }
}

class NotificationDemo extends StatefulWidget {
  @override
  _NotificationDemoState createState() => _NotificationDemoState();
}

class _NotificationDemoState extends State<NotificationDemo> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    //プラグインのインスタンスを作成
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //初期化設定
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // 通知をタップした際の処理を書くこもできる
        print('通知をタップ: ${response.payload}');
      },
    );
  }

  // 通知を送る関数
  Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your_channel_id', // チャンネルID(名前は被らなければなんでもOK)
      'your_channel_name', // チャンネル名
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    // 通知を表示
    await flutterLocalNotificationsPlugin.show(
      0, // 通知のID
      '通知タイトル', // タイトル
      'これは通知の内容です', // 内容
      notificationDetails,
      payload: '通知のペイロード',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('通知デモ'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: showNotification, // ボタンを押したときに通知を送信
          child:const Text('通知を送る'),
        ),
      ),
    );
  }
}
