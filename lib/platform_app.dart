import 'dart:async';

import 'package:apyar_app/core/utils/app_util.dart';
import 'package:apyar_app/keys.dart';
import 'package:apyar_app/platforms/desktop/desktop_home_screen.dart';
import 'package:apyar_app/platforms/mobile/mobile_home_screen.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class PlatformApp extends StatefulWidget {
  const new({super.key});

  @override
  State<PlatformApp> createState() => _PlatformAppState();
}

class _PlatformAppState extends State<PlatformApp> {
  final cf = AppUtil.instance.config;
  BoxConstraints? constraints;
  Timer? _saveTimer;

  void saveSize() {
    if (constraints == null) return;
    AppUtil.instance.config
        .put(appWidthkey, constraints!.maxWidth)
        .put(appHeightkey, constraints!.maxHeight)
        .writeAll();
    debugPrint('[_DesktopHomeScreenState:saveSize]: Saved Size');
  }

  void saveDelay() {
    _saveTimer?.cancel();
    _saveTimer = Timer(Duration(seconds: 3), () {
      saveSize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: cf.stream.put.where((e) => e.key == appThemeTypeKey),
      builder: (context, asyncSnapshot) {
        return TMaterialThemeProvider(
          getTheme: () => .fromName(cf.getString(appThemeTypeKey)),
          onChanged: (type) {
            cf.putAndWriteAll(appThemeTypeKey, type.name);
          },
          child: _body,
        );
      },
    );
  }

  Widget get _body {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final isDesktop = TPlatform.isDesktop;
        if (isDesktop) {
          if (maxW <= 500) {
            return MobileHomeScreen();
          }
          return DesktopHomeScreen();
        }
        return MobileHomeScreen();
      },
    );
  }
}
