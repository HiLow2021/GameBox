import 'package:flutter/material.dart';
import 'package:game_box/views/pages/othello.dart';
import 'package:game_box/views/pages/sliding_puzzle.dart';

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
  final _selectedPageIndex = 1;

  Widget getPage() {
    switch (_selectedPageIndex) {
      case 0:
        return const OthelloPage();
      case 1:
        return const SlidingPuzzlePage();
      default:
        throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(MyApp.title),
      ),
      body: SingleChildScrollView(
          child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(40.0), child: getPage()))),
    );
  }
}
