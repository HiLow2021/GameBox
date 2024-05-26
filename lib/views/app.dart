import 'package:flutter/material.dart';

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
  final key = GlobalKey();
  final manager = OthelloManager(8);

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
              onPanStart: (DragStartDetails details) {
                setState(() {
                  final size = getWidgetSize(key);
                  if (size != null) {
                    final cellSizeX = size.width / manager.board.size;
                    final cellSizeY = size.height / manager.board.size;
                    final x = (details.localPosition.dx / cellSizeX).toInt();
                    final y = (details.localPosition.dy / cellSizeY).toInt();

                    manager.next(x, y);
                  }
                });
              },
              child: AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  key: key,
                  painter: OthelloPainter(board: manager.board),
                ),
              )),
        ),
      ),
    );
  }
}

Size? getWidgetSize(GlobalKey key) {
  final size = key.currentContext?.size;

  return size;
}
