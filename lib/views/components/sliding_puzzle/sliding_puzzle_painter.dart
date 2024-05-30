import 'package:flutter/material.dart';
import 'package:game_box/models/sliding_puzzle/sliding_puzzle_manager.dart';

class SlidingPuzzlePainter extends CustomPainter {
  final bool small;

  final double strokeWidth;

  final SlidingPuzzleManager manager;

  SlidingPuzzlePainter(
      {required this.manager, required this.small, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    _clipRect(canvas, size);
    _drawBoard(canvas, size);
    _drawStone(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _clipRect(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.clipRect(rect);
  }

  void _drawBoard(Canvas canvas, Size size) {
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

  void _drawStone(Canvas canvas, Size size) {
    final double boarderStrokeWidth = small ? 1 : 2;
    final board = manager.board;
    final cellSizeX = (size.width - strokeWidth * 2) / board.width;
    final cellSizeY = (size.height - strokeWidth * 2) / board.height;
    final paintBoarder = Paint()
      ..color = const Color.fromARGB(255, 100, 100, 100)
      ..strokeWidth = boarderStrokeWidth
      ..style = PaintingStyle.stroke;

    for (var y = 0; y < board.height; y++) {
      for (var x = 0; x < board.width; x++) {
        final cell = manager.board.get(x, y);
        if (cell == null || cell == manager.missingNumber) {
          continue;
        }

        final rect = Rect.fromLTWH(cellSizeX * x + strokeWidth,
            cellSizeY * y + strokeWidth, cellSizeX, cellSizeY);
        final paintStone = Paint()..shader = _getShader(rect);

        canvas.drawRect(rect, paintStone);
        canvas.drawRect(rect, paintBoarder);

        final isCorrect = y * board.height + x == cell;
        final textPainter =
            _getTextPainter((cell + 1).toString(), size, isCorrect);

        textPainter.paint(
            canvas,
            Offset(
                cellSizeX * x +
                    cellSizeX / 2 +
                    strokeWidth -
                    textPainter.width / 2,
                cellSizeY * y + cellSizeY / 2));
        textPainter.dispose();
      }
    }
  }

  TextPainter _getTextPainter(String text, Size size, bool isCorrect) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: isCorrect
              ? Colors.blue
              : const Color.fromARGB(255, 60, 60, 60),
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
        Color.fromARGB(255, 238, 238, 238),
        Color.fromARGB(255, 187, 187, 187),
      ],
    ).createShader(rect);
  }
}
