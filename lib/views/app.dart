import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:game_box/models/enums/level.dart';
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

  var _player = Player.black;
  var _level = Level.normal;
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
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: small ? 12 : 20),
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
                            Text('順番',
                                style: TextStyle(
                                    fontSize: small ? 16 : 20,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                                width: small ? 0 : 20, height: small ? 10 : 0),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 92, 92, 92),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(6)),
                              child: DropdownButton<Player>(
                                value: _player,
                                focusColor: Colors.transparent,
                                padding: EdgeInsets.fromLTRB(
                                    20, 0, 10, small ? 0 : 5),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: small ? 16 : 20),
                                underline: const SizedBox(),
                                onChanged: (Player? value) async {
                                  if (!_canTap ||
                                      value == null ||
                                      _player == value) {
                                    return;
                                  }

                                  setState(() {
                                    _player = value;
                                    _manager.initialize();

                                    if (_player == Player.white) {
                                      _manager.nextByAI();
                                    }
                                  });

                                  if (_player == Player.white) {
                                    await _audioPlayer
                                        .play(AssetSource(putSound));
                                  }
                                },
                                items: Player.values
                                    .map<DropdownMenuItem<Player>>((value) {
                                  return DropdownMenuItem(
                                      value: value,
                                      child: Text(value == Player.black
                                          ? '先手(黒)'
                                          : '後手(白)'));
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
                        Builder(builder: (context) {
                          final widget = <Widget>[
                            Text('難易度',
                                style: TextStyle(
                                    fontSize: small ? 16 : 20,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                                width: small ? 0 : 20, height: small ? 10 : 0),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 92, 92, 92),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(6)),
                              child: DropdownButton<Level>(
                                value: _level,
                                focusColor: Colors.transparent,
                                padding: EdgeInsets.fromLTRB(
                                    20, 0, 10, small ? 0 : 5),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: small ? 16 : 20),
                                underline: const SizedBox(),
                                onChanged: (Level? value) async {
                                  if (!_canTap ||
                                      value == null ||
                                      _level == value) {
                                    return;
                                  }

                                  setState(() {
                                    _level = value;
                                    _manager.initialize();

                                    if (_player == Player.white) {
                                      _manager.nextByAI();
                                    }
                                  });

                                  if (_player == Player.white) {
                                    await _audioPlayer
                                        .play(AssetSource(putSound));
                                  }
                                },
                                items: Level.values
                                    .map<DropdownMenuItem<Level>>((value) {
                                  return DropdownMenuItem(
                                      value: value, child: const Text('普通'));
                                }).toList(),
                              ),
                            ),
                          ];

                          if (small) {
                            return Column(children: widget);
                          } else {
                            return Row(children: widget);
                          }
                        })
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
                                backgroundColor: Colors.green[700],
                                shape: const ContinuousRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)))),
                            onPressed: () async {
                              if (_canTap) {
                                setState(() {
                                  _manager.initialize();

                                  if (_player == Player.white) {
                                    _manager.nextByAI();
                                  }
                                });

                                if (_player == Player.white) {
                                  await _audioPlayer
                                      .play(AssetSource(putSound));
                                }
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
