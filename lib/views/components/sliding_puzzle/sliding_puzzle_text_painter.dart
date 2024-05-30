import 'package:flutter/material.dart';
import 'package:game_box/models/sliding_puzzle/sliding_puzzle_manager.dart';

class SlidingPuzzleTextPainter extends CustomPainter {
  final bool small;

  final SlidingPuzzleManager manager;

  SlidingPuzzleTextPainter({required this.manager, required this.small});

  @override
  void paint(Canvas canvas, Size size) {
    _clipRect(canvas, size);
    _drawArea(canvas, size);
    _drawText(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _clipRect(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.clipRect(rect);
  }

  void _drawArea(Canvas canvas, Size size) {
    canvas.drawColor(const Color.fromARGB(255, 221, 221, 221), BlendMode.src);

    final double strokeWidth = small ? 2 : 4;
    final strokeWidthHalf = strokeWidth / 2;
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
        Rect.fromLTWH(strokeWidthHalf, strokeWidthHalf,
            size.width - strokeWidth, size.height - strokeWidth),
        paint);
  }

  void _drawText(Canvas canvas, Size size) {
    final double fontSize = small ? 18 : 32;
    final double paddingX = small ? 60 : 80;
    final (step, clear) = _getText();

    final stepTextPainter = TextPainter(
      text: TextSpan(
        text: step,
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    stepTextPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final stepOffset =
        Offset(paddingX, (size.height - stepTextPainter.height) / 2);

    stepTextPainter.paint(canvas, stepOffset);
    stepTextPainter.dispose();

    final clearTextPainter = TextPainter(
      text: TextSpan(
        text: clear,
        style: TextStyle(
          color: Colors.red,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    clearTextPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final clearOffset = Offset(size.width - clearTextPainter.width - paddingX,
        (size.height - clearTextPainter.height) / 2);

    clearTextPainter.paint(canvas, clearOffset);
    clearTextPainter.dispose();
  }

  (String, String) _getText() {
    return ('Step ${manager.step}', manager.isSorted ? 'クリア！' : '');
  }
}
