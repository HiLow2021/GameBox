import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowUtility {
  static Future initialize(String title,
      {int width = 800,
      int height = 600,
      int minWidth = 0,
      int minHeight = 0}) async {
    if (!Platform.isLinux && !Platform.isMacOS && !Platform.isWindows) {
      return;
    }

    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      title: title,
      size: Size(width.toDouble(), height.toDouble()),
      minimumSize: Size(minWidth.toDouble(), minHeight.toDouble()),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}
