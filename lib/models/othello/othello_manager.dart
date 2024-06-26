import 'package:game_box/models/othello/enums/othello_board_cell.dart';
import 'package:game_box/models/othello/othello_ai_manager.dart';
import 'package:game_box/models/othello/othello_manager_base.dart';

class OthelloManager extends OthelloManagerBase {
  OthelloManager(super.size);

  @override
  void initialize() {
    super.initialize();
    _setHighLight(currentStone);
  }

  @override
  bool next(int x, int y) {
    if (super.next(x, y)) {
      _setHighLight(currentStone);

      return true;
    }

    return false;
  }

  bool nextByAI() {
    if (isFinished) {
      return false;
    }

    final aiManager = OthelloAIManager(board.size)
      ..initialize()
      ..setBoard(board.cells, currentTurn);

    final position = aiManager.randomMethod();

    return next(position.x, position.y);
  }

  void _setHighLight(OthelloBoardCell chip) {
    board.reset(OthelloBoardCell.highLight);

    for (var x = 0; x < board.size; x++) {
      for (var y = 0; y < board.size; y++) {
        if (canPut(x, y, chip)) {
          board.set(x, y, OthelloBoardCell.highLight);
        }
      }
    }
  }
}
