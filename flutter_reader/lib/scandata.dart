import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ScanDataWidget extends StatefulWidget {
  final BarcodeCapture? scandata;
  const ScanDataWidget({super.key, this.scandata});

  @override
  State<ScanDataWidget> createState() => _ScanDataWidgetState();
}

class _ScanDataWidgetState extends State<ScanDataWidget> {
  String? bookTitle;
  String? bookAuthor;
  String? bookImgUrl;

  // Google Books APIにリクエストを送信
  Future<http.Response> fetchBooks(String keyword) {
    return http.get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$keyword'));
  }

  // Google Books APIのレスポンスを解析
  Map<String, dynamic> parseBooks(String responseBody) {
    final parsed = jsonDecode(responseBody);
    debugPrint('JSONデータの中身$parsed');
    return parsed;
  }

  @override
  void initState() {
    super.initState();
    _fetchBookData();
  }

  void _fetchBookData() {
    String codeValue = widget.scandata?.barcodes.first.rawValue ?? 'null';
    final isbnPattern = RegExp(r'(97[89]\d{10})');
    String? isbn = isbnPattern.stringMatch(codeValue);

    if (isbn != null) {
      fetchBooks(isbn).then((response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> books = parseBooks(response.body);
          var items = books['items'] as List;
          if (items.isNotEmpty) {
            var book = items[0]['volumeInfo'];
            setState(() {
              bookTitle = book['title'] ?? "タイトルなし";
              bookAuthor = book['authors']?.join(', ') ?? "著者なし";
              bookImgUrl = book['selfLink'] ? ['thumbnail'];
              //debugPrint('URLの内容$bookImgUrl');
            });
          }
        } else {
          setState(() {
            bookTitle = "書籍情報の取得に失敗";
            bookAuthor = "著者情報なし";
          });
        }
      }).catchError((e) {
        // エラー内容を確認するためのデバッグ情報
        print("API呼び出しエラー: $e");
        setState(() {
          bookTitle = "API呼び出しエラー";
          bookAuthor = "著者情報なし";
        });
      });
    }
    else{
      setState(() {
        bookTitle = "書籍情報の取得に失敗";
        bookAuthor = "著者情報なし";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String codeValue = widget.scandata?.barcodes.first.rawValue ?? 'null';
    final isbnPattern = RegExp(r'(97[89]\d{10})');
    String? isbn = isbnPattern.stringMatch(codeValue);
    String displayValue = isbn != null ? isbn : "データなし";

    BarcodeType? codeType = widget.scandata?.barcodes.first.type;
    String cardTitle = "[${'$codeType'.split('.').last}]";
    dynamic cardSubtitle = Text(codeValue,
        style: const TextStyle(fontSize: 23, color: Color(0xFF553311)));

    if (codeType == BarcodeType.url) {
      cardTitle = 'URLリンク';
      cardSubtitle = InkWell(
        child: Text(
          codeValue,
          style: const TextStyle(
            fontSize: 23,
            color: Color(0xFF1133DD),
            decoration: TextDecoration.underline,
            decorationColor: Color(0xFF1133DD),
          ),
        ),
        onTap: () async {
          if (await canLaunchUrlString(codeValue)) {
            await launchUrlString(codeValue);
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF66FF99),
        title: const Text('スキャンの結果'),
      ),
      body: Card(
        color: const Color(0xFFBBFFDD),
        elevation: 5,
        margin: const EdgeInsets.all(9),
        child: ListTile(
          title: Text(
            cardTitle,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cardSubtitle,
              if (bookTitle != null) Text("タイトル: $bookTitle"),
              if (bookAuthor != null) Text("著者: $bookAuthor"),
              if (bookImgUrl != null) // サムネイル画像が存在する場合のみ表示
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.network(bookImgUrl!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
