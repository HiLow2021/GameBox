import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:game_box/models/sliding_puzzle/sliding_puzzle_manager.dart';
import 'package:game_box/views/components/sliding_puzzle/sliding_puzzle_painter.dart';

class SlidingPuzzlePage extends StatefulWidget {
  const SlidingPuzzlePage({super.key});

  @override
  State<SlidingPuzzlePage> createState() => _SlidingPuzzlePageState();
}

class _SlidingPuzzlePageState extends State<SlidingPuzzlePage> {
  static const maxWidth = 600;
  static const threshold = 600;
  static const slideSound = 'sounds/sound.mp3';

  final _key = GlobalKey();
  final _audioPlayer = AudioPlayer();
  final _manager = SlidingPuzzleManager(4, 4, null);

  Size? getWidgetSize(GlobalKey key) {
    final size = key.currentContext?.size;

    return size;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final small = width < threshold;

    return SizedBox(
      width: maxWidth.toDouble(),
      child: Column(
        children: <Widget>[
          Text('スライドパズル',
              style: TextStyle(
                  fontSize: small ? 30 : 40, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
                onPanStart: (DragStartDetails details) {},
                child: CustomPaint(
                  key: _key,
                  painter:
                      SlidingPuzzlePainter(board: _manager.board, small: small),
                )),
          ),
        ],
      ),
    );
  }
}
