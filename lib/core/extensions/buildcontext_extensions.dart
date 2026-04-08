import 'package:flutter/material.dart';

extension BuildcontextExtensions on BuildContext {
  // dialog returns true
  void closeNavi({bool? dialogReturn}) {
    Navigator.pop(this, dialogReturn);
  }

  void goRoute({required Widget Function(BuildContext context) builder}) {
    Navigator.push(this, MaterialPageRoute(builder: builder));
  }

  Brightness get platformBrightness {
    return MediaQuery.of(this).platformBrightness;
  }

  bool get isBrightnessDark {
    return platformBrightness == Brightness.dark;
  }

  bool get isBrightnessLight {
    return platformBrightness == Brightness.light;
  }
}
