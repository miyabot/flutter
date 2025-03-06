import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_simple_3d.dart';
import 'package:simple_3d_renderer/simple_3d_renderer.dart';
import 'solver.dart';

class CubeState_3d{

  List<int> cp; // コーナーの配置
  List<int> co; // コーナーの向き
  List<int> ep; // エッジの配置
  List<int> eo; // エッジの向き

  CubeState_3d(this.cp, this.co, this.ep, this.eo);

   // Moveを適用し、新しい状態を返す
  CubeState_3d applyMove(CubeState_3d move) {
                        // generate(要素数,(要素i番目) => 引数のi番目を入れる)
    List<int> newCp = List.generate(8, (i) => cp[move.cp[i]]);
    List<int> newCo = List.generate(8, (i) => (co[move.cp[i]] + move.co[i]) % 3);
    List<int> newEp = List.generate(12, (i) => ep[move.ep[i]]);
    List<int> newEo = List.generate(12, (i) => (eo[move.ep[i]] + move.eo[i]) % 2);
    return CubeState_3d(newCp, newCo, newEp, newEo);
  }

}

//完成状態を指す変数
CubeState_3d solvedState_3d = CubeState_3d(

  [0, 1, 2, 3, 4, 5, 6, 7], // cp
  [0, 0, 0, 0, 0, 0, 0, 0], // co
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], // ep
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // eo

);

// 操作定義
Map<String, CubeState_3d> moves_3d = {
  'U': CubeState_3d(
      [3, 0, 1, 2, 4, 5, 6, 7], 
      [0, 0, 0, 0, 0, 0, 0, 0], 
      [0, 1, 2, 3, 7, 4, 5, 6, 8, 9, 10, 11], 
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
  'D': CubeState_3d(
      [0, 1, 2, 3, 5, 6, 7, 4], 
      [0, 0, 0, 0, 0, 0, 0, 0], 
      [0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 8], 
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
  'L': CubeState_3d(
      [4, 1, 2, 0, 7, 5, 6, 3], 
      [2, 0, 0, 1, 1, 0, 0, 2], 
      [11, 1, 2, 7, 4, 5, 6, 0, 8, 9, 10, 3], 
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
  'R': CubeState_3d(
      [0, 2, 6, 3, 4, 1, 5, 7], 
      [0, 1, 2, 0, 0, 2, 1, 0], 
      [0, 5, 9, 3, 4, 2, 6, 7, 8, 1, 10, 11], 
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
  'F': CubeState_3d(
      [0, 1, 3, 7, 4, 5, 2, 6], 
      [0, 0, 1, 2, 0, 0, 2, 1], 
      [0, 1, 6, 10, 4, 5, 3, 7, 8, 9, 2, 11], 
      [0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0]),
  'B': CubeState_3d(
      [1, 5, 2, 3, 0, 4, 6, 7], 
      [1, 2, 0, 0, 2, 1, 0, 0], 
      [4, 8, 2, 3, 1, 5, 6, 7, 0, 9, 10, 11], 
      [1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0]),
};

// moveの18種類を生成する
List<String> moveNames_3d = [];
List<String> faces = moves_3d.keys.toList();

// 18種類の操作を定義する関数
void initializeMoves_3d() {

  //U, U2, U', D, D2, D', L, L2, L', R, R2, R', F, F2, F', B, B2, B' を作成
  for (var faceName in faces) {
    moveNames_3d.addAll([faceName, faceName + '2', faceName + '\'']);
    moves_3d[faceName + '2'] = moves_3d[faceName]!.applyMove(moves_3d[faceName]!);
    moves_3d[faceName + '\''] = moves_3d[faceName]!.applyMove(moves_3d[faceName]!).applyMove(moves_3d[faceName]!);
  }
   
}


//CubeState_3d? scrambled_state;
CubeState_3d scrambled_newstate = solvedState_3d;
CubeState_3d GetScrambled_newstate(){return scrambled_newstate;}

CubeState_3d scamble2state(scramble){

  CubeState_3d scramble_state = scrambled_newstate;

  for(var moveNames in scramble.split(" ")){
    scramble_state = scramble_state.applyMove(moves_3d[moveNames]!);
  }

  return scramble_state;
}

class Rubiks_cube_3d extends StatefulWidget {
  const Rubiks_cube_3d({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Rubiks_cube_3dState();
}

//黄色が無いので作成
Sp3dMaterial yellow = Sp3dMaterial(
      const Color.fromARGB(255, 255, 255, 0),
      true,
      1,
      const Color.fromARGB(255, 255, 255, 0));

class _Rubiks_cube_3dState extends State<Rubiks_cube_3d> {
  late List<Sp3dObj> objs = [];
  late Sp3dWorld world;
  bool isLoaded = false;
  List<Sp3dObj> errorObjs = [];
  bool isRotating = false; // 回転中かどうかのフラグ
  bool isAnimation = false;// アニメーションするかどうかのフラグ

  double cubeSize = 50; // Size of each small cube in the Rubik's cube
  double gap = 5; // Gap between small cubes

  @override
  void initState(){
    super.initState();
    createRubiksCube();
    loadImage();
    scrambled_newstate = solvedState_3d; // 再読み込みされたときにキューブが揃っている状態にする
    //return_scramble(); //揃った状態から元のスクランブルされた状態にする
  }

  void solver_rubiks_Animation() async {
    CubeState scrambled_state_3d = CubeState(scrambled_newstate.cp, scrambled_newstate.co, scrambled_newstate.ep, scrambled_newstate.eo);

    Search search = Search(scrambled_state_3d);

    await search.startSearch();

    String? UpMove_return;
    String? LeftMove_return;
    String? FrontMove_return;
    String? RightMove_return;
    String? BackMove_return;
    String? DownMove_return;

    String? Reverse_UpMove_return;
    String? Reverse_LeftMove_return;
    String? Reverse_FrontMove_return;
    String? Reverse_RightMove_return;
    String? Reverse_BackMove_return;
    String? Reverse_DownMove_return;

     //スクランブルされたルービックキューブを揃える
    for(int i = 0; i < solution_return!.length - 1; i++){

      if(solution_return![i] == 'U'){
        if(solution_return![i + 1] == '2'){
          UpMove_return = await UpMoveAnimation();
          UpMove_return = await UpMoveAnimation();
        }
        else if(solution_return![i + 1] == '\''){
          UpMove_return = await ReverseUpMoveAnimation();
        }
        else if(solution_return![i + 1] == ' '){
          UpMove_return = await UpMoveAnimation();
        }
      }
      if(solution_return![i] == 'L'){
       if(solution_return![i + 1] == '2'){
          LeftMove_return = await LeftMoveAnimation();
          LeftMove_return = await LeftMoveAnimation();
        }
        else if(solution_return![i + 1] == '\''){
          LeftMove_return = await ReverseLeftMoveAnimation();
        }
        else if(solution_return![i + 1] == ' '){
          LeftMove_return = await LeftMoveAnimation();
        }
      }
      if(solution_return![i] == 'F'){
        if(solution_return![i + 1] == '2'){
          FrontMove_return = await FrontMoveAnimation();
          FrontMove_return = await FrontMoveAnimation();
        }
        else if(solution_return![i + 1] == '\''){
          FrontMove_return = await ReverseFrontMoveAnimation();
        }
        else if(solution_return![i + 1] == ' '){
          FrontMove_return = await FrontMoveAnimation();
        }
      }
      if(solution_return![i] == 'R'){
        if(solution_return![i + 1] == '2'){
         RightMove_return = await RightMoveAnimation();
         RightMove_return = await RightMoveAnimation();
        }
        else if(solution_return![i + 1] == '\''){
          RightMove_return = await ReverseRightMoveAnimation();
        }
        else if(solution_return![i + 1] == ' '){
          RightMove_return = await RightMoveAnimation();
        }
      }
      if(solution_return![i] == 'B'){
        if(solution_return![i + 1] == '2'){
          BackMove_return = await BackMoveAnimation();
        }
        else if(solution_return![i + 1] == '\''){
          BackMove_return = await ReverseBackMoveAnimation();
        }
        else if(solution_return![i + 1] == ' '){
          BackMove_return = await BackMoveAnimation();
        }
      }
      if(solution_return![i] == 'D'){
        if(solution_return![i + 1] == '2'){
        DownMove_return = await DownMoveAnimation();
        DownMove_return = await DownMoveAnimation();
        }
        else if(solution_return![i + 1] == '\''){
          DownMove_return = await ReverseDownMoveAnimation();
        }
        else if(solution_return![i + 1] == ' '){
          DownMove_return = await DownMoveAnimation();
        }
      }

      if(solution_return![i] == '2'){
        continue;
      }
      if(solution_return![i] == '\''){
        continue;
      }
      if(solution_return![i] == ' '){
        continue;
      }
    }

    print(UpMove_return!);
    print(LeftMove_return!);
    print(FrontMove_return!);
    print(RightMove_return!);
    print(BackMove_return!);
    print(DownMove_return!);

    print(Reverse_UpMove_return!);
    print(Reverse_LeftMove_return!);
    print(Reverse_FrontMove_return!);
    print(Reverse_RightMove_return!);
    print(Reverse_BackMove_return!);
    print(Reverse_DownMove_return!);
  }

  void solver_rubiks() async {
    CubeState scrambled_state_3d = CubeState(scrambled_newstate.cp, scrambled_newstate.co, scrambled_newstate.ep, scrambled_newstate.eo);

    Search search = Search(scrambled_state_3d);

    await search.startSearch();

    print(solution_return!.length);
    for(int i = 0; i < solution_return!.length; i++)
    {
      print("print[${i}]:[${solution_return![i]}]");
    }
    //スクランブルされたルービックキューブを揃える
    for(int i = 0; i < solution_return!.length - 1; i++){

      if(solution_return![i] == 'U'){
        if(solution_return![i + 1] == '2'){
          UpMove();UpMove();
        }
        else if(solution_return![i + 1] == '\''){
          ReverseUpMove();
        }
        else if(solution_return![i + 1] == ' '){
          UpMove();
        }
      }
      if(solution_return![i] == 'L'){
       if(solution_return![i + 1] == '2'){
          LeftMove();LeftMove();
        }
        else if(solution_return![i + 1] == '\''){
          ReverseLeftMove();
        }
        else if(solution_return![i + 1] == ' '){
          LeftMove();
        }
      }
      if(solution_return![i] == 'F'){
        if(solution_return![i + 1] == '2'){
          FrontMove();FrontMove();
        }
        else if(solution_return![i + 1] == '\''){
          ReverseFrontMove();
        }
        else if(solution_return![i + 1] == ' '){
          FrontMove();
        }
      }
      if(solution_return![i] == 'R'){
        if(solution_return![i + 1] == '2'){
         RightMove();RightMove();
        }
        else if(solution_return![i + 1] == '\''){
          ReverseRightMove();
        }
        else if(solution_return![i + 1] == ' '){
          RightMove();
        }
      }
      if(solution_return![i] == 'B'){
        if(solution_return![i + 1] == '2'){
         BackMove();BackMove();
        }
        else if(solution_return![i + 1] == '\''){
          ReverseBackMove();
        }
        else if(solution_return![i + 1] == ' '){
          BackMove();
        }
      }
      if(solution_return![i] == 'D'){
        if(solution_return![i + 1] == '2'){
        DownMove();DownMove();
        }
        else if(solution_return![i + 1] == '\''){
          ReverseDownMove();
        }
        else if(solution_return![i + 1] == ' '){
          DownMove();
        }
      }

      if(solution_return![i] == '2'){
        continue;
      }
      if(solution_return![i] == '\''){
        continue;
      }
      if(solution_return![i] == ' '){
        continue;
      }
    }
  }

  //揃った状態のルービックキューブを前のスクランブルされた状態に戻す
  void return_scramble(){
    bool isDouble = false; //直前が2だったかどうか
    bool isReverse = false; //直前が反対記号だったかどうか

    // 逆算して状態を戻す
    for(int i = solution_return!.length - 1; i >= 0 ; i--){
              
      if(solution_return![i] == ' '){isDouble = false; isReverse = false;}

      if(isDouble == false && isReverse == false){
        if(solution_return![i] == 'U'){ReverseUpMove();}
        if(solution_return![i] == 'L'){ReverseLeftMove();}
        if(solution_return![i] == 'F'){ReverseFrontMove();}
        if(solution_return![i] == 'R'){ReverseRightMove();}
        if(solution_return![i] == 'B'){ReverseBackMove();}
        if(solution_return![i] == 'D'){ReverseDownMove();}
      }
      else{
            isDouble = false;
             isReverse = false;
      }
              
      if(solution_return![i] == '\''){
        if(solution_return![i - 1] == 'U'){UpMove(); isDouble = true;}
          if(solution_return![i - 1] == 'L'){LeftMove(); isDouble = true;}
          if(solution_return![i - 1] == 'F'){FrontMove(); isDouble = true;}
          if(solution_return![i - 1] == 'R'){RightMove(); isDouble = true;}
          if(solution_return![i - 1] == 'B'){BackMove(); isDouble = true;}
          if(solution_return![i - 1] == 'D'){DownMove(); isDouble = true;}
      }

      if(solution_return![i] == '2'){
        if(solution_return![i - 1] == 'U'){UpMove(); UpMove(); isReverse = true;}
        if(solution_return![i - 1] == 'L'){LeftMove(); LeftMove(); isReverse = true;}
        if(solution_return![i - 1] == 'F'){FrontMove(); FrontMove(); isReverse = true;}
        if(solution_return![i - 1] == 'R'){RightMove(); RightMove(); isReverse = true;}
        if(solution_return![i - 1] == 'B'){BackMove(); BackMove(); isReverse = true;}
        if(solution_return![i - 1] == 'D'){DownMove(); DownMove(); isReverse = true;}
      }
    }
  }

  void createRubiksCube(){
    // 色のリスト
    List<Sp3dMaterial> faceColors = [
      FSp3dMaterial.white.deepCopy(),    // U
      FSp3dMaterial.orange.deepCopy(),   // L
      FSp3dMaterial.green.deepCopy(),  // F
      FSp3dMaterial.red.deepCopy(),   // R
      FSp3dMaterial.blue.deepCopy(),  // B
      yellow.deepCopy(),               // D
      FSp3dMaterial.black.deepCopy(),
    ];

    // ルービック キューブ用の 3x3x3 の立方体を作成する
    for (int x = 0; x < 3; x++) {
      for (int y = 0; y < 3; y++) {
        for (int z = 0; z < 3; z++) {
          Sp3dObj obj = UtilSp3dGeometry.cube(
            cubeSize, cubeSize, cubeSize, 
            1, 1, 1
          );

          // 立方体の各面にの色を設定
          obj.materials.addAll(faceColors.map((m) => m.deepCopy()).toList());

          // 全てのキューブに黒色の下地を付ける
          for(int i = 0; i < 6; i++){
            obj.fragments[0].faces[i].materialIndex = 7;
          }

          CpCubeCreate(obj,x,y,z); // cpパーツに色を付ける
          EpCubeCreate(obj,x,y,z); // epパーツに色を付ける
          CenterPartsCreate(obj,x,y,z); // センターパーツに色を付ける

          // それぞれの立方体をルービックキューブの位置に移動
          // -1,0,1 x
          // -1,0,1 y
          // -1,0,1 z
          // -1 の時はマイナス方向にキューブの大きさ分移動して生成
          //  0  の時はそのまま生成
          //  1  の時はプラス方向にキューブの大きさ分移動して生成
          obj.move(Sp3dV3D(
            (x - 1) * (cubeSize + gap),
            (y - 1) * (cubeSize + gap),
            (z - 1) * (cubeSize + gap) - (cubeSize / 2),//z軸の0を起点に直方体が生成されているのでボックスサイズの半分をマイナスする
          ));

          //obj.rotate(Sp3dV3D(1,0,0).nor(), 25 * 3.14 / 180);
          //obj.rotate(Sp3dV3D(0,1,0).nor(), 320 * 3.14 / 180);

          objs.add(obj); //リストに格納
        }
      }
    }
  }

  List<Sp3dObj> CubeCpList(){
    List<Sp3dObj> cpList = [
      objs[6],  //cp0
      objs[24], //cp1
      objs[26], //cp2
      objs[8],  //cp3
      objs[0],  //cp4
      objs[18], //cp5
      objs[20], //cp6
      objs[2],  //cp7
    ];

    return cpList;
  }

  List<Sp3dObj> CubeEpList(){
    List<Sp3dObj> epList = [
      objs[3],  //ep0  
      objs[21], //ep1
      objs[23], //ep2
      objs[5],  //ep3
      objs[15], //ep4
      objs[25], //ep5
      objs[17], //ep6
      objs[7],  //ep7
      objs[9],  //ep8
      objs[19], //ep9
      objs[11], //ep10
      objs[1],  //ep11
    ];

    return epList;
  }

  //全てのキューブの座標を表示
  void CubeListPrint(){
    print("===START===");
    for(int i = 0; i < 27; i++){
       print("${i}:${objs[i].getCenter()}");
    }
    print("===END===");
  }

  void loadImage() async {
    world = Sp3dWorld(objs);
    world.initImages().then((List<Sp3dObj> errors) {
      setState(() {
        errorObjs = errors; // Track objects with image loading errors.
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rubik\'s Cube',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 255, 0),
          title: const Text('3D Rubik\'s Cube Renderer'),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        body: isLoaded
            ? buildRenderer(context)
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget buildRenderer(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final renderSize = Size(screenSize.width * 0.9, screenSize.width * 0.9);

    return Column(
      children: [
        if (errorObjs.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error loading textures for ${errorObjs.length} objects',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        Sp3dRenderer(
          renderSize,
          Sp3dV2D(renderSize.width / 2, renderSize.height / 2),
          world,
          Sp3dCamera(Sp3dV3D(0, 0, 5500), 6000,).rotate(Sp3dV3D(-1, 1, 0), -30 * 3.14 / 180),
          //Sp3dCamera(Sp3dV3D(50, 50, 3000), 6000),
          Sp3dLight(Sp3dV3D(0, 0, -1), syncCam: true),
        ),
        const SizedBox(height: 20),
        // Placeholder for adding interactive features (e.g., rotation controls).

        // ElevatedButton(//LeftMove用のボタン
        //       onPressed: (){
        //         CubeListPrint();
        //       }, 
        //       child: Text('座標表示'),
        //     ),

        ElevatedButton(//LeftMove用のボタン
              onPressed: (){
                if(!isAnimation){
                  isAnimation = true;
                  print("on:${isAnimation}");
                }else{
                  isAnimation = false;
                  print("off:${isAnimation}");
                }
              }, 
              child: Text('アニメーション切替'),
            ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             ElevatedButton(
              onPressed: (){
                if(!isAnimation){
                  if(!isRotating){
                    FrontMove();
                  }
                  
                }else{
                  if(!isRotating){
                    FrontMoveAnimation();
                  }
                }
              }, 
              child: Text('F')
            ),

            ElevatedButton(
              onPressed: (){
                if(!isAnimation){
                  if(!isRotating){
                    RightMove();
                  }
                  
                }else{
                  if(!isRotating){
                    RightMoveAnimation();
                  }
                }
              }, 
              child: Text('R')
            ),

            ElevatedButton(
              onPressed: (){
                if(!isAnimation){
                  if(!isRotating){
                    UpMove();
                  }
                  
                }else{
                  if(!isRotating){
                    UpMoveAnimation();
                  }
                }
              }, 
              child: Text('U')
            ),

            ElevatedButton(
              onPressed: (){
                if(!isAnimation){
                  if(!isRotating){
                    BackMove();
                  }
                }else{
                  if(!isRotating){
                    BackMoveAnimation();
                  }
                }
              }, 
              child: Text('B')
            ),

            ElevatedButton(
              onPressed: (){
                if(!isAnimation){
                  if(!isRotating){
                    LeftMove();
                  }
                }else{
                  if(!isRotating){
                    LeftMoveAnimation();
                  }
                }
              }, 
              child: Text('L')
            ),

            ElevatedButton(
              onPressed: (){
                if(!isAnimation){
                  if(!isRotating){
                    DownMove();
                  }
                }else{
                  if(!isRotating){
                    DownMoveAnimation();
                  }
                }
              }, 
              child: Text('D')
            ),
          ],
        ),

        Row(
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
             ElevatedButton(
              onPressed: (){
                if(!isAnimation){
                  if(!isRotating){
                    ReverseFrontMove();
                  }
                  
                }else{
                  if(!isRotating){
                    ReverseFrontMoveAnimation();
                  }
                }
              }, 
              child: Text('F\'')
            ),

            ElevatedButton(
              onPressed: (){
                if(!isAnimation){
                  if(!isRotating){
                    ReverseRightMove();
                  }
                  
                }else{
                  if(!isRotating){
                    ReverseRightMoveAnimation();
                  }
                }
              }, 
              child: Text('R\'')
            ),

            ElevatedButton(
              onPressed: (){
                if(!isAnimation){
                  if(!isRotating){
                    ReverseUpMove();
                  }
                }else{
                  if(!isRotating){
                    ReverseUpMoveAnimation();
                  }
                }

              }, 
              child: Text('U\'')
            ),

            ElevatedButton(
              onPressed: (){
                if(!isAnimation){
                  if(!isRotating){
                    ReverseBackMove();
                  }
                }else{
                  if(!isRotating){
                    ReverseBackMoveAnimation();
                  }
                }
              }, 
              child: Text('B\'')
            ),

            ElevatedButton(
              onPressed: (){
                if(!isAnimation){
                  if(!isRotating){
                    ReverseLeftMove();
                  }
                }else{
                  if(!isRotating){
                    ReverseLeftMoveAnimation();
                  }
                }
              }, 
              child: Text('L\'')
            ),

            ElevatedButton(
              onPressed: (){
                if(!isAnimation){
                  if(!isRotating){
                    ReverseDownMove();
                  }
                }else{
                  if(!isRotating){
                    ReverseDownMoveAnimation();
                  }
                }
              }, 
              child: Text('D\'')
            ),
          ],
        ),
        
        ElevatedButton(
          onPressed: (){
            if(!isAnimation){
              if(!isRotating){
                solver_rubiks();
              }
            }
            else{
              if(!isRotating){
                solver_rubiks_Animation();
              }
            }
            print(solution_return);
          }, 
          child: Text('復元')),
      ],
    );
  }

  void UpMove(){
    String scramble = "U";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    for(int i = 0; i < 8; i++){ //要素
      if(scrambled_state.cp[0] == i){ //位置が0の時
        CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[1] == i){ //位置が3の時
        CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[2] == i){ //位置が4の時
        CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[3] == i){ //位置が7の時
        CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), -90 * 3.14159265359 / 180);
      }
    }

    //エッジパーツ移動
    for(int i = 0; i < 12; i++){ //要素
      if(scrambled_state.ep[4] == i){ //位置が0の時
        CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[5] == i){ //位置が3の時
        CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[6] == i){ //位置が7の時
        CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[7] == i){ //位置が11の時
        CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), -90 * 3.14159265359 / 180);
      }
    }

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);
  }
  void ReverseUpMove(){
    String scramble = "U\'";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    for(int i = 0; i < 8; i++){ //要素
      if(scrambled_state.cp[0] == i){ //位置が0の時
        CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[1] == i){ //位置が3の時
        CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[2] == i){ //位置が4の時
        CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[3] == i){ //位置が7の時
        CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), 90 * 3.14159265359 / 180);
      }
    }

    //エッジパーツ移動
    for(int i = 0; i < 12; i++){ //要素
      if(scrambled_state.ep[4] == i){ //位置が0の時
        CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[5] == i){ //位置が3の時
        CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[6] == i){ //位置が7の時
        CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[7] == i){ //位置が11の時
        CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), 90 * 3.14159265359 / 180);
      }
    }

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);
  }

  void LeftMove(){

    String scramble = "L";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    //コーナーパーツ移動
    for(int i = 0; i < 8; i++){ //要素
      if(scrambled_state.cp[0] == i){ //位置が0の時
        CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[3] == i){ //位置が3の時
        CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[4] == i){ //位置が4の時
        CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[7] == i){ //位置が7の時
        CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), 90 * 3.14159265359 / 180);
      }
    }

    //エッジパーツ移動
    for(int i = 0; i < 12; i++){ //要素
      if(scrambled_state.ep[0] == i){ //位置が0の時
        CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[3] == i){ //位置が3の時
        CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[7] == i){ //位置が7の時
        CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[11] == i){ //位置が11の時
        CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), 90 * 3.14159265359 / 180);
      }
    }

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);

  }
  void ReverseLeftMove(){

    String scramble = "L\'";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    //コーナーパーツ移動
    for(int i = 0; i < 8; i++){ //要素
      if(scrambled_state.cp[0] == i){ //位置が0の時
        CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[3] == i){ //位置が3の時
        CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[4] == i){ //位置が4の時
        CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[7] == i){ //位置が7の時
        CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), -90 * 3.14159265359 / 180);
      }
    }

    //エッジパーツ移動
    for(int i = 0; i < 12; i++){ //要素
      if(scrambled_state.ep[0] == i){ //位置が0の時
        CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[3] == i){ //位置が3の時
        CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[7] == i){ //位置が7の時
        CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[11] == i){ //位置が11の時
        CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), -90 * 3.14159265359 / 180);
      }
    }

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);

  }

  void RightMove(){
    String scramble = "R";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    //コーナーパーツ移動
    for(int i = 0; i < 8; i++){ //要素
      if(scrambled_state.cp[1] == i){ //位置が0の時
        CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[2] == i){ //位置が3の時
        CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[5] == i){ //位置が4の時
        CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[6] == i){ //位置が7の時
        CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), -90 * 3.14159265359 / 180);
      }
    }

    //エッジパーツ移動
    for(int i = 0; i < 12; i++){ //要素
      if(scrambled_state.ep[1] == i){ //位置が0の時
        CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[2] == i){ //位置が3の時
        CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[5] == i){ //位置が7の時
        CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[9] == i){ //位置が11の時
        CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), -90 * 3.14159265359 / 180);
      }
    }

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);
  }
  void ReverseRightMove(){
    String scramble = "R\'";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    //コーナーパーツ移動
    for(int i = 0; i < 8; i++){ //要素
      if(scrambled_state.cp[1] == i){ //位置が0の時
        CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[2] == i){ //位置が3の時
        CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[5] == i){ //位置が4の時
        CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[6] == i){ //位置が7の時
        CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), 90 * 3.14159265359 / 180);
      }
    }

    //エッジパーツ移動
    for(int i = 0; i < 12; i++){ //要素
      if(scrambled_state.ep[1] == i){ //位置が0の時
        CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[2] == i){ //位置が3の時
        CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[5] == i){ //位置が7の時
        CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[9] == i){ //位置が11の時
        CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), 90 * 3.14159265359 / 180);
      }
    }

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);
  }

  void FrontMove(){
    String scramble = "F";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    //コーナーパーツ移動
    for(int i = 0; i < 8; i++){ //要素
      if(scrambled_state.cp[3] == i){ //位置が0の時
        CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[2] == i){ //位置が3の時
        CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[6] == i){ //位置が4の時
        CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[7] == i){ //位置が7の時
        CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), -90 * 3.14159265359 / 180);
      }
    }

    //エッジパーツ移動
    for(int i = 0; i < 12; i++){ //要素
      if(scrambled_state.ep[2] == i){ //位置が0の時
        CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[3] == i){ //位置が3の時
        CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[6] == i){ //位置が7の時
        CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[10] == i){ //位置が11の時
        CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), -90 * 3.14159265359 / 180);
      }
    }

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);
  }
  void ReverseFrontMove(){
    String scramble = "F\'";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    //コーナーパーツ移動
    for(int i = 0; i < 8; i++){ //要素
      if(scrambled_state.cp[3] == i){ //位置が0の時
        CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[2] == i){ //位置が3の時
        CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[6] == i){ //位置が4の時
        CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[7] == i){ //位置が7の時
        CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), 90 * 3.14159265359 / 180);
      }
    }

    //エッジパーツ移動
    for(int i = 0; i < 12; i++){ //要素
      if(scrambled_state.ep[2] == i){ //位置が0の時
        CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[3] == i){ //位置が3の時
        CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[6] == i){ //位置が7の時
        CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[10] == i){ //位置が11の時
        CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), 90 * 3.14159265359 / 180);
      }
    }

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);
  }

  void BackMove(){
    String scramble = "B";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    //コーナーパーツ移動
    for(int i = 0; i < 8; i++){ //要素
      if(scrambled_state.cp[0] == i){ //位置が0の時
        CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[1] == i){ //位置が3の時
        CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[4] == i){ //位置が4の時
        CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[5] == i){ //位置が7の時
        CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), 90 * 3.14159265359 / 180);
      }
    }

    //エッジパーツ移動
    for(int i = 0; i < 12; i++){ //要素
      if(scrambled_state.ep[0] == i){ //位置が0の時
        CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[1] == i){ //位置が3の時
        CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[4] == i){ //位置が7の時
        CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[8] == i){ //位置が11の時
        CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), 90 * 3.14159265359 / 180);
      }
    }

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);
  }
  void ReverseBackMove(){
    String scramble = "B\'";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    //コーナーパーツ移動
    for(int i = 0; i < 8; i++){ //要素
      if(scrambled_state.cp[0] == i){ //位置が0の時
        CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[1] == i){ //位置が3の時
        CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[4] == i){ //位置が4の時
        CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[5] == i){ //位置が7の時
        CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), -90 * 3.14159265359 / 180);
      }
    }

    //エッジパーツ移動
    for(int i = 0; i < 12; i++){ //要素
      if(scrambled_state.ep[0] == i){ //位置が0の時
        CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[1] == i){ //位置が3の時
        CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[4] == i){ //位置が7の時
        CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[8] == i){ //位置が11の時
        CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), -90 * 3.14159265359 / 180);
      }
    }

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);
  }

  void DownMove(){
    String scramble = "D";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    //コーナーパーツ移動
    for(int i = 0; i < 8; i++){ //要素
      if(scrambled_state.cp[4] == i){ //位置が0の時
        CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[5] == i){ //位置が3の時
        CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[6] == i){ //位置が4の時
        CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[7] == i){ //位置が7の時
        CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), 90 * 3.14159265359 / 180);
      }
    }

    //エッジパーツ移動
    for(int i = 0; i < 12; i++){ //要素
      if(scrambled_state.ep[8] == i){ //位置が0の時
        CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[9] == i){ //位置が3の時
        CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[10] == i){ //位置が7の時
        CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), 90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[11] == i){ //位置が11の時
        CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), 90 * 3.14159265359 / 180);
      }
    }

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);
  }
  void ReverseDownMove(){
    String scramble = "D\'";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    //コーナーパーツ移動
    for(int i = 0; i < 8; i++){ //要素
      if(scrambled_state.cp[4] == i){ //位置が0の時
        CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[5] == i){ //位置が3の時
        CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[6] == i){ //位置が4の時
        CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.cp[7] == i){ //位置が7の時
        CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), -90 * 3.14159265359 / 180);
      }
    }

    //エッジパーツ移動
    for(int i = 0; i < 12; i++){ //要素
      if(scrambled_state.ep[8] == i){ //位置が0の時
        CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[9] == i){ //位置が3の時
        CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[10] == i){ //位置が7の時
        CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), -90 * 3.14159265359 / 180);
      }
      if(scrambled_state.ep[11] == i){ //位置が11の時
        CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), -90 * 3.14159265359 / 180);
      }
    }

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);
  }

  Future<String?> UpMoveAnimation(){
    String scramble = "U";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    isRotating = true;
    int angle = 0;
    //回転の調整用
    int anglenum = 45;
    int radian = -2;

    String? finish_return;
    
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (angle >= anglenum) {
        timer.cancel();
        isRotating = false;
      } else {
        setState(() {
          for(int i = 0; i < 8; i++){ //要素
            if(scrambled_state.cp[0] == i){ //位置が0の時
              CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[1] == i){ //位置が3の時
              CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[2] == i){ //位置が4の時
              CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[3] == i){ //位置が7の時
              CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
          }

          //エッジパーツ移動
          for(int i = 0; i < 12; i++){ //要素
            if(scrambled_state.ep[4] == i){ //位置が0の時
              CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[5] == i){ //位置が3の時
              CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[6] == i){ //位置が7の時
              CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[7] == i){ //位置が11の時
              CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
          }

          objs[16].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
          finish_return = "Upアニメーション終了";
        });
        angle += 1;
      }
    });

    

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);

    return Future<String?>.value(finish_return!);
  }
  Future<String?> ReverseUpMoveAnimation(){
    String scramble = "U\'";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    isRotating = true;
    int angle = 0;
    int anglenum = 45;
    int radian = 2;

    String? finish_return;

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (angle >= anglenum) {
        timer.cancel();
        isRotating = false;
      } else {
        setState(() {
           for(int i = 0; i < 8; i++){ //要素
              if(scrambled_state.cp[0] == i){ //位置が0の時
                CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
              }
              if(scrambled_state.cp[1] == i){ //位置が3の時
                CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
              }
              if(scrambled_state.cp[2] == i){ //位置が4の時
                CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
              }
              if(scrambled_state.cp[3] == i){ //位置が7の時
                CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
              }
            }

            //エッジパーツ移動
            for(int i = 0; i < 12; i++){ //要素
              if(scrambled_state.ep[4] == i){ //位置が0の時
                CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
              }
              if(scrambled_state.ep[5] == i){ //位置が3の時
                CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
              }
              if(scrambled_state.ep[6] == i){ //位置が7の時
                CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
              }
              if(scrambled_state.ep[7] == i){ //位置が11の時
                CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
              }
            }

            objs[16].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            finish_return = "ReverseUpアニメーション終了";
        });
        angle += 1;
      }
    });

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);

    return Future<String?>.value(finish_return!);
  }

  Future<String?> LeftMoveAnimation(){

    String scramble = "L";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    isRotating = true;
    int angle = 0;
    int anglenum = 45;
    int radian = 2;

    String? finish_return;

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (angle >= anglenum) {
        timer.cancel();
        isRotating = false;
      } else {
        setState(() {
          //コーナーパーツ移動
          for(int i = 0; i < 8; i++){ //要素
            if(scrambled_state.cp[0] == i){ //位置が0の時
              CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[3] == i){ //位置が3の時
              CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[4] == i){ //位置が4の時
              CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[7] == i){ //位置が7の時
              CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
          }

          //エッジパーツ移動
          for(int i = 0; i < 12; i++){ //要素
            if(scrambled_state.ep[0] == i){ //位置が0の時
              CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[3] == i){ //位置が3の時
              CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[7] == i){ //位置が7の時
              CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[11] == i){ //位置が11の時
              CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
          }
          objs[4].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);

          finish_return = "Leftアニメーション終了";

        });
        angle += 1;
      }
    });

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);

    return Future<String?>.value(finish_return!);

  }
  Future<String?> ReverseLeftMoveAnimation(){

    String scramble = "L\'";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    isRotating = true;
    int angle = 0;
    int anglenum = 45;
    int radian = -2;

    String? finish_return;

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (angle >= anglenum) {
        timer.cancel();
        isRotating = false;
      } else {
        setState(() {
          //コーナーパーツ移動
          for(int i = 0; i < 8; i++){ //要素
            if(scrambled_state.cp[0] == i){ //位置が0の時
              CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[3] == i){ //位置が3の時
              CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[4] == i){ //位置が4の時
              CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[7] == i){ //位置が7の時
              CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
          }

          //エッジパーツ移動
          for(int i = 0; i < 12; i++){ //要素
            if(scrambled_state.ep[0] == i){ //位置が0の時
              CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[3] == i){ //位置が3の時
              CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[7] == i){ //位置が7の時
              CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[11] == i){ //位置が11の時
              CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
          }
          objs[4].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
          finish_return = "ReverseLeftアニメーション終了";
        });
        angle += 1;
      }
    });

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);

    return Future<String?>.value(finish_return!);
  }

  Future<String?> RightMoveAnimation(){
    String scramble = "R";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    isRotating = true;
    int angle = 0;
    int anglenum = 45;
    int radian = -2;

    String? finish_return;

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (angle >= anglenum) {
        timer.cancel();
        isRotating = false;
      } else {
        setState(() {
          //コーナーパーツ移動
          for(int i = 0; i < 8; i++){ //要素
            if(scrambled_state.cp[1] == i){ //位置が0の時
              CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[2] == i){ //位置が3の時
              CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[5] == i){ //位置が4の時
              CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[6] == i){ //位置が7の時
              CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
          }

          //エッジパーツ移動
          for(int i = 0; i < 12; i++){ //要素
            if(scrambled_state.ep[1] == i){ //位置が0の時
              CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[2] == i){ //位置が3の時
              CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[5] == i){ //位置が7の時
              CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[9] == i){ //位置が11の時
              CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
          }

          objs[22].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
          finish_return = "Rightアニメーション終了";
        });
        angle += 1;
      }
    });

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);

    return Future<String?>.value(finish_return!);
  }
  Future<String?> ReverseRightMoveAnimation(){
    String scramble = "R\'";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    isRotating = true;
    int angle = 0;
    int anglenum = 45;
    int radian = 2;

    String? finish_return;

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (angle >= anglenum) {
        timer.cancel();
        isRotating = false;
      } else {
        setState(() {
          //コーナーパーツ移動
          for(int i = 0; i < 8; i++){ //要素
            if(scrambled_state.cp[1] == i){ //位置が0の時
              CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[2] == i){ //位置が3の時
              CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[5] == i){ //位置が4の時
              CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[6] == i){ //位置が7の時
              CubeCpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
          }

          //エッジパーツ移動
          for(int i = 0; i < 12; i++){ //要素
            if(scrambled_state.ep[1] == i){ //位置が0の時
              CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[2] == i){ //位置が3の時
              CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[5] == i){ //位置が7の時
              CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[9] == i){ //位置が11の時
              CubeEpList()[i].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
            }
          }
          objs[22].rotate(Sp3dV3D(1,0,0).nor(), radian * 3.14159265359 / 180);
          finish_return = "ReverseRightアニメーション終了";

        });
        angle += 1;
      }
    });

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);

    return Future<String?>.value(finish_return!);
  }

  Future<String?> FrontMoveAnimation(){
    String scramble = "F";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    isRotating = true;
    int angle = 0;
    int anglenum = 45;
    int radian = -2;

    String? finish_return;

    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (angle >= anglenum) {
        timer.cancel();
        isRotating = false;
      } else {
        setState(() {
          //コーナーパーツ移動
          for(int i = 0; i < 8; i++){ //要素
            if(scrambled_state.cp[3] == i){ //位置が0の時
              CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[2] == i){ //位置が3の時
              CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[6] == i){ //位置が4の時
              CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[7] == i){ //位置が7の時
              CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
          }

          //エッジパーツ移動
          for(int i = 0; i < 12; i++){ //要素
            if(scrambled_state.ep[2] == i){ //位置が0の時
              CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[3] == i){ //位置が3の時
              CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[6] == i){ //位置が7の時
              CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[10] == i){ //位置が11の時
              CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
          }
          objs[14].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
          finish_return = "Frontアニメーション終了";
        });
        angle += 1;
      }
    });

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);

    return Future<String?>.value(finish_return!);
  }
  Future<String?> ReverseFrontMoveAnimation(){
    String scramble = "F\'";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    isRotating = true;
    int angle = 0;
    int anglenum = 45;
    int radian = 2;

    String? finish_return;

    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (angle >= anglenum) {
        timer.cancel();
        isRotating = false;
      } else {
        setState(() {
          //コーナーパーツ移動
          for(int i = 0; i < 8; i++){ //要素
            if(scrambled_state.cp[3] == i){ //位置が0の時
              CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[2] == i){ //位置が3の時
              CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[6] == i){ //位置が4の時
              CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[7] == i){ //位置が7の時
              CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
          }

          //エッジパーツ移動
          for(int i = 0; i < 12; i++){ //要素
            if(scrambled_state.ep[2] == i){ //位置が0の時
              CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[3] == i){ //位置が3の時
              CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[6] == i){ //位置が7の時
              CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[10] == i){ //位置が11の時
              CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
          }
          objs[14].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
          finish_return = "ReverseFrontアニメーション終了";
        });
        angle += 1;
      }
    });

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);

    return Future<String?>.value(finish_return!);
  }

  Future<String?> BackMoveAnimation(){
    String scramble = "B";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    isRotating = true;
    int angle = 0;
    int anglenum = 45;
    int radian = 2;

    String? finish_return;

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (angle >= anglenum) {
        timer.cancel();
        isRotating = false;
      } else {
        setState(() {
          //コーナーパーツ移動
          for(int i = 0; i < 8; i++){ //要素
            if(scrambled_state.cp[0] == i){ //位置が0の時
              CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[1] == i){ //位置が3の時
              CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[4] == i){ //位置が4の時
              CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[5] == i){ //位置が7の時
              CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
          }

          //エッジパーツ移動
          for(int i = 0; i < 12; i++){ //要素
            if(scrambled_state.ep[0] == i){ //位置が0の時
              CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[1] == i){ //位置が3の時
              CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[4] == i){ //位置が7の時
              CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[8] == i){ //位置が11の時
              CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
          }
          objs[13].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
          finish_return = "Backアニメーション終了";
        });
        angle += 1;
      }
    });

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);

    return Future<String?>.value(finish_return!);
  }
  Future<String?> ReverseBackMoveAnimation(){
    String scramble = "B\'";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    isRotating = true;
    int angle = 0;
    int anglenum = 45;
    int radian = -2;

    String? finish_return;

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (angle >= anglenum) {
        timer.cancel();
        isRotating = false;
      } else {
        setState(() {
          //コーナーパーツ移動
          for(int i = 0; i < 8; i++){ //要素
            if(scrambled_state.cp[0] == i){ //位置が0の時
              CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[1] == i){ //位置が3の時
              CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[4] == i){ //位置が4の時
              CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[5] == i){ //位置が7の時
              CubeCpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
          }

          //エッジパーツ移動
          for(int i = 0; i < 12; i++){ //要素
            if(scrambled_state.ep[0] == i){ //位置が0の時
              CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[1] == i){ //位置が3の時
              CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[4] == i){ //位置が7の時
              CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[8] == i){ //位置が11の時
              CubeEpList()[i].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
            }
          }

          objs[13].rotate(Sp3dV3D(0,0,1).nor(), radian * 3.14159265359 / 180);
          finish_return = "ReverseBackアニメーション終了";
        });
        angle += 1;
      }
    });

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);

    return Future<String?>.value(finish_return!);
  }

  Future<String?> DownMoveAnimation(){
    String scramble = "D";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    isRotating = true;
    int angle = 0;
    int anglenum = 45;
    int radian = 2;

    String? finish_return;

    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (angle >= anglenum) {
        timer.cancel();
        isRotating = false;
      } else {
        setState(() {
          //コーナーパーツ移動
          for(int i = 0; i < 8; i++){ //要素
            if(scrambled_state.cp[4] == i){ //位置が0の時
              CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[5] == i){ //位置が3の時
              CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[6] == i){ //位置が4の時
              CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[7] == i){ //位置が7の時
              CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
          }

          //エッジパーツ移動
          for(int i = 0; i < 12; i++){ //要素
            if(scrambled_state.ep[8] == i){ //位置が0の時
              CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[9] == i){ //位置が3の時
              CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[10] == i){ //位置が7の時
              CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[11] == i){ //位置が11の時
              CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
          }
          objs[10].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
          finish_return = "Downアニメーション終了";
        });
        angle += 1;
      }
    });

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);

    return Future<String?>.value(finish_return!);
  }
  Future<String?> ReverseDownMoveAnimation(){
    String scramble = "D\'";
    CubeState_3d? scrambled_state = scamble2state(scramble);

    scrambled_newstate = scrambled_state;

    isRotating = true;
    int angle = 0;
    //回転の調整用
    int anglenum = 45;
    int radian = -2;

    String? finish_return;

    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (angle >= anglenum) {
        timer.cancel();
        isRotating = false;
      } else {
        setState(() {
          //コーナーパーツ移動
          for(int i = 0; i < 8; i++){ //要素
            if(scrambled_state.cp[4] == i){ //位置が0の時
              CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[5] == i){ //位置が3の時
              CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[6] == i){ //位置が4の時
              CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.cp[7] == i){ //位置が7の時
              CubeCpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
          }

          //エッジパーツ移動
          for(int i = 0; i < 12; i++){ //要素
            if(scrambled_state.ep[8] == i){ //位置が0の時
              CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[9] == i){ //位置が3の時
              CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[10] == i){ //位置が7の時
              CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
            if(scrambled_state.ep[11] == i){ //位置が11の時
              CubeEpList()[i].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
            }
          }
          objs[10].rotate(Sp3dV3D(0,1,0).nor(), radian * 3.14159265359 / 180);
          finish_return = "ReverseDownアニメーション終了";
        });
        angle += 1;
      }
    });

    print(scrambled_state.cp);
    print(scrambled_state.co);
    print(scrambled_state.ep);
    print(scrambled_state.eo);

    return Future<String?>.value(finish_return!);
  }
}



// obj.fragments[0].faces[2].materialIndex = 1; //U
// obj.fragments[0].faces[3].materialIndex = 2; //L
// obj.fragments[0].faces[0].materialIndex = 3; //F
// obj.fragments[0].faces[5].materialIndex = 4; //R
// obj.fragments[0].faces[1].materialIndex = 5; //B
// obj.fragments[0].faces[4].materialIndex = 6; //D
void CpCubeCreate(Sp3dObj obj, int x, int y, int z){

  //cp0
  if(x == 0 && y == 2 && z == 0){
    obj.fragments[0].faces[1].materialIndex = 5; //B
    obj.fragments[0].faces[3].materialIndex = 2; //L
    obj.fragments[0].faces[2].materialIndex = 1; //U
  }

  //cp1
  if(x == 2 && y == 2 && z == 0){
    obj.fragments[0].faces[1].materialIndex = 5; //B
    obj.fragments[0].faces[5].materialIndex = 4; //R
    obj.fragments[0].faces[2].materialIndex = 1; //U
  }

  //cp2
  if(x == 2 && y == 2 && z == 2){
    obj.fragments[0].faces[0].materialIndex = 3; //F
    obj.fragments[0].faces[5].materialIndex = 4; //R
    obj.fragments[0].faces[2].materialIndex = 1; //U
  }

  //cp3
  if(x == 0 && y == 2 && z == 2){
    obj.fragments[0].faces[3].materialIndex = 2; //L
    obj.fragments[0].faces[0].materialIndex = 3; //F
    obj.fragments[0].faces[2].materialIndex = 1; //U
  }

  //cp4
  if(x == 0 && y == 0 && z == 0){
    obj.fragments[0].faces[3].materialIndex = 2; //L
    obj.fragments[0].faces[1].materialIndex = 5; //B
    obj.fragments[0].faces[4].materialIndex = 6; //D
  }

  //cp5
  if(x == 2 && y == 0 && z == 0){
    obj.fragments[0].faces[1].materialIndex = 5; //B
    obj.fragments[0].faces[5].materialIndex = 4; //R
    obj.fragments[0].faces[4].materialIndex = 6; //D
  }

  //cp6
  if(x == 2 && y == 0 && z == 2){
    obj.fragments[0].faces[5].materialIndex = 4; //R
    obj.fragments[0].faces[4].materialIndex = 6; //D
    obj.fragments[0].faces[0].materialIndex = 3; //F
  }

  //cp7
  if(x == 0 && y == 0 && z == 2){
    obj.fragments[0].faces[0].materialIndex = 3; //F
    obj.fragments[0].faces[3].materialIndex = 2; //L
    obj.fragments[0].faces[4].materialIndex = 6; //D
  }

}

void EpCubeCreate(Sp3dObj obj, int x, int y, int z){

  //ep0
  if(x == 0 && y == 1 && z == 0){
    obj.fragments[0].faces[1].materialIndex = 5; //B
    obj.fragments[0].faces[3].materialIndex = 2; //L
  }

  //ep1
  if(x == 2 && y == 1 && z == 0){
    obj.fragments[0].faces[1].materialIndex = 5; //B
    obj.fragments[0].faces[5].materialIndex = 4; //R
  }

  //ep2
  if(x == 2 && y == 1 && z == 2){
    obj.fragments[0].faces[0].materialIndex = 3; //F
    obj.fragments[0].faces[5].materialIndex = 4; //R
  }

  //ep3
  if(x == 0 && y == 1 && z == 2){
    obj.fragments[0].faces[3].materialIndex = 2; //L
    obj.fragments[0].faces[0].materialIndex = 3; //F
  }

  //ep4
  if(x == 1 && y == 2 && z == 0){
    obj.fragments[0].faces[1].materialIndex = 5; //B
    obj.fragments[0].faces[2].materialIndex = 1; //U
  }

  //ep5
  if(x == 2 && y == 2 && z == 1){
    obj.fragments[0].faces[5].materialIndex = 4; //R
    obj.fragments[0].faces[2].materialIndex = 1; //U
  }

  //ep6
  if(x == 1 && y == 2 && z == 2){
    obj.fragments[0].faces[0].materialIndex = 3; //F
    obj.fragments[0].faces[2].materialIndex = 1; //U
  }

  //ep7
  if(x == 0 && y == 2 && z == 1){
    obj.fragments[0].faces[3].materialIndex = 2; //L
    obj.fragments[0].faces[2].materialIndex = 1; //U
  }
  
  //ep8
  if(x == 1 && y == 0 && z == 0){
    obj.fragments[0].faces[1].materialIndex = 5; //B
    obj.fragments[0].faces[4].materialIndex = 6; //D
  }

  //ep9
  if(x == 2 && y == 0 && z == 1){
    obj.fragments[0].faces[5].materialIndex = 4; //R
    obj.fragments[0].faces[4].materialIndex = 6; //D
  }

   //ep10
   if(x == 1 && y == 0 && z == 2){
      obj.fragments[0].faces[4].materialIndex = 6; //D
      obj.fragments[0].faces[0].materialIndex = 3; //F
   }

   //ep11
  if(x == 0 && y == 0 && z == 1){
    obj.fragments[0].faces[3].materialIndex = 2; //L
    obj.fragments[0].faces[4].materialIndex = 6; //D
  }

}

void CenterPartsCreate(Sp3dObj obj, int x, int y, int z){
  
  //center white
  if(x == 1 && y == 2 && z == 1){
     obj.fragments[0].faces[2].materialIndex = 1; //U
  }

  //center red
  if(x == 2 && y == 1 && z == 1){
    obj.fragments[0].faces[5].materialIndex = 4; //R
  }

  //center green
  if(x == 1 && y == 1 && z == 2){
    obj.fragments[0].faces[0].materialIndex = 3; //F
  }

   //center orange
   if(x == 0 && y == 1 && z == 1){
      obj.fragments[0].faces[3].materialIndex = 2; //L
    }

  //center yellow
  if(x == 1 && y == 0 && z == 1){
    obj.fragments[0].faces[4].materialIndex = 6; //D
  }

  //center bule
  if(x == 1 && y == 1 && z == 0){
    obj.fragments[0].faces[1].materialIndex = 5; //B
  }

  
}