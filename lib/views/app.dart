import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:game_box/models/enums/player.dart';
import 'package:game_box/models/enums/turn.dart';
import 'package:game_box/models/othello_manager.dart';
import 'package:game_box/views/components/othello_painter.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const title = 'Game Box';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyApp.title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const putSound = 'sounds/sound.mp3';

  final _key = GlobalKey();
  final _audioPlayer = AudioPlayer();
  final _manager = OthelloManager(8);

  final _player = Player.black;
  var _useHighLight = true;
  var _canTap = true;

  bool isOpponent(Turn currentTurn) =>
      (currentTurn == Turn.white && _player == Player.black) ||
      (currentTurn == Turn.black && _player == Player.white);

  Size? getWidgetSize(GlobalKey key) {
    final size = key.currentContext?.size;

    return size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(MyApp.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: GestureDetector(
              onPanStart: (DragStartDetails details) async {
                if (!_canTap) {
                  return;
                }

                _canTap = false;

                var isSucceeded = false;

                setState(() {
                  final size = getWidgetSize(_key);
                  if (size != null) {
                    final cellSize = size.width / _manager.board.size;
                    final x = (details.localPosition.dx / cellSize).toInt();
                    final y = (details.localPosition.dy / cellSize).toInt();

                    isSucceeded = _manager.next(x, y);
                  }
                });

                if (isSucceeded) {
                  setState(() => _useHighLight = false);
                  
                  if(_audioPlayer.state == PlayerState.playing){
                    await _audioPlayer.stop();
                  }
                  
                  await _audioPlayer.play(AssetSource(putSound));

                  while (!_manager.isFinished &&
                      isOpponent(_manager.currentTurn)) {
                    await Future.delayed(const Duration(milliseconds: 500));

                    setState(() => _manager.nextByAI());
                    await _audioPlayer.play(AssetSource(putSound));
                  }

                  setState(() => _useHighLight = true);
                }

                _canTap = true;
              },
              child: AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  key: _key,
                  painter: OthelloPainter(
                      board: _manager.board, useHighLight: _useHighLight),
                ),
              )),
        ),
      ),
    );
  }
}
