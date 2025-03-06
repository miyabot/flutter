import 'package:flutter/material.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_simple_3d.dart';
import 'package:simple_3d_renderer/simple_3d_renderer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<Sp3dObj> objs = [];
  late Sp3dWorld world;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    // Create the cube object.
    createCube();
    loadImage();
  }

  void createCube() {
  // 3x3のルービックキューブを作成
  for (int x = 0; x < 3; x++) {
    for (int y = 0; y < 3; y++) {
      for (int z = 0; z < 3; z++) {
        // 立方体の作成
        Sp3dObj cubelet = UtilSp3dGeometry.cube(30, 30, 30, 1, 1, 1);
        cubelet.materials[0] = FSp3dMaterial.grey.deepCopy()..strokeColor=Colors.black;

        // 各面に色を割り当て
        cubelet.fragments[0].faces[0].materialIndex = 0; // 前面（赤）
        cubelet.fragments[0].faces[1].materialIndex = 1; // 背面（緑）
        cubelet.fragments[0].faces[2].materialIndex = 2; // 右側面（青）
        cubelet.fragments[0].faces[3].materialIndex = 3; // 左側面（黄色）
        cubelet.fragments[0].faces[4].materialIndex = 4; // 上面（オレンジ）
        cubelet.fragments[0].faces[5].materialIndex = 5; // 底面（白）

        // 各キューブレットの面ごとの色
        cubelet.materials = [
          Sp3dMaterial(Color.fromARGB(255, 255, 0, 0), true, 1, Color.fromARGB(255, 255, 0, 0)), // 赤
          Sp3dMaterial(Color.fromARGB(255, 0, 255, 0), true, 1, Color.fromARGB(255, 0, 255, 0)), // 緑
          Sp3dMaterial(Color.fromARGB(255, 0, 0, 255), true, 1, Color.fromARGB(255, 0, 0, 255)), // 青
          Sp3dMaterial(Color.fromARGB(255, 255, 255, 0), true, 1, Color.fromARGB(255, 255, 255, 0)), // 黄色
          Sp3dMaterial(Color.fromARGB(255, 255, 165, 0), true, 1, Color.fromARGB(255, 255, 165, 0)), // オレンジ
          Sp3dMaterial(Color.fromARGB(255, 255, 255, 255), true, 1, Color.fromARGB(255, 255, 255, 255)), // 白
        ];

        // 各面の枠線の色を設定
        for (var material in cubelet.materials) {
          material.strokeColor = Colors.black; // 各面の枠線を黒に設定
        }

        // キューブを座標に配置
        cubelet.translate(Sp3dV3D(x * 30.0, y * 30.0, z * 30.0)); // サイズをキューブのサイズに合わせて調整(35にすると１個ずつ)
        objs.add(cubelet);
      }
    }
  }
}




  void loadImage() async {
    world = Sp3dWorld(objs);
    world.initImages().then((List<Sp3dObj> errorObjs) {
      setState(() {
        isLoaded = true;
      });
    });
  }

  void rotateFace(int face) {
    // face: 0=Front, 1=Right, 2=Back, 3=Left, 4=Up, 5=Down
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        // 90度回転
        Sp3dObj cubelet = objs[i * 3 + j];
        switch (face) {
          case 0: // Front
            cubelet.rotate(Sp3dV3D(1, 0, 0), 90 * 3.14 / 180);
            break;
          // 他の面の回転ロジックを追加
        }
      }
    }
    setState(() {});
  }

  void rotateFaceA(int face) {
  if (face == 0) {
    // Front face
    // 3x3のキューブレットを対象にする
    List<Sp3dObj> frontFace = [
      objs[0], objs[1], objs[2],
      objs[3], objs[4], objs[5],
      objs[6], objs[7], objs[8],
    ];

    // 90度回転するための新しい配置を計算
    List<Sp3dObj> temp = List.from(frontFace);

    // 時計回りに90度回転するための配置
    frontFace[0] = temp[6]; // (2,0) → (0,0)
    frontFace[1] = temp[3]; // (1,0) → (0,1)
    frontFace[2] = temp[0]; // (0,0) → (0,2)
    
    frontFace[3] = temp[7]; // (2,1) → (1,0)
    frontFace[4] = temp[4]; // (1,1) → (1,1) (中心)
    frontFace[5] = temp[1]; // (0,1) → (1,2)
    
    frontFace[6] = temp[8]; // (2,2) → (2,0)
    frontFace[7] = temp[5]; // (1,2) → (2,1)
    frontFace[8] = temp[2]; // (0,2) → (2,2)

    // 回転の中心を計算（この場合はfrontFaceの中心）
    Sp3dV3D center = Sp3dV3D(35 * 1.5, 35 * 1.5, 35 * 1.5);
 // キューブの前面の中央

    // 各キューブレットを回転
    for (int i = 0; i < frontFace.length; i++) {
      Sp3dObj cubelet = frontFace[i];
      // 真ん中を軸にして回転
      cubelet.translate(Sp3dV3D(-center.x, -center.y, -center.z)); // 中心に合わせて移動
      cubelet.rotate(Sp3dV3D(1, 0, 0), 90 * 3.14 / 180); // Z軸周りに90度回転
      cubelet.translate(Sp3dV3D(center.x, center.y, center.z)); // 元の位置に戻す
    }
  }
  setState(() {});
}


  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return MaterialApp(
          title: 'Rubik\'s Cube',
          home: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 0, 255, 0),
              ),
              backgroundColor: const Color.fromARGB(255, 33, 33, 33),
              body: Center(child: CircularProgressIndicator())));
    } else {
      return MaterialApp(
        title: 'Rubik\'s Cube',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('3D Rubik\'s Cube'),
            backgroundColor: const Color.fromARGB(255, 0, 255, 0),
            actions: [
              IconButton(
                icon: const Icon(Icons.rotate_right),
                onPressed: () => rotateFace(0), // Front faceを回転
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 33, 33, 33),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    rotateFaceA(0);
                  },
                  child: Text('回転'),
                ),
                SizedBox(height: 20), // ボタンとキューブの間にスペースを追加
                Center(
                  child: Sp3dRenderer(
                    const Size(300, 300), // サイズを調整
                    const Sp3dV2D(30, 300), // 描画の中心をサイズの半分に合わせる
                    world,
                    Sp3dCamera(Sp3dV3D(0, 0, 250), 500), // カメラの位置を調整
                    Sp3dLight(Sp3dV3D(0, 0, -1), syncCam: true),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
