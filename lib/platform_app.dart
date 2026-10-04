import 'package:apyar_app/core/utils/app_util.dart';
import 'package:apyar_app/keys.dart';
import 'package:apyar_app/ui/platforms/desktop/desktop_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class PlatformApp extends StatefulWidget {
  const new({super.key});

  @override
  State<PlatformApp> createState() => _PlatformAppState();
}

class _PlatformAppState extends State<PlatformApp> {
  final cf = AppUtil.instance.config;
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
    return DesktopHomeScreen();
  }
}
