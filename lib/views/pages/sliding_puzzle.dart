import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:game_box/models/sliding_puzzle/sliding_puzzle_manager.dart';
import 'package:game_box/views/components/sliding_puzzle/sliding_puzzle_painter.dart';
import 'package:game_box/views/components/sliding_puzzle/sliding_puzzle_text_painter.dart';

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
  var _manager = SlidingPuzzleManager(4, 4, null)..initialize();
  var _size = 4;

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
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: small ? 50 : 80,
            child: CustomPaint(
              painter:
                  SlidingPuzzleTextPainter(manager: _manager, small: small),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 20, vertical: small ? 12 : 20),
            decoration: BoxDecoration(
                color: Colors.grey[350],
                border: Border.all(
                    color: const Color.fromARGB(255, 92, 92, 92),
                    width: small ? 2 : 4)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Builder(builder: (context) {
                  final widget = <Widget>[
                    Text('サイズ',
                        style: TextStyle(
                            fontSize: small ? 16 : 20,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: small ? 0 : 20, height: small ? 10 : 0),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 92, 92, 92),
                              width: 1),
                          borderRadius: BorderRadius.circular(6)),
                      child: DropdownButton<int>(
                        value: _size,
                        focusColor: Colors.transparent,
                        padding: EdgeInsets.fromLTRB(20, 0, 10, small ? 0 : 5),
                        style: TextStyle(
                            color: Colors.black, fontSize: small ? 16 : 20),
                        underline: const SizedBox(),
                        onChanged: (int? value) async {
                          if (value == null || _size == value) {
                            return;
                          }

                          setState(() {
                            _size = value;
                            _manager = SlidingPuzzleManager(value, value, null);
                          });
                        },
                        items: List.generate(3, (i) => i + 3)
                            .map<DropdownMenuItem<int>>((value) {
                          return DropdownMenuItem(
                              value: value, child: Text(value.toString()));
                        }).toList(),
                      ),
                    ),
                  ];

                  if (small) {
                    return Column(children: widget);
                  } else {
                    return Row(children: widget);
                  }
                }),
              ],
            ),
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
