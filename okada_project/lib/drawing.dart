import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; //RenderRepaintBoundary
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart'; //保存
import 'dart:typed_data';
import 'dart:ui' as ui;

//Pathにはcolorプロパティがない

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //開発中のバナーを非表示にする
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: ColorPallete(
        notifier: ColorPalleteNotifier(),
        child: const MyhomePage(),
      ),
    );
  }
}

class MyhomePage extends StatefulWidget {
  const MyhomePage({super.key});

  @override
  State<MyhomePage> createState() => _MyhomePageState();
}

class _MyhomePageState extends State<MyhomePage> {
  final GlobalKey _globalKey = GlobalKey();

  //Future _saveToGallery() async {
  _saveToGallery() async { //保存機能
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      //写真の名前
      final result = await ImageGallerySaverPlus.saveImage(pngBytes,
          quality: 100,
          name: "drawing_${DateTime.now().millisecondsSinceEpoch}");
      if (result['成功']) {
        // ScaffoldMessenger : SnackBarを出す
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('保存しました')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('保存に失敗')));
      }
    } catch (e) {
      //tryで発生した例外の処理かく
      //print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('エラーが発生しました。')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('絵日記'),
        backgroundColor: const Color.fromARGB(255, 241, 163, 189),
        //leading: const Icon(Icons.edit),
        actions: [
          IconButton(
            alignment: Alignment.center, //位置
            icon: const Icon(Icons.save),
            onPressed: () {
              _saveToGallery; //保存機能
            },
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CanvasArea(),
          Align(
            alignment: Alignment.bottomCenter,
            child: ColorSelectionWidget(),
          ),
          Align(
            alignment: Alignment.topRight,
            child: UndoButtonBar(),
          ),
          RepaintBoundary(
            key: _globalKey,
          ),
        ],
      ),
    );
  }
  
}

class CanvasArea extends StatefulWidget {
  @override
  _CanvasAreaState createState() => _CanvasAreaState();
}

class _CanvasAreaState extends State<CanvasArea> {
  late ColorPath _colorPath;

  void _onPanStart(DragStartDetails details) {
    _colorPath.setFirstPoint(details.localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _colorPath.updatePath(details.localPosition);
    setState(() {});
  }

  void _onPanEnd(DragEndDetails details) {
    ColorPath.paths.add(_colorPath);
    setState(() {
      _colorPath = ColorPath(ColorPallete.of(context).selectedColor);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colorPath = ColorPath(ColorPallete.of(context).selectedColor);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Stack(
        children: [
          for (final colorPath in ColorPath.paths)
            CustomPaint(
              size: Size.infinite,
              painter: PathPainter(colorPath),
            ),
          CustomPaint(
            size: Size.infinite,
            painter: PathPainter(_colorPath),
          ),
        ],
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  final ColorPath colorPath;

  PathPainter(this.colorPath);

  Paint get paintBrush {
    return Paint()
      ..strokeCap = StrokeCap.round //先端丸くする
      ..isAntiAlias = true //アンチエイリアシング
      ..color = colorPath.color
      ..strokeWidth = 2 //線の太さ
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(colorPath.path, paintBrush);
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) {
    //動きに合わせてキャンバスを再描画しないといけない
    return true;
  }
}

class ColorSelectionWidget extends StatelessWidget {
  static const double _circleWidth = 45;

  @override
  Widget build(BuildContext context) {
    final colorPallete = ColorPallete.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var i = 0; i < colorPallete.colors.length; i++)
              ColorCircle(
                index: i,
                width: _circleWidth,
              ),
          ],
        ),
        const SizedBox(height: _circleWidth / 6),
        ColorSlider(),
      ],
    );
  }
}

class ColorCircle extends StatelessWidget {
  final int index;
  final double width;

  const ColorCircle({
    Key? key,
    required this.index,
    required this.width,
  }) : super(key: key);

  static final Matrix4 _transform = Matrix4.identity()..scale(1.4);

  @override
  Widget build(BuildContext context) {
    final colorPallete = ColorPallete.of(context);
    final selected = colorPallete.selectedIndex == index;

    return GestureDetector(
      onTap: selected ? null : () => colorPallete.select(index),
      child: TweenAnimationBuilder<double>(
        //色の変化をアニメーションにする
        tween: Tween<double>(
          begin: 0,
          end: ColorHelper.colorToHue(colorPallete.colors[index]),
        ),
        duration: const Duration(milliseconds: 600),
        builder: (context, value, child) {
          return Row(
            children: [
              Container(
                width: width,
                height: width,
                transformAlignment: Alignment.center,
                transform: selected ? _transform : null,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, //丸い形で選ぶ
                  color: ColorHelper.hueToColor(value), //色
                  //color: ColorHelper.hueToColor(index),
                  border: Border.all(
                    color: selected ? Colors.black54 : Colors.white70,
                    width: 6,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ColorSlider extends StatelessWidget {
  void _onChanged(BuildContext context, double value) {
    final colorPallete = ColorPallete.of(context);
    colorPallete.changeColor(ColorHelper.hueToColor(value));
  }

  //カラーピッカー
  @override
  Widget build(BuildContext context) {
    final colorPallete = ColorPallete.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  for (var i = 0; i <= 330; i++)
                    HSVColor.fromAHSV(1.0, i.toDouble(), 1.0, 1.0).toColor(),
                ],
                stops: [
                  for (var i = 0; i <= 330; i++) (i / 330).toDouble(),
                ],
              ),
            ),
          ),
        ),
        Slider(
          //Hue色相  ０から360  Saturation彩度　Value明度
          value: ColorHelper.colorToHue(colorPallete.selectedColor),
          onChanged: (value) => _onChanged(context, value),
          min: 0,
          max: 340,
        ),
      ],
    );
  }
}

class UndoButtonBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverflowBar(
      children: [
        IconButton(
          icon: const Icon(Icons.undo_rounded), //１つ戻るボタン
          color: Colors.black38,
          onPressed: () => _undo(context),
        ),
        IconButton(
          icon: const Icon(Icons.delete_rounded), //全部消すボタン
          color: Colors.black38,
          onPressed: () => _clear(context),
        ),
      ],
    );
  }

  void _clear(BuildContext context) {
    ColorPath.paths.clear(); //削除
    ColorPallete.of(context).rebuild();
  }

  void _undo(BuildContext context) {  //何も書いてない状態の時例外出る
    ColorPath.paths.removeLast(); //一つ戻る
    ColorPallete.of(context).rebuild();
  }
}

class ColorHelper {
  static Color hueToColor(double hueValue) =>
      HSVColor.fromAHSV(1.0, hueValue, 1.0, 1.0).toColor();

  static double colorToHue(Color color) => HSVColor.fromColor(color).hue;
}

class ColorPath {
  final Path path = Path();
  final Color color;
  ColorPath(this.color);

  static List<ColorPath> paths = [];

  void setFirstPoint(Offset point) {
    //キャンバスに触れた時点で呼び出される　パスの最初の点を作る
    path.moveTo(point.dx, point.dy);
  }

  void updatePath(Offset point) {
    //描く瞬間に呼び出される　パスを更新し続ける
    path.lineTo(point.dx, point.dy);
  }
}

class ColorPalleteNotifier extends ChangeNotifier {
  List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.yellow,
    Colors.lightGreen,
    Colors.green,
    Colors.lightBlue,
    Colors.blue,
    Colors.indigo,
    Colors.deepPurple,
    Colors.purple,
    Colors.pink,
    //Colors.black,   //赤になる
  ];

  int selectedIndex = 0;

  Color get selectedColor => colors[selectedIndex];

  void changeColor(Color newColor) {
    colors[selectedIndex] = newColor;
    notifyListeners();
  }

  void select(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void rebuild() {
    notifyListeners();
  }
}

//InheritedNotifierパレットの12色と選択色
class ColorPallete extends InheritedNotifier<ColorPalleteNotifier> {
  const ColorPallete({
    Key? key,
    required ColorPalleteNotifier notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);

  static ColorPalleteNotifier of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ColorPallete>()!
        .notifier!;
  }
}
