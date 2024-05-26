import 'package:flutter/material.dart';
import 'package:game_box/models/enums/othello_board_cell.dart';
import 'package:game_box/models/othello_board.dart';

class OthelloPainter extends CustomPainter {
  final _strokeWidthThreshold = 640;

  final OthelloBoard board;

  OthelloPainter({required this.board});

  @override
  void paint(Canvas canvas, Size size) {
    final th = _strokeWidthThreshold;
    final strokeWidth = size.width < th || size.height < th ? 2.0 : 4.0;

    _clipRect(canvas, size, strokeWidth);
    _drawBoard(canvas, size, strokeWidth);
    _drawStone(canvas, size, strokeWidth);
    _drawHighLight(canvas, size, strokeWidth);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _clipRect(Canvas canvas, Size size, double strokeWidth) {
    final rect = Rect.fromLTWH(
        0, 0, size.width + strokeWidth, size.height + strokeWidth);

    canvas.clipRect(rect);
  }

  void _drawBoard(Canvas canvas, Size size, double strokeWidth) {
    canvas.drawColor(const Color.fromARGB(255, 37, 183, 42), BlendMode.src);

    final strokeWidthHalf = strokeWidth / 2;
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
        Rect.fromLTWH(
            strokeWidthHalf, strokeWidthHalf, size.width, size.height),
        paint);

    for (var i = 1; i < board.size; i++) {
      canvas.drawLine(Offset(0, i * (size.height / board.size) + strokeWidthHalf),
          Offset(size.width, i * (size.height / board.size) + strokeWidthHalf), paint);
      canvas.drawLine(Offset(i * (size.width / board.size) + strokeWidthHalf, 0),
          Offset(i * (size.width / board.size) + strokeWidthHalf, size.height), paint);
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
        final cell = board.get(x, y);
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

  void _drawHighLight(Canvas canvas, Size size, double strokeWidth) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final strokeWidthHalf = strokeWidth / 2;

    for (var y = 0; y < board.size; y++) {
      for (var x = 0; x < board.size; x++) {
        if (board.get(x, y) == OthelloBoardCell.highLight) {
          canvas.drawRect(
              Rect.fromLTWH(
                  (size.width / board.size) * x + strokeWidth + strokeWidthHalf,
                  (size.height / board.size) * y + strokeWidth + strokeWidthHalf,
                  (size.width / board.size) - strokeWidth * 2,
                  (size.height / board.size) - strokeWidth * 2),
              paint);
        }
      }
    }
  }
}
