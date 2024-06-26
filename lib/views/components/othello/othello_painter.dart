import 'package:flutter/material.dart';
import 'package:game_box/models/othello/enums/othello_board_cell.dart';
import 'package:game_box/models/othello/othello_board.dart';
import 'package:game_box/models/othello/othello_manager.dart';

class OthelloPainter extends CustomPainter {
  final bool small;

  final OthelloManager manager;

  bool useHighLight;

  OthelloBoard get board => manager.board;

  OthelloPainter(
      {required this.manager, required this.small, this.useHighLight = true});

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = small ? 2 : 4;
    final s = Size(size.width - strokeWidth, size.height - strokeWidth);

    _clipRect(canvas, s, strokeWidth);
    _drawBoard(canvas, s, strokeWidth);
    _drawStone(canvas, s, strokeWidth);
    _drawHighLight(canvas, s, strokeWidth);
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
    canvas.drawColor(const Color.fromARGB(255, 0, 160, 0), BlendMode.src);

    final cellSize = size.width / board.size;
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
      canvas.drawLine(Offset(0, i * cellSize + strokeWidthHalf),
          Offset(size.width, i * cellSize + strokeWidthHalf), paint);
      canvas.drawLine(Offset(i * cellSize + strokeWidthHalf, 0),
          Offset(i * cellSize + strokeWidthHalf, size.height), paint);
    }
  }

  void _drawStone(Canvas canvas, Size size, double strokeWidth) {
    final cellSize = size.width / board.size;
    final cellSizeHalf = cellSize / 2;
    final stoneSize = cellSize / 3;
    final paintBlack = Paint()..color = Colors.black;
    final paintWhite = Paint()..color = Colors.white;

    for (var y = 0; y < board.size; y++) {
      for (var x = 0; x < board.size; x++) {
        final cell = board.get(x, y);
        if (cell == OthelloBoardCell.black || cell == OthelloBoardCell.white) {
          final paint =
              cell == OthelloBoardCell.black ? paintBlack : paintWhite;
          canvas.drawCircle(
              Offset(x * cellSize + cellSizeHalf, y * cellSize + cellSizeHalf),
              stoneSize,
              paint);
        }
      }
    }
  }

  void _drawHighLight(Canvas canvas, Size size, double strokeWidth) {
    final cellSize = size.width / board.size;
    final strokeWidthHalf = strokeWidth / 2;
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (var y = 0; y < board.size; y++) {
      for (var x = 0; x < board.size; x++) {
        if (useHighLight && board.get(x, y) == OthelloBoardCell.highLight) {
          canvas.drawRect(
              Rect.fromLTWH(
                  cellSize * x + strokeWidth + strokeWidthHalf,
                  cellSize * y + strokeWidth + strokeWidthHalf,
                  cellSize - strokeWidth * 2,
                  cellSize - strokeWidth * 2),
              paint);
        }
      }
    }
  }
}
