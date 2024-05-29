import 'package:game_box/models/vector.dart';

class SlidingPuzzleBoard {
  List<List<int>> _cells = [];

  final int width;

  final int height;

  int get square => width * height;

  List<List<int>> get cells => _cells;

  SlidingPuzzleBoard(this.width, this.height) {
    _cells = List.generate(height, (i) => List.filled(width, i));

    initialize();
    _validate();
  }

  void initialize() {
    var i = 0;
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        _cells[y][x] = i++;
      }
    }
  }

  Vector? find(int number) {
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        if (_cells[y][x] == number) {
          return Vector(x, y);
        }
      }
    }

    return null;
  }

  int? get(int x, int y) {
    if (!_isWithinRange(x, y)) {
      return null;
    }

    return _cells[y][x];
  }

  bool swap(int x1, int y1, int x2, int y2) {
    if (!_isWithinRange(x1, y1) || !_isWithinRange(x2, y2)) {
      return false;
    }

    final temp = _cells[y2][x2];
    _cells[y2][x2] = _cells[y1][x1];
    _cells[y1][x1] = temp;

    return true;
  }

  bool _isWithinRange(int x, int y) {
    return 0 <= x && x < width && 0 <= y && y < height;
  }

  void _validate() {
    if (width < 3) {
      throw Exception('横のサイズは3以上にしてください。');
    }
    if (height < 3) {
      throw Exception('縦のサイズは3以上にしてください。');
    }
  }
}
