import 'package:flutter/material.dart';

class Destination {
  const Destination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<Destination> destinations = <Destination>[
  Destination('オセロ', Icon(Icons.sports_esports_outlined), Icon(Icons.sports_esports)),
  Destination('スライドパズル', Icon(Icons.sports_esports_outlined), Icon(Icons.sports_esports)),
];
