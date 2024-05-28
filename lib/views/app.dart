import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:game_box/models/enums/player.dart';
import 'package:game_box/models/enums/turn.dart';
import 'package:game_box/models/othello_manager.dart';
import 'package:game_box/views/components/othello_painter.dart';
import 'package:game_box/views/components/othello_text_painter.dart';

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
  static const maxWidth = 600;
  static const threshold = 600;
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
    final width = MediaQuery.of(context).size.width;
    final small = width < threshold;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(MyApp.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: SizedBox(
              width: maxWidth.toDouble(),
              child: Column(
                children: <Widget>[
                  Text('オセロ',
                      style: TextStyle(
                          fontSize: small ? 30 : 40,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20.0),
                  AspectRatio(
                    aspectRatio: 1,
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
                              final x =
                                  (details.localPosition.dx / cellSize).toInt();
                              final y =
                                  (details.localPosition.dy / cellSize).toInt();

                              isSucceeded = _manager.next(x, y);
                            }
                          });

                          if (isSucceeded) {
                            setState(() => _useHighLight = false);

                            if (_audioPlayer.state == PlayerState.playing) {
                              await _audioPlayer.stop();
                            }

                            await _audioPlayer.play(AssetSource(putSound));

                            while (!_manager.isFinished &&
                                isOpponent(_manager.currentTurn)) {
                              await Future.delayed(
                                  const Duration(milliseconds: 500));

                              setState(() => _manager.nextByAI());
                              await _audioPlayer.play(AssetSource(putSound));
                            }

                            setState(() => _useHighLight = true);
                          }

                          _canTap = true;
                        },
                        child: CustomPaint(
                          key: _key,
                          painter: OthelloPainter(
                              board: _manager.board,
                              small: small,
                              useHighLight: _useHighLight),
                        )),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: small ? 50 : 80,
                    child: CustomPaint(
                      painter: OthelloTextPainter(
                          manager: _manager, small: small, player: _player),
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
                                backgroundColor: Colors.green[700],
                                shape: const ContinuousRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)))),
                            onPressed: () {
                              if (_canTap) {
                                setState(() => _manager.initialize());
                              }
                            },
                            child: Text('リセット',
                                style: TextStyle(fontSize: small ? 16 : 24))),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
