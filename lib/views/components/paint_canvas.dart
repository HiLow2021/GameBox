import 'package:flutter/material.dart';

class PaintCanvas extends CustomPainter {
  final cellSize = const Offset(8, 8);
  final strokeWidthThreshold = 640;

  final List<Offset?> points;

  PaintCanvas({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final th = strokeWidthThreshold;
    final strokeWidth = size.width < th || size.height < th ? 2.0 : 4.0;

    _clipRect(canvas, size);
    _drawBoard(canvas, size, strokeWidth);
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

    for (var i = 1; i < cellSize.dx; i++) {
      canvas.drawLine(Offset(0, i * (size.height / 8)),
          Offset(size.width, i * (size.height / 8)), paint);
    }
    for (var i = 1; i < cellSize.dy; i++) {
      canvas.drawLine(Offset(i * (size.width / 8), 0),
          Offset(i * (size.width / 8), size.height), paint);
    }
  }
}
