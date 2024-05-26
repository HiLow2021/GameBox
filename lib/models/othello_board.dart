import 'package:game_box/models/enums/othello_board_cell.dart';

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
    for (var y = 0; y < _cells.length; y++) {
      for (var x = 0; x < _cells[y].length; x++) {
        _cells[y][x] = OthelloBoardCell.empty;
      }
    }

    _cells[halfSize - 1][halfSize - 1] = OthelloBoardCell.white;
    _cells[halfSize][halfSize - 1] = OthelloBoardCell.black;
    _cells[halfSize - 1][halfSize] = OthelloBoardCell.black;
    _cells[halfSize][halfSize] = OthelloBoardCell.white;
  }

  OthelloBoardCell get(int x, int y) {
    if (!isWithinRange(x, y)) {
      return OthelloBoardCell.outOfRange;
    }

    return _cells[y][x];
  }

  void set(int x, int y, OthelloBoardCell cell) {
    if (!isWithinRange(x, y)) {
      return;
    }

    _cells[y][x] = cell;
  }

  void setAll(List<List<OthelloBoardCell>> cells) {
    _cells = cells;
  }

  int getCount(OthelloBoardCell cell) {
    var count = 0;
    for (var y = 0; y < size; y++) {
      for (var x = 0; x < size; x++) {
        if (_cells[y][x] == cell) {
          count++;
        }
      }
    }

    return count;
  }

  void reset(OthelloBoardCell cell) {
    for (var y = 0; y < size; y++) {
      for (var x = 0; x < size; x++) {
        if (_cells[y][x] == cell) {
          _cells[y][x] = OthelloBoardCell.empty;
        }
      }
    }
  }

  bool isWithinRange(int x, int y) {
    return 0 <= x && x < size && 0 <= y && y < size;
  }

  void validate() {
    if (size < 3) {
      throw Exception('盤面のサイズは3以上にしてください。');
    }
  }
}
