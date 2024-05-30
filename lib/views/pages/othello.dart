import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:game_box/models/othello/enums/level.dart';
import 'package:game_box/models/othello/enums/player.dart';
import 'package:game_box/models/othello/enums/turn.dart';
import 'package:game_box/models/othello/othello_manager.dart';
import 'package:game_box/views/components/othello/othello_painter.dart';
import 'package:game_box/views/components/othello/othello_text_painter.dart';

class OthelloPage extends StatefulWidget {
  const OthelloPage({super.key});

  static const title = 'オセロ';

  @override
  State<OthelloPage> createState() => _OthelloPageState();
}

class _OthelloPageState extends State<OthelloPage> {
  static const double maxWidth = 600;
  static const threshold = 600;
  static const putSound = 'othello/sound.mp3';

  final key = GlobalKey();
  final audioPlayer = AudioPlayer();
  final manager = OthelloManager(8);

  var player = Player.black;
  var level = Level.normal;
  var useHighLight = true;
  var canTap = true;

  bool isOpponent(Turn currentTurn) =>
      (currentTurn == Turn.white && player == Player.black) ||
      (currentTurn == Turn.black && player == Player.white);

  Size? getWidgetSize(GlobalKey key) {
    final size = key.currentContext?.size;

    return size;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final small = width < threshold;

    return SizedBox(
      width: maxWidth,
      child: Column(
        children: <Widget>[
          Text(OthelloPage.title,
              style: TextStyle(
                  fontSize: small ? 30 : 40, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
                onPanStart: (DragStartDetails details) async {
                  if (!canTap) {
                    return;
                  }
      
                  canTap = false;
      
                  var isSucceeded = false;
      
                  setState(() {
                    final size = getWidgetSize(key);
                    if (size != null) {
                      final cellSize = size.width / manager.board.size;
                      final x = (details.localPosition.dx / cellSize).toInt();
                      final y = (details.localPosition.dy / cellSize).toInt();
      
                      isSucceeded = manager.next(x, y);
                    }
                  });
      
                  if (isSucceeded) {
                    setState(() => useHighLight = false);
      
                    if (audioPlayer.state == PlayerState.playing) {
                      await audioPlayer.stop();
                    }
      
                    await audioPlayer.play(AssetSource(putSound));
      
                    while (!manager.isFinished &&
                        isOpponent(manager.currentTurn)) {
                      await Future.delayed(const Duration(milliseconds: 500));
      
                      setState(() => manager.nextByAI());
                      await audioPlayer.play(AssetSource(putSound));
                    }
      
                    setState(() => useHighLight = true);
                  }
      
                  canTap = true;
                },
                child: CustomPaint(
                  key: key,
                  painter: OthelloPainter(
                      board: manager.board,
                      small: small,
                      useHighLight: useHighLight),
                )),
          ),
          SizedBox(
            width: double.infinity,
            height: small ? 50 : 80,
            child: CustomPaint(
              painter: OthelloTextPainter(
                  manager: manager, small: small, player: player),
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
                    Text('順番',
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
                      child: DropdownButton<Player>(
                        value: player,
                        focusColor: Colors.transparent,
                        padding: EdgeInsets.fromLTRB(20, 0, 10, small ? 0 : 5),
                        style: TextStyle(
                            color: Colors.black, fontSize: small ? 16 : 20),
                        underline: const SizedBox(),
                        onChanged: (Player? value) async {
                          if (!canTap || value == null || player == value) {
                            return;
                          }
      
                          setState(() {
                            player = value;
                            manager.initialize();
      
                            if (player == Player.white) {
                              manager.nextByAI();
                            }
                          });
      
                          if (player == Player.white) {
                            await audioPlayer.play(AssetSource(putSound));
                          }
                        },
                        items:
                            Player.values.map<DropdownMenuItem<Player>>((value) {
                          return DropdownMenuItem(
                              value: value,
                              child: Text(
                                  value == Player.black ? '先手(黒)' : '後手(白)'));
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
                    SizedBox(width: small ? 0 : 20, height: small ? 10 : 0),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 92, 92, 92),
                              width: 1),
                          borderRadius: BorderRadius.circular(6)),
                      child: DropdownButton<Level>(
                        value: level,
                        focusColor: Colors.transparent,
                        padding: EdgeInsets.fromLTRB(20, 0, 10, small ? 0 : 5),
                        style: TextStyle(
                            color: Colors.black, fontSize: small ? 16 : 20),
                        underline: const SizedBox(),
                        onChanged: (Level? value) async {
                          if (!canTap || value == null || level == value) {
                            return;
                          }
      
                          setState(() {
                            level = value;
                            manager.initialize();
      
                            if (player == Player.white) {
                              manager.nextByAI();
                            }
                          });
      
                          if (player == Player.white) {
                            await audioPlayer.play(AssetSource(putSound));
                          }
                        },
                        items: Level.values.map<DropdownMenuItem<Level>>((value) {
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
          const SizedBox(height: 20),
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
                            borderRadius: BorderRadius.all(Radius.circular(8)))),
                    onPressed: () async {
                      if (canTap) {
                        setState(() {
                          manager.initialize();
      
                          if (player == Player.white) {
                            manager.nextByAI();
                          }
                        });
      
                        if (player == Player.white) {
                          await audioPlayer.play(AssetSource(putSound));
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
    );
  }
}
