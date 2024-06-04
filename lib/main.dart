import 'package:flutter/material.dart';
import 'package:game_box/views/app.dart';
import 'package:game_box/views/components/window_utility.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WindowUtility.initialize(MyApp.title,
      width: 1200, height: 1200, minWidth: 400, minHeight: 800);

  runApp(const MyApp());
}
