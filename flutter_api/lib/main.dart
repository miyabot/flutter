import 'package:flutter/material.dart'; // Flutterのマテリアルデザインパッケージ
import 'package:http/http.dart' as http; // HTTPリクエストを扱うパッケージ
import 'dart:convert'; // JSONデコード用

void main() {
  runApp(const MyApp()); // アプリケーションのエントリーポイント
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP練習アプリ', // アプリケーションのタイトル
      theme: ThemeData(primarySwatch: Colors.blue), // アプリのテーマカラー
      home: const HomePage(), // アプリケーションのホームページを指定
    );
  }
}

class UserService {
  // ユーザーのデータを取得するためのメソッド
  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse("https://randomuser.me/api?results=50&seed=galaxies"), // APIエンドポイント
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // JSONレスポンスのデコード
        final List<User> userList = [];

        for (var entry in data['results']) {
          userList.add(User.fromJson(entry)); // Userオブジェクトに変換
        }

        return userList; // ユーザーのリストを返す
      } else {
        throw Exception('Failed to load users. Status code: ${response.statusCode}'); // エラーハンドリング
      }
    } catch (e) {
      throw Exception('Failed to connect to the server. Error: $e'); // エラーハンドリング
    }
  }
}

// Nameクラス: Userクラスの中のnameフィールドを表す
class Name {
  final String first; // 名前の名部分
  final String last; // 名前の姓部分

  const Name ({
    required this.first,
    required this.last,
  });

  // JSONからNameオブジェクトを作成
  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(first: json['first'], last: json['last']);
  }
}

// Userクラス: APIから取得するユーザー情報を表す
class User {
  final String email; // ユーザーのメールアドレス
  final String picture; // ユーザーの画像URL
  final Name name; // ユーザーの名前

  const User ({
    required this.email,
    required this.picture,
    required this.name,
  });

  // JSONからUserオブジェクトを作成
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      picture: json['picture']['medium'], // 画像URL（中サイズ）
      name: Name.fromJson(json['name']),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<User>> futureUsers; // 非同期にユーザー情報を取得

  @override
  void initState() {
    super.initState();
    futureUsers = UserService().getUsers(); // ユーザー情報を取得する
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ユーザー')), // アプリバーのタイトル
      body: Center(
        child: FutureBuilder<List<User>>(
          future: futureUsers,
          builder: ((context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              // データが取得できた場合
              return ListView.separated(
                itemBuilder: (context, index) {
                  User user = snapshot.data?[index]; // ユーザー情報を取得
                  return ListTile(
                    title: Text(user.email), // メールアドレスを表示
                    subtitle: Text('${user.name.first} ${user.name.last}'), // 名前を表示
                    trailing: const Icon(Icons.chevron_right_outlined), // 矢印アイコン
                    onTap: (() => openPage(context, user)), // ユーザーの詳細ページを開く
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(color: Colors.black26); // アイテム間の区切り線
                },
                itemCount: snapshot.data!.length, // アイテムの数
              );
            } else if (snapshot.hasError) {
              // エラーが発生した場合
              return Text('Error: ${snapshot.error}');
            }
            return const CircularProgressIndicator(); // データ取得中のインジケーター
          }),
        ),
      ),
    );
  }

  // ユーザーの詳細ページを開くメソッド
  openPage(context, User user) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => UserPage(user: user) // UserPageに遷移
      )
    );
  }
}

class UserPage extends StatelessWidget {
  final User user; // 詳細表示するユーザー情報

  const UserPage({ Key? key, required this.user });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${user.name.first} ${user.name.last}')), // ユーザーの名前をタイトルに表示
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30), // 上部の余白
            Image.network(user.picture), // ユーザーの画像を表示
            const SizedBox(height: 30), // 下部の余白
            Text(user.email) // メールアドレスを表示
          ],
        ),
      ),
    );
  }
}
