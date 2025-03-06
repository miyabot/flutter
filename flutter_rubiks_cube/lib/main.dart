import 'package:flutter/material.dart';
import 'solver.dart';
import '3d_rubiks_cube.dart';
import 'camera.dart';
import 'color_pick.dart';
import 'package:camera/camera.dart';

CameraDescription? firstCamera;
void SetfirstCamera(CameraDescription Set_firstCamera){ firstCamera = Set_firstCamera ;}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras(); //利用可能なカメラを取得
  SetfirstCamera(cameras.first);  //カメラ選択
  
  initializeMoves();
  initializeMoves_3d();

  move_names_to_index();
  move_names_to_index2();

  //遷移表
  computeCoMoveTable(moveNames, NUM_CO, moves);
  computeEoMoveTable(moveNames, NUM_EO, moves);
  computeECombinationTable(moveNames, NUM_E_COMBINATIONS, moves);

  computeCpMoveTable(move_names_ph2, NUM_CP, moves);
  computeUdEpMoveTable(move_names_ph2, NUM_UD_EP, moves);
  computeEEpMoveTable(move_names_ph2, NUM_E_EP, moves);

  computeCoEecPruneTable(moveNames,NUM_CO, NUM_E_COMBINATIONS, coMoveTable, eCombinationTable);
  computeEoEecPruneTable(moveNames,NUM_EO, NUM_E_COMBINATIONS, eoMoveTable, eCombinationTable);
  computeCpEepPruneTable(move_names_ph2, NUM_CP, NUM_E_EP, cpMoveTable,eEpMoveTable);
  computeUdepEepPruneTable(move_names_ph2, NUM_UD_EP, NUM_E_EP, udEpMoveTable, eEpMoveTable);

  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:PageManagement()
    );
  }
}

class PageManagement extends StatefulWidget {
  const PageManagement({super.key});

  @override
  State<PageManagement> createState() => _PageManagementState();
}

class _PageManagementState extends State<PageManagement> {

  //選択中のアイテム管理変数
  int _currentIndex = 0;
  int Get_currentIndex(){return _currentIndex;} //どのページにいるかを取得

  //表示するページ管理変数
  final List _page = [
    const CubeApp(),
    Camera(camera: firstCamera!),
    const Rubiks_cube_3d(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _page[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(

        //4つ以上並べる場合の設定（デフォルトでは3つまで）
        type:BottomNavigationBarType.fixed,
        
        //currentIndex:現在選択されているアイテムを指定
        currentIndex: _currentIndex,

        //アイテムがタップした時に呼ばれる
        onTap: (int selectIndex){
          //setState...画面を更新する
          setState(() {

            //_currentは現在のインデックス
            //selectはタップされたインデックス
            _currentIndex = selectIndex;
          });
        },

        //items...見た目の装飾
        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'setting'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle),label: 'account'),
        ]
      ),

    );
  }
}