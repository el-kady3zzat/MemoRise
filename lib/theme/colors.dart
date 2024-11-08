import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

class MemoRiseColors {
  final mainBlue = Colors.blue[900];
  final noteBlue = Colors.blue[300];
  final noteTextWhite = Colors.white;

  changeStatusColor() async {
    try {
      await FlutterStatusbarcolor.setStatusBarColor(MemoRiseColors().mainBlue!);
      if (useWhiteForeground(MemoRiseColors().mainBlue!)) {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      }
    } on PlatformException catch (e) {
      debugPrint('StatusBar Color ========== ${e.toString()}');
    }
  }
}
