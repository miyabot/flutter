import 'dart:math';

const NUM_CORNERS = 8;
const NUM_EDGES = 12;

const NUM_CO = 2187; // 3 ** 7
const NUM_EO = 2048; // 2 ** 11
const NUM_E_COMBINATIONS = 495; // 12C4

const NUM_CP = 40320; // 8!
//const NUM_EP = 479001600  // 12! //これは使わない
const NUM_UD_EP = 40320; // 8!
const NUM_E_EP = 24; // 4!

String? solution_return;

class CubeState{

  List<int> cp; // コーナーの配置
  List<int> co; // コーナーの向き
  List<int> ep; // エッジの配置
  List<int> eo; // エッジの向き

  CubeState(this.cp, this.co, this.ep, this.eo);

   // Moveを適用し、新しい状態を返す
  CubeState applyMove(CubeState move) {
                        // generate(要素数,(要素i番目) => 引数のi番目を入れる)
    List<int> newCp = List.generate(8, (i) => cp[move.cp[i]]);
    List<int> newCo = List.generate(8, (i) => (co[move.cp[i]] + move.co[i]) % 3);
    List<int> newEp = List.generate(12, (i) => ep[move.ep[i]]);
    List<int> newEo = List.generate(12, (i) => (eo[move.ep[i]] + move.eo[i]) % 2);
    return CubeState(newCp, newCo, newEp, newEo);
  }

}

//完成状態を指す変数
CubeState solvedState = CubeState(

  [0, 1, 2, 3, 4, 5, 6, 7], // cp
  [0, 0, 0, 0, 0, 0, 0, 0], // co
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], // ep
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // eo

);

// 操作定義
Map<String, CubeState> moves = {
  'U': CubeState(
      [3, 0, 1, 2, 4, 5, 6, 7], [0, 0, 0, 0, 0, 0, 0, 0], [0, 1, 2, 3, 7, 4, 5, 6, 8, 9, 10, 11], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
  'D': CubeState(
      [0, 1, 2, 3, 5, 6, 7, 4], [0, 0, 0, 0, 0, 0, 0, 0], [0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 8], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
  'L': CubeState(
      [4, 1, 2, 0, 7, 5, 6, 3], [2, 0, 0, 1, 1, 0, 0, 2], [11, 1, 2, 7, 4, 5, 6, 0, 8, 9, 10, 3], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
  'R': CubeState(
      [0, 2, 6, 3, 4, 1, 5, 7], [0, 1, 2, 0, 0, 2, 1, 0], [0, 5, 9, 3, 4, 2, 6, 7, 8, 1, 10, 11], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
  'F': CubeState(
      [0, 1, 3, 7, 4, 5, 2, 6], [0, 0, 1, 2, 0, 0, 2, 1], [0, 1, 6, 10, 4, 5, 3, 7, 8, 9, 2, 11], [0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0]),
  'B': CubeState(
      [1, 5, 2, 3, 0, 4, 6, 7], [1, 2, 0, 0, 2, 1, 0, 0], [4, 8, 2, 3, 1, 5, 6, 7, 0, 9, 10, 11], [1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0]),
};

// moveの18種類を生成する
List<String> move_names_ph2 = ["U", "U2", "U'", "D", "D2", "D'", "L2", "R2", "F2", "B2"];
List<String> moveNames = [];
List<String> faces = moves.keys.toList();

// 18種類の操作を定義する関数
void initializeMoves() {

  //U, U2, U', D, D2, D', L, L2, L', R, R2, R', F, F2, F', B, B2, B' を作成
  for (var faceName in faces) {
    moveNames.addAll([faceName, faceName + '2', faceName + '\'']);
    moves[faceName + '2'] = moves[faceName]!.applyMove(moves[faceName]!);
    moves[faceName + '\''] = moves[faceName]!.applyMove(moves[faceName]!).applyMove(moves[faceName]!);
  }
   
}

CubeState scamble2state(scramble){

  CubeState scramble_state = solvedState;

  for(var moveNames in scramble.split(" ")){
    scramble_state = scramble_state.applyMove(moves[moveNames]!);
  }

  return scramble_state;
}

bool is_solved(CubeState state) {
  return ( List.generate(8, (i) => i).every((i) => state.cp[i] == i) && // CPが全部揃っている
           state.co.every((e) => e == 0) &&                             // COが全部揃っている
           List.generate(12, (i) => i).every((i) => state.ep[i] == i) &&// EPが全部揃っている
           state.eo.every((e) => e == 0)                                // EOが全部揃っている
         );
}

Map <String, String> inv_face = {
  "U": "D",
  "D": "U",
  "L": "R",
  "R": "L",
  "F": "B",
  "B": "F"
};

bool is_move_available(String? prev_move,String move) {

  if(prev_move == null) {
    return true;
  }

  String prev_face = prev_move[0];

  if(prev_face == move[0]) {
    return false;
  }

  if(inv_face[prev_face] == move[0]) {
    int result = prev_face.compareTo(move[0]);
    if(result == -1) return true;
    if(result == 0) return false;
    if(result == 1) return false;
  }

  return true;
}



// コーナーとエッジのカウント
int count_solved_corners(CubeState state) {
  return List.generate(8, (i) => (state.cp[i] == i && state.co[i] == 0) ? 1 : 0).reduce((a, b) => a + b);
}

int count_solved_edges(CubeState state) {
  return List.generate(12, (i) => (state.ep[i] == i && state.eo[i] == 0) ? 1 : 0).reduce((a, b) => a + b);
}

//それ以上探索を進めても無意味ならtureを返す
bool prune(int depth, CubeState state) {

  // 残り1手で揃っているコーナーが4個未満、もしくは、揃っているエッジが8個未満ならもう揃わない
  if(depth == 1 && (count_solved_corners(state) < 4 || count_solved_edges(state) < 8)){
    return true;
  }

  // 残り2手で揃っているエッジが4個未満ならもう揃わない
  if(depth == 2 && count_solved_edges(state) < 4){
    return true;
  }

  // 残り3手で揃っているエッジが2個未満ならもう揃わない
  if(depth == 3 && count_solved_edges(state) < 2){
    return true;
  }

  return false;
}

int co_to_index(List<int> co) {
  int index = 0;
  for (int co_i in co.sublist(0, co.length - 1)) {
    index *= 3;
    index += co_i;
  }
  return index;
}

List<int> index_to_co(int index) {
  List<int> co = List.filled(8, 0);
  int sumCo = 0;
  for (int i = 6; i >= 0; i--) {
    co[i] = index % 3;
    index ~/= 3;
    sumCo += co[i];
  }
  co[7] = (3 - sumCo % 3) % 3;
  return co;
}

int eo_to_index(List<int> eo) {
  int index = 0;
  for (int eo_i in eo.sublist(0, eo.length - 1)) {
    index *= 2;
    index += eo_i;
  }
  return index;
}

List<int> index_to_eo(int index) {
  List<int> eo = List.filled(12, 0);
  int sumEo = 0;
  for (int i = 10; i >= 0; i--) {
    eo[i] = index % 2;
    index ~/= 2;
    sumEo += eo[i];
  }
  eo[11] = (2 - sumEo % 2) % 2;
  return eo;
}

int calc_combination(int n, int r) {
  int result = 1;
  for (int i = 0; i < r; i++) {
    result *= (n - i);
  }
  for (int i = 0; i < r; i++) {
    result ~/= (r - i);
  }
  return result;
}

int e_combination_to_index(List<int> comb) {
  int index = 0;
  int r = 4;
  for (int i = 11; i >= 0; i--) {
    if (comb[i] == 1) {
      index += calc_combination(i, r);
      r -= 1;
    }
  }
  return index;
}

List<int> index_to_e_combination(int index) {
  List<int> combination = List.filled(12, 0);
  int r = 4;
  for (int i = 11; i >= 0; i--) {
    if (index >= calc_combination(i, r)) {
      combination[i] = 1;
      index -= calc_combination(i, r);
      r -= 1;
    }
  }
  return combination;
}

int cp_to_index(List<int> cp) {
  int index = 0;
  for (int i = 0; i < cp.length; i++) {
    index *= 8 - i;
    for (int j = i + 1; j < cp.length; j++) {
      if (cp[i] > cp[j]) {
        index += 1;
      }
    }
  }
  return index;
}

List<int> index_to_cp(int index) {
  List<int> cp = List.filled(8, 0);
  for (int i = 6; i >= 0; i--) {
    cp[i] = index % (8 - i);
    index ~/= 8 - i;
    for (int j = i + 1; j < 8; j++) {
      if (cp[j] >= cp[i]) {
        cp[j] += 1;
      }
    }
  }
  return cp;
}

int ud_ep_to_index(List<int> ep) {
  int index = 0;
  for (int i = 0; i < ep.length; i++) {
    index *= 8 - i;
    for (int j = i + 1; j < ep.length; j++) {
      if (ep[i] > ep[j]) {
        index += 1;
      }
    }
  }
  return index;
}

List<int> index_to_ud_ep(int index) {
  List<int> ep = List.filled(8, 0);
  for (int i = 6; i >= 0; i--) {
    ep[i] = index % (8 - i);
    index ~/= 8 - i;
    for (int j = i + 1; j < 8; j++) {
      if (ep[j] >= ep[i]) {
        ep[j] += 1;
      }
    }
  }
  return ep;
}

int e_ep_to_index(List<int> eep) {
  int index = 0;
  for (int i = 0; i < eep.length; i++) {
    index *= 4 - i;
    for (int j = i + 1; j < eep.length; j++) {
      if (eep[i] > eep[j]) {
        index += 1;
      }
    }
  }
  return index;
}

List<int> index_to_e_ep(int index) {
  List<int> eep = List.filled(4, 0);
  for (int i = 2; i >= 0; i--) {
    eep[i] = index % (4 - i);
    index ~/= 4 - i;
    for (int j = i + 1; j < 4; j++) {
      if (eep[j] >= eep[i]) {
        eep[j] += 1;
      }
    }
  }
  return eep;
}

List<List<int>> coMoveTable = [];

 void computeCoMoveTable(List<String> moveNames, int numCo, Map<String, CubeState> moves) {
  print("Computing co_move_table");
  coMoveTable = List.generate(numCo, (_) => List.filled(moveNames.length, 0));
  for (int i = 0; i < numCo; i++) {
    CubeState state = CubeState(List.filled(8, 0), index_to_co(i), List.filled(12, 0), List.filled(12, 0));
    for (int iMove = 0; iMove < moveNames.length; iMove++) {
      CubeState newState = state.applyMove(moves[moveNames[iMove]]!);
      coMoveTable[i][iMove] = co_to_index(newState.co);
    }
  }
  print("Finished computing co_move_table.");
}

List<List<int>> eoMoveTable = [];

void computeEoMoveTable(List<String> moveNames, int numEo, Map<String, CubeState> moves) {
  print("Computing eo_move_table");
  eoMoveTable = List.generate(numEo, (_) => List.filled(moveNames.length, 0));
  for (int i = 0; i < numEo; i++) {
    CubeState state = CubeState(List.filled(8, 0), List.filled(8, 0), List.filled(12, 0), index_to_eo(i));
    for (int iMove = 0; iMove < moveNames.length; iMove++) {
      CubeState newState = state.applyMove(moves[moveNames[iMove]]!);
      eoMoveTable[i][iMove] = eo_to_index(newState.eo);
    }
  }
  print("Finished computing eo_move_table."); 
}

List<List<int>> eCombinationTable = [];

void computeECombinationTable(List<String> moveNames, int numECombination, Map<String, CubeState> moves) {
  print("Computing e_combination_table");
  eCombinationTable = List.generate(numECombination, (_) => List.filled(moveNames.length, 0));
  for (int i = 0; i < numECombination; i++) {
    CubeState state = CubeState(List.filled(8, 0), List.filled(8, 0), index_to_e_combination(i), List.filled(12, 0));
    for (int iMove = 0; iMove < moveNames.length; iMove++) {
      CubeState newState = state.applyMove(moves[moveNames[iMove]]!);
      eCombinationTable[i][iMove] = e_combination_to_index(newState.ep);
    }
  }
  print("Finished computing e_combination_table.");
}

List<List<int>> cpMoveTable = [];

void computeCpMoveTable(List<String> moveNamesPh2, int numCp, Map<String, CubeState> moves) {
  print("Computing cp_move_table");
  cpMoveTable = List.generate(numCp, (_) => List.filled(moveNamesPh2.length, 0));
  for (int i = 0; i < numCp; i++) {
    CubeState state = CubeState(index_to_cp(i), List.filled(8, 0), List.filled(12, 0), List.filled(12, 0));
    for (int iMove = 0; iMove < moveNamesPh2.length; iMove++) {
      CubeState newState = state.applyMove(moves[moveNamesPh2[iMove]]!);
      cpMoveTable[i][iMove] = cp_to_index(newState.cp);
    }
  }
  print("Finished computing cp_move_table.");
}

List<List<int>> udEpMoveTable = [];

void computeUdEpMoveTable(List<String> moveNamesPh2, int numUdEp, Map<String, CubeState> moves) {
  print("Computing ud_ep_move_table");
  udEpMoveTable = List.generate(numUdEp, (_) => List.filled(moveNamesPh2.length, 0));
  for (int i = 0; i < numUdEp; i++) {
    CubeState state = CubeState(List.filled(8, 0), List.filled(8, 0), [0, 0, 0, 0] + index_to_ud_ep(i), List.filled(12, 0));
    for (int iMove = 0; iMove < moveNamesPh2.length; iMove++) {
      CubeState newState = state.applyMove(moves[moveNamesPh2[iMove]]!);
      udEpMoveTable[i][iMove] = ud_ep_to_index(newState.ep.sublist(4));
    }
  }
  print("Finished computing ud_ep_move_table.");
}

List<List<int>> eEpMoveTable = [];

void computeEEpMoveTable(List<String> moveNamesPh2, int numEEp, Map<String, CubeState> moves) {
  print("Computing e_ep_move_table");
  eEpMoveTable = List.generate(numEEp, (_) => List.filled(moveNamesPh2.length, 0));
  for (int i = 0; i < numEEp; i++) {
    CubeState state = CubeState(List.filled(8, 0), List.filled(8, 0), index_to_e_ep(i) + List.filled(8, 0), List.filled(12, 0));
    for (int iMove = 0; iMove < moveNamesPh2.length; iMove++) {
      CubeState newState = state.applyMove(moves[moveNamesPh2[iMove]]!);
      eEpMoveTable[i][iMove] = e_ep_to_index(newState.ep.sublist(0, 4));
    }
  }
  print("Finished computing e_ep_move_table.");
}

 List<List<int>> coEecPruneTable = [];

 void computeCoEecPruneTable(List<String> moveNames, int numCo, int numECombinations, List<List<int>> coMoveTable, List<List<int>> eCombinationTable) {
  print("Computing co_eec_prune_table");
  coEecPruneTable = List.generate(numCo, (_) => List.filled(numECombinations, -1));
  coEecPruneTable[0][0] = 0;
  int distance = 0;
  int numFilled = 1;

  while (numFilled != numCo * numECombinations) {
    print("distance = $distance");
    print("num_filled = $numFilled");
    for (int iCo = 0; iCo < numCo; iCo++) {
      for (int iEec = 0; iEec < numECombinations; iEec++) {
        if (coEecPruneTable[iCo][iEec] == distance) {
          for (int iMove = 0; iMove < moveNames.length; iMove++) {
            int nextCo = coMoveTable[iCo][iMove];
            int nextEec = eCombinationTable[iEec][iMove];
            if (coEecPruneTable[nextCo][nextEec] == -1) {
              coEecPruneTable[nextCo][nextEec] = distance + 1;
              numFilled++;
            }
          }
        }
      }
    }
    distance++;
  }
  print("Finished computing co_eec_prune_table.");
}

List<List<int>> eoEecPruneTable = [];

void computeEoEecPruneTable(List<String> moveNames, int numEo, int numECombinations, List<List<int>> eoMoveTable, List<List<int>> eCombinationTable) {
  print("Computing eo_eec_prune_table");
  eoEecPruneTable = List.generate(numEo, (_) => List.filled(numECombinations, -1));
  eoEecPruneTable[0][0] = 0;
  int distance = 0;
  int numFilled = 1;

  while (numFilled != numEo * numECombinations) {
    print("distance = $distance");
    print("num_filled = $numFilled");
    for (int iEo = 0; iEo < numEo; iEo++) {
      for (int iEec = 0; iEec < numECombinations; iEec++) {
        if (eoEecPruneTable[iEo][iEec] == distance) {
          for (int iMove = 0; iMove < moveNames.length; iMove++) {
            int nextEo = eoMoveTable[iEo][iMove];
            int nextEec = eCombinationTable[iEec][iMove];
            if (eoEecPruneTable[nextEo][nextEec] == -1) {
              eoEecPruneTable[nextEo][nextEec] = distance + 1;
              numFilled++;
            }
          }
        }
      }
    }
    distance++;
  }
  print("Finished computing eo_eec_prune_table.");
}

List<List<int>> cpEepPruneTable = [];

void computeCpEepPruneTable(List<String> moveNamesPh2, int numCp, int numEEp, List<List<int>> cpMoveTable, List<List<int>> eEpMoveTable) {
  print("Computing cp_eep_prune_table");
  cpEepPruneTable = List.generate(numCp, (_) => List.filled(numEEp, -1));
  cpEepPruneTable[0][0] = 0;
  int distance = 0;
  int numFilled = 1;

  while (numFilled != numCp * numEEp) {
    print("distance = $distance");
    print("num_filled = $numFilled");
    for (int iCp = 0; iCp < numCp; iCp++) {
      for (int iEep = 0; iEep < numEEp; iEep++) {
        if (cpEepPruneTable[iCp][iEep] == distance) {
          for (int iMove = 0; iMove < moveNamesPh2.length; iMove++) {
            int nextCp = cpMoveTable[iCp][iMove];
            int nextEep = eEpMoveTable[iEep][iMove];
            if (cpEepPruneTable[nextCp][nextEep] == -1) {
              cpEepPruneTable[nextCp][nextEep] = distance + 1;
              numFilled++;
            }
          }
        }
      }
    }
    distance++;
  }
  print("Finished computing cp_eep_prune_table.");
}

List<List<int>> udepEepPruneTable = [];

void computeUdepEepPruneTable(List<String> moveNamesPh2, int numUdEp, int numEEp, List<List<int>> udEpMoveTable, List<List<int>> eEpMoveTable) {
  print("Computing udep_eep_prune_table");
  udepEepPruneTable = List.generate(numUdEp, (_) => List.filled(numEEp, -1));
  udepEepPruneTable[0][0] = 0;
  int distance = 0;
  int numFilled = 1;

  while (numFilled != numUdEp * numEEp) {
    print("distance = $distance");
    print("num_filled = $numFilled");
    for (int iUdEp = 0; iUdEp < numUdEp; iUdEp++) {
      for (int iEep = 0; iEep < numEEp; iEep++) {
        if (udepEepPruneTable[iUdEp][iEep] == distance) {
          for (int iMove = 0; iMove < moveNamesPh2.length; iMove++) {
            int nextUdEp = udEpMoveTable[iUdEp][iMove];
            int nextEep = eEpMoveTable[iEep][iMove];
            if (udepEepPruneTable[nextUdEp][nextEep] == -1) {
              udepEepPruneTable[nextUdEp][nextEep] = distance + 1;
              numFilled++;
            }
          }
        }
      }
    }
    distance++;
  }
  print("Finished computing udep_eep_prune_table.");
}

Map<String, int> moveNamesToIndex = {};

void move_names_to_index(){
  // moveNamesリストからインデックスを生成
  for (int i = 0; i < moveNames.length; i++) {
    moveNamesToIndex[moveNames[i]] = i;
  }
}

Map<String, int> moveNamesToIndexPh2 = {};

void move_names_to_index2(){

  // moveNamesPh2リストからインデックスを生成
  for (int i = 0; i < move_names_ph2.length; i++) {
    moveNamesToIndexPh2[move_names_ph2[i]] = i;
  }
}

class Search {
  CubeState initialState;
  List<String> currentSolutionPh1 = [];
  List<String> currentSolutionPh2 = [];
  int maxSolutionLength = 9999;
  String? bestSolution;
  late double start;

  Search(this.initialState);

  bool depthLimitedSearchPh1(int coIndex, int eoIndex, int eCombIndex, int depth) {
    if (depth == 0 && coIndex == 0 && eoIndex == 0 && eCombIndex == 0) {
      String? lastMove = currentSolutionPh1.isNotEmpty ? currentSolutionPh1.last : null;
      if (lastMove == null || ["R", "L", "F", "B", "R'", "L'", "F'", "B'"].contains(lastMove)) {
        CubeState state = initialState;
        for (String moveName in currentSolutionPh1) {
          state = state.applyMove(moves[moveName]!);
        }
        return startPhase2(state);
      }
    }

    if (depth == 0) {
      return false;
    }

    // 枝刈り
    if (max(coEecPruneTable[coIndex][eCombIndex], eoEecPruneTable[eoIndex][eCombIndex]) > depth) {
      return false;
    }

    String? prevMove = currentSolutionPh1.isNotEmpty ? currentSolutionPh1.last : null;
    for (String moveName in moveNames) {
      if (!is_move_available(prevMove, moveName)) {
        continue;
      }
      currentSolutionPh1.add(moveName);
      int moveIndex = moveNamesToIndex[moveName]!;
      int nextCoIndex = coMoveTable[coIndex][moveIndex];
      int nextEoIndex = eoMoveTable[eoIndex][moveIndex];
      int nextECombIndex = eCombinationTable[eCombIndex][moveIndex];
      bool found = depthLimitedSearchPh1(nextCoIndex, nextEoIndex, nextECombIndex, depth - 1);
      currentSolutionPh1.removeLast();
      if (found) {
        return true;
      }
    }

    return false;
  }

  bool depthLimitedSearchPh2(int cpIndex, int udepIndex, int eepIndex, int depth) {
    if (depth == 0 && cpIndex == 0 && udepIndex == 0 && eepIndex == 0) {
      String solution = currentSolutionPh1.join(' ') + " " + currentSolutionPh2.join(' ') + " ";
      print("Solution: $solution (${currentSolutionPh1.length + currentSolutionPh2.length} moves) in ${DateTime.now().millisecondsSinceEpoch - start} ms.");
      maxSolutionLength = currentSolutionPh1.length + currentSolutionPh2.length - 1;
      bestSolution = solution;
      solution_return = solution;
      return true;
    }

    if (depth == 0) {
      return false;
    }

    if (max(cpEepPruneTable[cpIndex][eepIndex], udepEepPruneTable[udepIndex][eepIndex]) > depth) {
      return false;
    }

    String? prevMove;
    if (currentSolutionPh2.isNotEmpty) {
      prevMove = currentSolutionPh2.last;
    } else if (currentSolutionPh1.isNotEmpty) {
      prevMove = currentSolutionPh1.last;
    }

    for (String moveName in move_names_ph2) {
      if (!is_move_available(prevMove, moveName)) {
        continue;
      }
      currentSolutionPh2.add(moveName);
      int moveIndex = moveNamesToIndexPh2[moveName]!;
      int nextCpIndex = cpMoveTable[cpIndex][moveIndex];
      int nextUdepIndex = udEpMoveTable[udepIndex][moveIndex];
      int nextEepIndex = eEpMoveTable[eepIndex][moveIndex];
      bool found = depthLimitedSearchPh2(nextCpIndex, nextUdepIndex, nextEepIndex, depth - 1);
      currentSolutionPh2.removeLast();
      if (found) {
        return true;
      }
    }

    return false;
  }

  Future<String?> startSearch({int maxLength = 30, int timeout = 3}) async {
    return await _runWithTimeout(() => startSearchInternal(maxLength), timeout);
  }

  Future<void> startSearchInternal(int maxLength) async {
    start = DateTime.now().millisecondsSinceEpoch.toDouble();
    maxSolutionLength = maxLength;

    int coIndex =co_to_index(initialState.co);
    int eoIndex = eo_to_index(initialState.eo);
    List<int> eCombination = initialState.ep.map((e) => e < 4 ? 1 : 0).toList();
    int eCombIndex = e_combination_to_index(eCombination);

    int depth = 0;
    while (depth <= maxSolutionLength) {
      print("# Start searching phase 1 length $depth");
      if (depthLimitedSearchPh1(coIndex, eoIndex, eCombIndex, depth)) {
        break;
      }
      depth++;
    }
  }

  bool startPhase2(CubeState state) {
    int cpIndex = cp_to_index(state.cp);
    int udepIndex = ud_ep_to_index(state.ep.sublist(4));
    int eepIndex = e_ep_to_index(state.ep.sublist(0, 4));

    int depth = 0;
    while (depth <= maxSolutionLength - currentSolutionPh1.length) {
      if (depthLimitedSearchPh2(cpIndex, udepIndex, eepIndex, depth)) {
        return true;
      }
      depth++;
    }

    return false;
  }

  Future<String?> _runWithTimeout<T>(Function function, int timeoutSeconds) async {
    try {
      return await function().timeout(Duration(seconds: timeoutSeconds));
    } catch (e) {
      print("Timeout occurred: $e");
      return bestSolution;
    }
  }
}
