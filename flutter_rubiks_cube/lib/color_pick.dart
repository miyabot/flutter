import 'package:collection/collection.dart'; 
import 'package:flutter/material.dart';
import 'solver.dart';

class CubeApp extends StatelessWidget {
  const CubeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CubeScreen(),
    );
  }
}

class CubeScreen extends StatefulWidget {
  const CubeScreen({super.key});
  @override
  _CubeScreenState createState() => _CubeScreenState();
}

class _CubeScreenState extends State<CubeScreen> {
  // 各面の色リスト（54マス: U, L, F, R, B, D）
  List<Color> faceColors = List.generate(54, (index) => Colors.grey);

  List<Color> GetfaceColors(){return faceColors;} // 別クラスに持っていくための関数

  // 色選択用のカラーピッカー
  Future<void> _pickColor(int index) async {
    Color? selectedColor = await showDialog<Color>(
      context: context,
      builder: (context) => ColorPickerDialog(),
    );
    if (selectedColor != null) {
      setState(() {
        faceColors[index] = selectedColor; // 選択した色を入れる
        //debugPrint('${faceColors[index]}:[${index}]');
        //debugPrint("${faceColors.length}");   
      });
    }
  }

  // 各面のグリッドを作成するウィジェット
  Widget buildFace(List<int> indices) {
    return Column(
      children: [
        for (int i = 0; i < 3; i++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int j = 0; j < 3; j++)
                GestureDetector( // クリック出来るようにする
                  onTap: () => _pickColor(indices[i * 3 + j]),
                  child: Container(
                    width: 20,
                    height: 20,
                    margin: EdgeInsets.all(2),
                    color: faceColors[indices[i * 3 + j]],
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              

            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RubiksCubeSolver'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // 上面 U
            Padding(
              padding: const EdgeInsets.only(right: 72.0), // 右に余白を追加して中央に寄せる
              child:buildFace([ 0, 1, 2, 
                                3, 4, 5, 
                                6, 7, 8]),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 左面 L
                buildFace([ 9,  10, 11, 
                            12, 13, 14, 
                            15, 16, 17]),
                // 前面 F
                buildFace([ 18, 19, 20, 
                            21, 22, 23, 
                            24, 25, 26]),
                // 右面 R
                buildFace([ 27, 28, 29, 
                            30, 31, 32, 
                            33, 34, 35]),
                // 後面 B
                buildFace([ 36, 37, 38, 
                            39, 40, 41, 
                            42, 43, 44]),
              ],
            ),

            // 下面 D
            Padding(
              padding: const EdgeInsets.only(right: 72.0), // 右に余白を追加して中央に寄せる
              child: buildFace([ 45, 46, 47, 
                                 48, 49, 50, 
                                 51, 52, 53]),
            ),

            SizedBox(height: 30,),

            ElevatedButton( onPressed: (){
                              setState(() {
                                PartsNumbering(GetfaceColors());
                              });
                              
                            },
                            child: Text("キューブを揃える")
                          ),

            SizedBox(height: 30,),
            
            Text("$solution_return",
                  style: TextStyle(
                    fontSize: 36
                  ),
            ),

          ],

        ),
      ),
    );
  }

  
}


// カラーピッカーダイアログ
class ColorPickerDialog extends StatelessWidget {
  final List<Color> availableColors = [
    Colors.white,
    Colors.orange,
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('色を選択してください'),
      content: SingleChildScrollView(
        child: Column(
          children: availableColors
              .map((color) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(color);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: 50,
                      height: 50,
                      color: color,
                      //decoration: BoxDecoration(
                        //border: Border.all(color: Colors.black),
                      //),
                    ),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: Text('キャンセル'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}


//String? solution_return;
//String? Getsolution(){return solution_return;}
//String? Setsolution(){solution_return;}

//選択された色と位置に従ってパーツのナンバリングをする関数
void PartsNumbering(List<Color> Face_Color) async{
    //完成状態
    List<int> PN_cp = [0, 1, 2, 3, 4, 5, 6, 7]; // コーナーパーツの位置
    List<int> PN_co = [0, 0, 0, 0, 0, 0, 0, 0]; // コーナーパーツの向き
    List<int> PN_ep = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]; // エッジパーツの位置
    List<int> PN_eo = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // エッジパーツの向き

    // キューブの各面を色で表す: U, L, F, R, B, D
    List<List<int>> cube = [
      [0, 0, 0, 0, 0, 0, 0, 0, 0], // U
      [1, 1, 1, 1, 1, 1, 1, 1, 1], // L
      [2, 2, 2, 2, 2, 2, 2, 2, 2], // F
      [3, 3, 3, 3, 3, 3, 3, 3, 3], // R
      [4, 4, 4, 4, 4, 4, 4, 4, 4], // B
      [5, 5, 5, 5, 5, 5, 5, 5, 5], // D
    ];

    //色の定義
    const Color w   = Colors.white; // 白 = 0
    const Color o  = Colors.orange; // 橙 = 1
    const Color g   = Colors.green; // 緑 = 2
    const Color r     = Colors.red; // 赤 = 3
    const Color b    = Colors.blue; // 青 = 4
    const Color y  = Colors.yellow; // 黄 = 5
  
  //入力された色に応じて番号を振り分ける
  for(int i = 0; i < 54; i++){

    if(i >= 0 && i <= 8){ // U面
      switch(Face_Color[i]){
        case w:
          cube[0][i] = 0;
          break;

        case o:
          cube[0][i] = 1; 
          break;

        case g:
          cube[0][i] = 2;
          break;

        case r:
          cube[0][i] = 3;
          break;

        case b:
          cube[0][i] = 4;
          break;

        case y:
          cube[0][i] = 5;
          break;
      }
    }

    if(i >= 9 && i <= 17){
      switch(Face_Color[i]){ //L面
        case w:
          cube[1][i - 9] = 0;
          break;

        case o:
          cube[1][i - 9] = 1; 
          break;

        case g:
          cube[1][i - 9] = 2;
          break;

        case r:
          cube[1][i - 9] = 3;
          break;

        case b:
          cube[1][i - 9] = 4;
          break;

        case y:
          cube[1][i - 9] = 5;
          break;
      }
    }

    if(i >= 18 && i <= 26){ // F面
      switch(Face_Color[i]){
        case w:
          cube[2][i - 18] = 0;
          break;

        case o:
          cube[2][i - 18] = 1; 
          break;

        case g:
          cube[2][i - 18] = 2;
          break;

        case r:
          cube[2][i - 18] = 3;
          break;

        case b:
          cube[2][i - 18] = 4;
          break;

        case y:
          cube[2][i - 18] = 5;
          break;
      }
    }

    if(i >= 27 && i <= 35){ // R面
      switch(Face_Color[i]){
        case w:
          cube[3][i - 27] = 0;
          break;

        case o:
          cube[3][i - 27] = 1; 
          break;

        case g:
          cube[3][i - 27] = 2;
          break;

        case r:
          cube[3][i - 27] = 3;
          break;

        case b:
          cube[3][i - 27] = 4;
          break;

        case y:
          cube[3][i - 27] = 5;
          break;
      }
    }

    if(i >= 36 && i <= 44){ // B面
      switch(Face_Color[i]){
        case w:
          cube[4][i - 36] = 0;
          break;

        case o:
          cube[4][i - 36] = 1; 
          break;

        case g:
          cube[4][i - 36] = 2;
          break;

        case r:
          cube[4][i - 36] = 3;
          break;

        case b:
          cube[4][i - 36] = 4;
          break;

        case y:
          cube[4][i - 36] = 5;
          break;
      }
    }

    if(i >= 45 && i <= 53){ // D面
      switch(Face_Color[i]){
        case w:
          cube[5][i - 45] = 0;
          break;

        case o:
          cube[5][i - 45] = 1; 
          break;

        case g:
          cube[5][i - 45] = 2;
          break;

        case r:
          cube[5][i - 45] = 3;
          break;

        case b:
          cube[5][i - 45] = 4;
          break;

        case y:
          cube[5][i - 45] = 5;
          break;
      }
    }
  }

  for(int i =0;i < 6; i++){
    print("cube: ${cube[i]}"); // デバックコンソールに表示
  }

  // コーナーパーツとエッジパーツをナンバリング
  PN_cp = getCornerPermutation(cube);
  PN_co = getCornerOrientation(cube);
  PN_ep = getEdgePermutation(cube);
  PN_eo = getEdgeOrientation(cube);

  // デバックコンソールに表示
  print("CP: $PN_cp");
  print("CO: $PN_co");
  print("EP: $PN_ep");
  print("EO: $PN_eo");

  CubeState scrambled_state = CubeState(PN_cp, PN_co, PN_ep, PN_eo);

  // CubeState scrambled_state = CubeState( getCornerPermutation(cube),
  //                                        getCornerOrientation(cube),
  //                                        getEdgePermutation(cube),
  //                                        getEdgeOrientation(cube));

  Search search = Search(scrambled_state);

  String? solution = await search.startSearch();
  
  //print("Finished! (${search.stopwatch.elapsedMilliseconds / 1000} sec.)");
  if (solution != null) {
    print("Solution: $solution");
  } else {
    print("Solution not found.");
  }
  }

List<int> getCornerPermutation(List<List<int>> cube) {
  // コーナーパーツの位置を表すリスト
  List<int> cp = List.filled(8, 0);

  // 各コーナーの色の組み合わせ
  List<List<int>> cornerColors = [
    [cube[0][0], cube[4][2], cube[1][0]], // UBL cp0
    [cube[0][2], cube[4][0], cube[3][2]], // UBR cp1
    [cube[0][8], cube[2][2], cube[3][0]], // UFR cp2
    [cube[0][6], cube[1][2], cube[2][0]], // UFL cp3
    [cube[5][6], cube[4][8], cube[1][6]], // DBL cp4
    [cube[5][8], cube[4][6], cube[3][8]], // DBR cp5
    [cube[5][2], cube[2][8], cube[3][6]], // DFR cp6
    [cube[5][0], cube[2][6], cube[1][8]], // DFL cp7
  ];

  // コーナーの色パターンを基準に、番号を判定
  List<List<int>> cornerReference = [
    [0, 4, 1], // UBL
    [0, 4, 3], // UBR
    [0, 2, 3], // UFR
    [0, 2, 1], // UFL
    [5, 4, 1], // DBL
    [5, 4, 3], // DBR
    [5, 2, 3], // DFR
    [5, 2, 1], // DFL
  ];

  // corcerColorsのパターンをもとにパーツがどこにあるかを判定
  for (int i = 0; i < 8; i++) { // cpの数分繰り返し
    for (int j = 0; j < 8; j++) { // cpのパターンの数分繰り返し
      if (_sameColors(cornerColors[i], cornerReference[j])) { 
        cp[i] = j;
        break;
      }
    }
  }

  return cp;
}

List<int> getCornerOrientation(List<List<int>> cube) {
  List<int> co = List.filled(8, 0);

  // UかDに白（0）か黄色（5）があるかで向きを判定
  List<List<int>> cornerColors = [
    [cube[0][0], cube[4][2], cube[1][0]], // UBL cp0
    [cube[0][2], cube[3][2], cube[4][0]], // URB cp1
    [cube[0][8], cube[2][2], cube[3][0]], // UFR cp2
    [cube[0][6], cube[1][2], cube[2][0]], // UFL cp3

    [cube[5][6], cube[1][6], cube[4][8]], // DBL cp4
    [cube[5][8], cube[4][6], cube[3][8]], // DBR cp5
    [cube[5][2], cube[3][6], cube[2][8]], // DFR cp6
    [cube[5][0], cube[2][6], cube[1][8]], // DFL cp7
  ];

  for (int i = 0; i < 8; i++) {
    co[i] = _calculateCornerOrientation(cornerColors[i]);
  }

  return co;
}

int _calculateCornerOrientation(List<int> colors) {

  // コーナーの向きの状態を判定するリスト
  List<List<List<int>>> cornerpattern = [
    
    // UBL cp0
    [[0, 4, 1], //上下(0)
     [4, 1, 0], //時計回り(1)
     [1, 0, 4], //反時計回り(2)
    ],

    // UBR cp1 上下、時計回り、反時計回り
    [[0, 3, 4],
     [3, 4, 0],
     [4, 0, 3],
    ],

    // UFR cp2 上下、時計回り、反時計回り
    [[0, 2, 3],
     [2, 3, 0],
     [3, 0, 2],
    ],

    // UFL cp3 上下、時計回り、反時計回り
    [[0, 1, 2],
     [1, 2, 0],
     [2, 0, 1],
    ],

    // DBL cp4 上下、時計回り、反時計回り
    [[5, 1, 4],
     [1, 4, 5],
     [4, 5, 1],
    ],

    // DBR cp5 上下、時計回り、反時計回り
    [[5, 4, 3],
     [4, 3, 5],
     [3, 5, 4],
    ],

    // DFR cp6 上下、時計回り、反時計回り
    [[5, 3, 2],
     [3, 2, 5],
     [2, 5, 3],
    ],

    // DFL cp7 上下、時計回り、反時計回り
    [[5, 2, 1],
     [2, 1, 5],
     [1, 5, 2],
    ],
  ];

  for(int i = 0; i < 8; i++){ // CPの個数分繰り返し
    for(int j = 0; j < 3; j++){ // CPの向きのパターン分繰り返し
      Function isEqual = const ListEquality().equals; // リスト同士が同じかどうか判断できる変数を作成
      if (isEqual(colors, cornerpattern[i][j])){ // colorsとcorcerpatternが同じなら
        return j; // 繰り返しの回数(0,1,2)を返す
      }
    }
  }

  return 9; // どの条件にも合わなかったら9を返す(エラー)
}

List<int> getEdgePermutation(List<List<int>> cube) {
  List<int> ep = List.filled(12, 0);

  // エッジパーツの色組み合わせ
  List<List<int>> edgeColors = [
    [cube[4][5], cube[1][3]], // BL ep0
    [cube[4][3], cube[3][5]], // BR ep1
    [cube[2][5], cube[3][3]], // FR ep2
    [cube[2][3], cube[1][5]], // FL ep3

    [cube[0][1], cube[4][1]], // UB ep4
    [cube[0][5], cube[3][1]], // UR ep5
    [cube[0][7], cube[2][1]], // UF ep6
    [cube[0][3], cube[1][1]], // UL ep7
    
    [cube[5][7], cube[4][7]], // DB ep8
    [cube[5][5], cube[3][7]], // DR ep9
    [cube[5][1], cube[2][7]], // DF ep10
    [cube[5][3], cube[1][7]], // DL ep11
  ];

  // エッジの色パターンを基準に、番号を判定
  List<List<int>> edgeReference = [
    [4, 1], // BL
    [4, 3], // BR
    [2, 3], // FR
    [2, 1], // FL

    [0, 4], // UB
    [0, 3], // UR
    [0, 2], // UF
    [0, 1], // UL

    [5, 4], // DB
    [5, 3], // DR
    [5, 2], // DF
    [5, 1], // DL
  ];

  for (int i = 0; i < 12; i++) {
    for (int j = 0; j < 12; j++) {
      if (_sameColors(edgeColors[i], edgeReference[j])) {
        ep[i] = j;
        break;
      }
    }
  }

  return ep;
}

List<int> getEdgeOrientation(List<List<int>> cube) {
  List<int> eo = List.filled(12, 0);

  // エッジの向きを判定
  List<List<int>> edgeColors = [
    [cube[4][5], cube[1][3]], // BL ep0
    [cube[4][3], cube[3][5]], // BR ep1
    [cube[2][5], cube[3][3]], // FR ep2
    [cube[2][3], cube[1][5]], // FL ep3

    [cube[0][1], cube[4][1]], // UB ep4
    [cube[0][5], cube[3][1]], // UR ep5
    [cube[0][7], cube[2][1]], // UF ep6
    [cube[0][3], cube[1][1]], // UL ep7
    
    [cube[5][7], cube[4][7]], // DB ep8
    [cube[5][5], cube[3][7]], // DR ep9
    [cube[5][1], cube[2][7]], // DF ep10
    [cube[5][3], cube[1][7]], // DL ep11
  ];

  for (int i = 0; i < 12; i++) {
    eo[i] = _calculateEdgeOrientation(edgeColors[i]);
  }

  return eo;
}

int _calculateEdgeOrientation(List<int> colors) {

  // エッジの色パターンを基準に、番号を判定
  List<List<List<int>>> edgepattern = [

     // BL ep0
    [[4, 1], // eo0
     [1, 4], // eo1
    ],
    // BR ep1
    [[4, 3], // eo0
     [3, 4], // eo1
    ],
     // FR ep2
    [[2, 3], // eo0
     [3, 2], // eo1
    ],
    // FL ep3
    [[2, 1], // eo0
     [1, 2], // eo1
    ],
 
    // UB ep4
    [[0, 4],
     [4, 0],
    ],    
    // UR ep5
    [[0, 3],
     [3, 0],
    ], 
     // UF ep6
    [[0, 2],
     [2, 0],
    ],
    // UL ep7
    [[0, 1], 
     [1, 0],
    ],

    // DB ep8
    [[5, 4],
     [4, 5],
    ],
    // DR ep9
    [[5, 3],
     [3, 5],
    ],
    // DF ep10
    [[5, 2],
     [2, 5],
    ],
    // DL ep11
    [[5, 1],
     [1, 5],
    ],
  ];

  for(int i = 0; i < 12; i++){ // epの個数分繰り返し
    for(int j = 0; j < 2; j++){ // epの向きのパターン分繰り返し
      Function isEqual = const ListEquality().equals; // リスト同士が同じかどうか判断できる変数を作成
      if (isEqual(colors, edgepattern[i][j])){ // colorsとcorcerpatternが同じなら
        return j; // 繰り返しの回数(0,1)を返す
      }
    }
  }


  return 9; // 条件に合わなかったら9を返す（エラー）
}

// 色の比較を行う関数
bool _sameColors(List<int> a, List<int> b) {
  return Set.from(a).containsAll(b)&& Set.from(b).containsAll(a);
}

