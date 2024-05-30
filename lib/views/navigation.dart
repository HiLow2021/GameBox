import 'package:flutter/material.dart';

class Navigation {
  const Navigation(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<Navigation> destinations = <Navigation>[
  Navigation('オセロ', Icon(Icons.sports_esports_outlined), Icon(Icons.sports_esports)),
  Navigation('スライドパズル', Icon(Icons.sports_esports_outlined), Icon(Icons.sports_esports)),
];
