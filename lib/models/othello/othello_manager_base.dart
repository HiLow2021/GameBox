import 'package:flutter/material.dart';
import 'package:game_box/models/othello/enums/othello_board_cell.dart';
import 'package:game_box/models/othello/enums/result.dart';
import 'package:game_box/models/othello/enums/turn.dart';
import 'package:game_box/models/othello/othello_board.dart';
import 'package:game_box/models/vector.dart';

abstract class OthelloManagerBase {
  Result _result = Result.undecided;

  Turn currentTurn = Turn.black;

  late OthelloBoard board;

  OthelloBoardCell get currentStone => currentTurn == Turn.black
      ? OthelloBoardCell.black
      : OthelloBoardCell.white;

  bool get isFinished => result != Result.undecided;

  Result get result => _result;

  OthelloManagerBase(int size) {
    board = OthelloBoard(size);
    initialize();
  }

  void initialize() {
    currentTurn = Turn.black;
    _result = Result.undecided;
    board.initialize();
  }

  bool next(int x, int y) {
    if (isFinished) {
      return false;
    }

    if (put(x, y, currentStone)) {
      rotateTurn();
      updateResult();

      return true;
    }

    return false;
  }

  @protected
  void rotateTurn() {
    final canPutBlack = canPutAll(OthelloBoardCell.black);
    final canPutWhite = canPutAll(OthelloBoardCell.white);

    if (currentTurn == Turn.black && canPutWhite) {
      currentTurn = Turn.white;
    } else if (currentTurn == Turn.white && canPutBlack) {
      currentTurn = Turn.black;
    }
  }

  @protected
  void updateResult() {
    final blackCount = board.getCount(OthelloBoardCell.black);
    final whiteCount = board.getCount(OthelloBoardCell.white);
    final canPutBlack = canPutAll(OthelloBoardCell.black);
    final canPutWhite = canPutAll(OthelloBoardCell.white);

    if (!canPutBlack && !canPutWhite) {
      if (blackCount > whiteCount) {
        _result = Result.black;
      } else if (whiteCount > blackCount) {
        _result = Result.white;
      } else {
        _result = Result.draw;
      }
    } else {
      _result = Result.undecided;
    }
  }

  @protected
  bool canPut(int x, int y, OthelloBoardCell chip) {
    final currentChip = board.get(x, y);
    if (currentChip != OthelloBoardCell.empty &&
        currentChip != OthelloBoardCell.highLight) {
      return false;
    }

    for (var v in Vector.all) {
      if (reverse(x, y, v.x, v.y, chip, true) > 0) {
        return true;
      }
    }

    return false;
  }

  @protected
  bool canPutAll(OthelloBoardCell chip) {
    for (var x = 0; x < board.size; x++) {
      for (var y = 0; y < board.size; y++) {
        if (canPut(x, y, chip)) {
          return true;
        }
      }
    }

    return false;
  }

  @protected
  bool put(int x, int y, OthelloBoardCell chip) {
    if (!canPut(x, y, chip)) {
      return false;
    }

    var count = 0;
    for (var v in Vector.all) {
      count += reverse(x, y, v.x, v.y, chip, false);
    }
    if (count > 0) {
      board.set(x, y, chip);
    }

    return count > 0;
  }

  @protected
  int reverse(int x1, int y1, int dx, int dy, OthelloBoardCell chip1,
      bool isSearchOnly) {
    x1 += dx;
    y1 += dy;

    var x2 = x1;
    var y2 = y1;
    var count = 0;
    final chip2 = board.get(x2, y2);

    if (canSearch(chip1, chip2)) {
      do {
        x2 += dx;
        y2 += dy;
      } while (board.get(x2, y2) == chip2);

      if (board.get(x2, y2) == chip1) {
        do {
          x2 -= dx;
          y2 -= dy;
          count++;

          if (!isSearchOnly) {
            board.set(x2, y2, chip1);
          }
        } while (!(x1 == x2 && y1 == y2));
      }
    }

    return count;
  }

  @protected
  bool canSearch(OthelloBoardCell chip1, OthelloBoardCell chip2) {
    return ((chip1 == OthelloBoardCell.black &&
            chip2 == OthelloBoardCell.white) ||
        (chip2 == OthelloBoardCell.black && chip1 == OthelloBoardCell.white));
  }
}
