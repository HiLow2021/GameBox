import 'package:flutter/material.dart';
import 'package:game_box/views/pages/othello.dart';
import 'package:game_box/views/pages/sliding_puzzle.dart';

class Destination {
  const Destination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<Destination> destinations = <Destination>[
  Destination(OthelloPage.title, Icon(Icons.sports_esports_outlined),
      Icon(Icons.sports_esports)),
  Destination(SlidingPuzzlePage.title, Icon(Icons.sports_esports_outlined),
      Icon(Icons.sports_esports)),
];
