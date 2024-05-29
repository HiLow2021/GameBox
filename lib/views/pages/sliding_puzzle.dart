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
  static const slideSound = 'sliding_puzzle/sound.mp3';

  final _key = GlobalKey();
  final _audioPlayer = AudioPlayer();
  final _manager = SlidingPuzzleManager(4, 4, null)..initialize();

  Size? getWidgetSize(GlobalKey key) {
    final size = key.currentContext?.size;

    return size;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final small = width < threshold;
    final strokeWidth = small ? 10.0 : 20.0;

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
                onPanStart: (DragStartDetails details) async {
                  var isSucceeded = false;

                  setState(() {
                    final size = getWidgetSize(_key);
                    if (size != null) {
                      final cellSizeX =
                          (size.width - strokeWidth * 2) / _manager.board.width;
                      final cellSizeY = (size.height - strokeWidth * 2) /
                          _manager.board.height;
                      final x =
                          ((details.localPosition.dx - strokeWidth) / cellSizeX)
                              .toInt();
                      final y =
                          ((details.localPosition.dy - strokeWidth) / cellSizeY)
                              .toInt();

                      isSucceeded = _manager.slide(x, y);
                    }
                  });

                  if (isSucceeded) {
                    if (_audioPlayer.state == PlayerState.playing) {
                      await _audioPlayer.stop();
                    }

                    await _audioPlayer.play(AssetSource(slideSound));
                  }
                },
                child: CustomPaint(
                  key: _key,
                  painter: SlidingPuzzlePainter(
                      manager: _manager,
                      small: small,
                      strokeWidth: strokeWidth),
                )),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: small ? 150 : 200,
                height: small ? 40 : 50,
                child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: const ContinuousRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8)))),
                    onPressed: () => setState(() => _manager.reset()),
                    child: Text('リセット',
                        style: TextStyle(fontSize: small ? 16 : 24))),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: small ? 150 : 200,
                height: small ? 40 : 50,
                child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: const ContinuousRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8)))),
                    onPressed: () => setState(() => _manager.initialize()),
                    child: Text('次の問題',
                        style: TextStyle(fontSize: small ? 16 : 24))),
              ),
            ],
          )
        ],
      ),
    );
  }
}
