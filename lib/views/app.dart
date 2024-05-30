import 'package:flutter/material.dart';
import 'package:game_box/views/destination.dart';
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
  static const thresholdWide = 1200;
  static const thresholdMiddle = 800;
  var _selectedPageIndex = 0;

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

  Widget drawer() {
    return NavigationDrawer(
      selectedIndex: _selectedPageIndex,
      onDestinationSelected: (value) =>
          setState(() => _selectedPageIndex = value),
      children: <Widget>[
        const SizedBox(height: 20),
        ...destinations.map(
          (Destination destination) {
            return NavigationDrawerDestination(
              label: Text(destination.label),
              icon: destination.icon,
              selectedIcon: destination.selectedIcon,
            );
          },
        ),
      ],
    );
  }

  Widget sideBar(double width) {
    final isWide = width > thresholdWide;

    return NavigationRail(
      extended: isWide,
      labelType:
          isWide ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      selectedIndex: _selectedPageIndex,
      onDestinationSelected: (value) =>
          setState(() => _selectedPageIndex = value),
      destinations: destinations.map((Destination destination) {
        return NavigationRailDestination(
            label:
                Text(destination.label, style: const TextStyle(fontSize: 16)),
            icon: destination.icon,
            selectedIcon: destination.selectedIcon);
      }).toList(),
    );
  }

  Widget mainContent() {
    return SingleChildScrollView(
        child: Center(
            child: Padding(
                padding: const EdgeInsets.all(40.0), child: getPage())));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMiddle = width > thresholdMiddle;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(MyApp.title),
      ),
      drawer: isMiddle ? null : drawer(),
      body: Row(
        children: <Widget?>[
          isMiddle
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: sideBar(width),
                  ),
                )
              : null,
          isMiddle ? const VerticalDivider(thickness: 1, width: 1) : null,
          Expanded(
            child: mainContent(),
          ),
        ].where((x) => x != null).cast<Widget>().toList(),
      ),
    );
  }
}
