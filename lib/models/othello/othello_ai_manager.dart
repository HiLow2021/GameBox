import 'dart:math';

import 'package:game_box/models/othello/enums/othello_board_cell.dart';
import 'package:game_box/models/othello/enums/turn.dart';
import 'package:game_box/models/othello/othello_manager_base.dart';
import 'package:game_box/models/vector.dart';

class OthelloAIManager extends OthelloManagerBase {
  OthelloAIManager(super.size);

  void setBoard(List<List<OthelloBoardCell>> cells, Turn currentTurn) {
    board.setAll(cells);
    this.currentTurn = currentTurn;
  }

  Vector randomMethod() {
    int x, y;

    do {
      x = Random().nextInt(board.size + 1);
      y = Random().nextInt(board.size + 1);
    } while (!canPut(x, y, currentStone));

    return Vector(x, y);
  }
}
