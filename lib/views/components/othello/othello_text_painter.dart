import 'package:flutter/material.dart';
import 'package:game_box/models/othello/enums/othello_board_cell.dart';
import 'package:game_box/models/othello/enums/player.dart';
import 'package:game_box/models/othello/enums/result.dart';
import 'package:game_box/models/othello/enums/turn.dart';
import 'package:game_box/models/othello/othello_manager.dart';

class OthelloTextPainter extends CustomPainter {
  final bool small;

  final OthelloManager manager;

  final Player player;

  OthelloTextPainter(
      {required this.manager, required this.small, required this.player});

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = small ? 2 : 4;
    final s = Size(size.width - strokeWidth, size.height - strokeWidth);

    _clipRect(canvas, s, strokeWidth);
    _drawArea(canvas, s, strokeWidth);
    _drawText(canvas, s, strokeWidth);
    _drawCount(canvas, s, strokeWidth, true);
    _drawCount(canvas, s, strokeWidth, false);
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

  void _drawArea(Canvas canvas, Size size, double strokeWidth) {
    canvas.drawColor(const Color.fromARGB(255, 92, 92, 92), BlendMode.src);

    final strokeWidthHalf = strokeWidth / 2;
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
        Rect.fromLTWH(strokeWidthHalf, 0, size.width, size.height + strokeWidth)
            .translate(0, -strokeWidthHalf),
        paint);
  }

  void _drawText(Canvas canvas, Size size, double strokeWidth) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: _getText(),
        style: TextStyle(
          color: Colors.white,
          fontSize: small ? 18 : 32,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final offset = Offset((size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2);

    textPainter.paint(canvas, offset);
    textPainter.dispose();
  }

  void _drawCount(Canvas canvas, Size size, double strokeWidth, bool isBlack) {
    final cellSize = size.width / manager.board.size;
    final stoneSize = cellSize / 3;
    final paint = Paint()..color = isBlack ? Colors.black : Colors.white;
    final cx = isBlack ? cellSize : size.width - cellSize;

    canvas.drawCircle(Offset(cx, size.height / 2), stoneSize, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: manager.board
            .getCount(isBlack ? OthelloBoardCell.black : OthelloBoardCell.white)
            .toString(),
        style: TextStyle(
          color: isBlack ? Colors.white : Colors.black,
          fontSize: small ? 18 : 32,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final tx = isBlack
        ? cellSize - textPainter.width / 2
        : size.width - cellSize - textPainter.width / 2;
    final offset = Offset(tx, (size.height - textPainter.height) / 2);

    textPainter.paint(canvas, offset);
    textPainter.dispose();
  }

  String _getText() {
    final result = manager.result;
    final currentTurn = manager.currentTurn;

    if (result == Result.undecided) {
      if ((currentTurn == Turn.black && player == Player.black) ||
          (currentTurn == Turn.white && player == Player.white)) {
        return 'プレイヤーのターンです';
      } else {
        return 'AIのターンです';
      }
    } else if (result == Result.draw) {
      return '引き分けです';
    } else if ((result == Result.black && player == Player.black) ||
        (result == Result.white && player == Player.white)) {
      return 'プレイヤーの勝利です';
    } else {
      return 'AIの勝利です';
    }
  }
}
