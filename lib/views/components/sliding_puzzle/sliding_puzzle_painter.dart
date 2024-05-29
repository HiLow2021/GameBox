import 'package:flutter/material.dart';
import 'package:game_box/models/sliding_puzzle/sliding_puzzle_board.dart';

class SlidingPuzzlePainter extends CustomPainter {
  final bool small;

  final SlidingPuzzleBoard board;

  SlidingPuzzlePainter({required this.board, required this.small});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = small ? 10.0 : 20.0;

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
    final outerStrokeWidthHalf = strokeWidth / 2;
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
        Rect.fromLTWH(outerStrokeWidthHalf, outerStrokeWidthHalf,
            size.width - strokeWidth, size.height - strokeWidth),
        paint);
  }

  void _drawStone(Canvas canvas, Size size, double strokeWidth) {
    final cellSize = (size.width - strokeWidth * 2) / board.width;
    final cellSizeHalf = cellSize / 2;
    final boarderStrokeWidth = small ? 1.0 : 2.0;
    final paintBoarder = Paint()
      ..color = const Color.fromARGB(255, 100, 100, 100)
      ..strokeWidth = boarderStrokeWidth
      ..style = PaintingStyle.stroke;

    for (var y = 0; y < board.height; y++) {
      for (var x = 0; x < board.width; x++) {
        final rect = Rect.fromLTWH(cellSize * x + strokeWidth,
            cellSize * y + strokeWidth, cellSize, cellSize);
        final paintStone = Paint()..shader = _getShader(rect);

        canvas.drawRect(rect, paintStone);
        canvas.drawRect(rect, paintBoarder);
      }
    }

    var i = 0;
    for (var y = 0; y < board.height; y++) {
      for (var x = 0; x < board.width; x++) {
        final textPainter = _getTextPainter((++i).toString(), size);

        textPainter.paint(
            canvas,
            Offset(
                cellSize * x +
                    cellSizeHalf +
                    strokeWidth -
                    textPainter.width / 2,
                cellSize * y + cellSizeHalf));
        textPainter.dispose();
      }
    }
  }

  TextPainter _getTextPainter(String text, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: const Color.fromARGB(255, 60, 60, 60),
          fontSize: small ? 20 : 32,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    return textPainter;
  }

  Shader _getShader(Rect rect) {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(255, 200, 200, 200),
        Color.fromARGB(255, 150, 150, 150),
      ],
    ).createShader(rect);
  }
}
