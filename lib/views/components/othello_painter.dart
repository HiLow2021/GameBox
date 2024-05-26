import 'package:flutter/material.dart';

import 'package:game_box/models/othello_board.dart';
import 'package:game_box/models/othello_board_cell.dart';
import 'package:game_box/models/vector.dart';

class OthelloPainter extends CustomPainter {
  final _strokeWidthThreshold = 640;

  final OthelloBoard board;

  OthelloPainter({required this.board});

  @override
  void paint(Canvas canvas, Size size) {
    final th = _strokeWidthThreshold;
    final strokeWidth = size.width < th || size.height < th ? 2.0 : 4.0;

    _clipRect(canvas, size);
    _drawBoard(canvas, size, strokeWidth);
    _drawStone(canvas, size, strokeWidth);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _clipRect(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.clipRect(rect);
  }

  void _drawBoard(Canvas canvas, Size size, double strokeWidth) {
    canvas.drawColor(const Color.fromARGB(255, 37, 183, 42), BlendMode.src);

    final halfStrokeWidth = strokeWidth / 2;
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
        Rect.fromLTWH(halfStrokeWidth, halfStrokeWidth,
            size.width - strokeWidth, size.height - strokeWidth),
        paint);

    for (var i = 1; i < board.size; i++) {
      canvas.drawLine(Offset(0, i * (size.height / board.size)),
          Offset(size.width, i * (size.height / board.size)), paint);
      canvas.drawLine(Offset(i * (size.width / board.size), 0),
          Offset(i * (size.width / board.size), size.height), paint);
    }
  }

  void _drawStone(Canvas canvas, Size size, double strokeWidth) {
    final paintBlack = Paint()..color = Colors.black;
    final paintWhite = Paint()..color = Colors.white;
    final cellSize = size.width / board.size;
    final halfCellSize = cellSize / 2;
    final stoneSize = cellSize / 3;

    for (var y = 0; y < board.size; y++) {
      for (var x = 0; x < board.size; x++) {
        final cell = board.get(Vector(x, y));
        if (cell == OthelloBoardCell.black || cell == OthelloBoardCell.white) {
          final paint =
              cell == OthelloBoardCell.black ? paintBlack : paintWhite;
          canvas.drawCircle(
              Offset(x * cellSize + halfCellSize, y * cellSize + halfCellSize),
              stoneSize,
              paint);
        }
      }
    }
  }
}
