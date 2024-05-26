import 'package:game_box/models/othello_board_cell.dart';
import 'package:game_box/models/vector.dart';

class OthelloBoard {
  List<List<OthelloBoardCell>> _cells = [];

  int size;

  int get halfSize => size ~/ 2;

  List<List<OthelloBoardCell>> get cells => _cells;

  OthelloBoard(this.size) {
    _cells =
        List.generate(size, (i) => List.filled(size, OthelloBoardCell.empty));

    validate();
    initialize();
  }

  void initialize() {
    for (var y = 0; y < cells.length; y++) {
      for (var x = 0; x < cells[y].length; x++) {
        cells[y][x] = OthelloBoardCell.empty;
      }
    }

    cells[halfSize - 1][halfSize - 1] = OthelloBoardCell.white;
    cells[halfSize][halfSize - 1] = OthelloBoardCell.black;
    cells[halfSize - 1][halfSize] = OthelloBoardCell.black;
    cells[halfSize][halfSize] = OthelloBoardCell.white;
  }

  OthelloBoardCell get(Vector position) {
    if (!isWithinRange(position)) {
      return OthelloBoardCell.outOfRange;
    }

    return cells[position.y][position.x];
  }

  void set(Vector position, OthelloBoardCell cell) {
    if (!isWithinRange(position)) {
      return;
    }

    cells[position.y][position.x] = cell;
  }

  int getCount(OthelloBoardCell cell) {
    var count = 0;
    for (var y = 0; y < cells.length; y++) {
      for (var x = 0; x < cells[y].length; x++) {
        if (cells[y][x] == cell) {
          count++;
        }
      }
    }

    return count;
  }

  bool isWithinRange(Vector position) {
    return 0 <= position.x &&
        position.x < size &&
        0 <= position.y &&
        position.y < size;
  }

  void validate() {
    if (size < 3) {
      throw Exception('盤面のサイズは3以上にしてください。');
    }
  }
}
