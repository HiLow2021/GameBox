import 'package:game_box/models/sliding_puzzle/sliding_puzzle_board.dart';
import 'package:game_box/models/vector.dart';

class SlidingPuzzleManager {
  int _step = 0;

  late List<List<int>> _question;

  late SlidingPuzzleBoard board;

  late int missingNumber;

  int get step => _step;

  bool get isSorted =>
      board.cells.expand((x) => x).indexed.every((x) => x.$1 == x.$2);

  SlidingPuzzleManager(int width, int height, int? missingNumber) {
    board = SlidingPuzzleBoard(width, height);
    this.missingNumber = missingNumber ?? board.square - 1;
    _question = _clone(board.cells);

    initialize();
    _validate();
  }

  void initialize() {
    board.initialize();
    _shuffle(board.square * board.square);
    _copy(board.cells, _question);
    reset();
  }

  void reset() {
    _step = 0;
    _copy(_question, board.cells);
  }

  bool slide(int x, int y) {
    for (var direction in Vector.allWithoutDiagonal) {
      if (board.get(x + direction.x, y + direction.y) == missingNumber) {
        final result = board.swap(x, y, x + direction.x, y + direction.y);
        if (result) {
          _step++;
        }

        return result;
      }
    }

    return false;
  }

  void _shuffle([int max = 1000]) {
    while (isSorted) {
      var missingNumberPosition = board.find(missingNumber);
      if (missingNumberPosition == null) {
        return;
      }

      var x = missingNumberPosition.x;
      var y = missingNumberPosition.y;

      for (var index = 0; index < max; index++) {
        for (var direction in [...Vector.all]..shuffle()) {
          if (slide(x + direction.x, y + direction.y)) {
            x += direction.x;
            y += direction.y;

            break;
          }
        }
      }
    }
  }

  void _validate() {
    if (missingNumber >= board.square && board.square < 0) {
      throw Exception(
          'missingNumberは0以上${(board.square - 1).toString()}以下にしてください。');
    }
  }

  void _copy<int>(List<List<int>> source, List<List<int>> destination) {
    for (var y = 0; y < source.length; y++) {
      for (var x = 0; x < source[y].length; x++) {
        destination[y][x] = source[y][x];
      }
    }
  }

  List<List<int>> _clone(List<List<int>> source) {
    var destination =
        List.generate(source.length, (i) => List.filled(source[i].length, i));

    for (var y = 0; y < source.length; y++) {
      for (var x = 0; x < source[y].length; x++) {
        destination[y][x] = source[y][x];
      }
    }

    return destination;
  }
}
